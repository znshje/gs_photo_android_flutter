import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../core/network/reconstruction_service.dart';
import '../../core/network/upload_service.dart';
import '../../core/widgets/background/sci_fi_background.dart';
import '../../core/widgets/buttons/gradient_button.dart';
import 'package:go_router/go_router.dart';

class ReconstructionUploadPage extends StatefulWidget {
  const ReconstructionUploadPage({super.key});

  @override
  State<ReconstructionUploadPage> createState() => _ReconstructionUploadPageState();
}

class _ReconstructionUploadPageState extends State<ReconstructionUploadPage> {
  final ReconstructionService _reconstructionService = ReconstructionService();
  final UploadService _uploadService = UploadService();
  final ImagePicker _picker = ImagePicker();
  
  List<XFile> _selectedImages = [];
  String _currentStatus = 'ready'; // ready, compressing, uploading, processing, completed, failed
  String? _taskId;
  double _progress = 0.0;
  Timer? _statusTimer;

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images;
      });
    }
  }

  Future<String?> _compressImages() async {
    setState(() {
      _currentStatus = 'compressing';
      _progress = 0.0;
    });

    try {
      final encoder = ZipFileEncoder();
      final directory = await getTemporaryDirectory();
      final zipPath = p.join(directory.path, 'upload_${DateTime.now().millisecondsSinceEpoch}.zip');
      
      encoder.create(zipPath);
      for (var image in _selectedImages) {
        encoder.addFile(File(image.path));
      }
      encoder.close();
      
      return zipPath;
    } catch (e) {
      debugPrint('压缩失败: $e');
      return null;
    }
  }

  Future<void> _startProcess() async {
    if (_selectedImages.isEmpty) return;

    // 1. 压缩图片
    final zipPath = await _compressImages();
    if (zipPath == null) {
      setState(() => _currentStatus = 'failed');
      return;
    }

    // 2. 分片上传
    setState(() {
      _currentStatus = 'uploading';
      _progress = 0.0;
    });

    try {
      final mergeRes = await _uploadService.uploadFile(
        zipPath,
        onProgress: (p) => setState(() => _progress = p),
      );

      // 3. 启动重建任务
      setState(() {
        _currentStatus = 'processing';
        _progress = 0.1;
      });

      final taskId = await _reconstructionService.startReconstruction(
        storageKey: mergeRes.storageKey,
      );

      if (taskId == null) {
        setState(() => _currentStatus = 'failed');
        return;
      }

      setState(() {
        _taskId = taskId;
      });

      // 4. 轮询状态
      _startPolling(taskId);

      // 清理临时 zip
      final zipFile = File(zipPath);
      if (await zipFile.exists()) await zipFile.delete();

    } catch (e) {
      debugPrint('处理流程失败: $e');
      setState(() => _currentStatus = 'failed');
    }
  }

  void _startPolling(String taskId) {
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final statusData = await _reconstructionService.checkStatus(taskId);
      if (statusData == null) return;

      final status = statusData['status'];
      debugPrint('任务状态: $status');

      setState(() {
        if (status == 'completed') {
          timer.cancel();
          _currentStatus = 'completed';
          _progress = 1.0;
          _downloadAndPreview(taskId);
        } else if (status == 'failed') {
          timer.cancel();
          _currentStatus = 'failed';
        } else {
          // 模拟进度增长 (0.1 ~ 0.9)
          if (_progress < 0.9) _progress += 0.05;
        }
      });
    });
  }

  Future<void> _downloadAndPreview(String taskId) async {
    // 这里可以添加下载并跳转预览逻辑
    debugPrint('任务完成，ID: $taskId');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('重建完成！模型已准备就绪。')),
    );
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('启动 3DGS 重建', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SciFiBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentStatus == 'ready') ...[
                const Icon(Icons.cloud_upload_outlined, size: 80, color: Color(0xFF00C6FF)),
                const SizedBox(height: 20),
                Text(
                  _selectedImages.isEmpty ? '请选择需要重建的图片' : '已选择 ${_selectedImages.length} 张图片',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('从相册选择图片'),
                ),
                const SizedBox(height: 20),
                if (_selectedImages.isNotEmpty)
                  GradientButton(
                    label: '开始上传并重建',
                    onPressed: _startProcess,
                  ),
              ] else ...[
                _buildStatusUI(),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusUI() {
    String message = '';
    IconData icon = Icons.sync;
    Color color = const Color(0xFF00C6FF);

    switch (_currentStatus) {
      case 'compressing':
        message = '正在打包素材...';
        icon = Icons.folder_zip_outlined;
        break;
      case 'uploading':
        message = '正在分片上传...';
        icon = Icons.cloud_upload;
        break;
      case 'processing':
        message = '算法正在重建 3D 点云...';
        icon = Icons.memory;
        break;
      case 'completed':
        message = '重建成功！';
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'failed':
        message = '处理失败，请重试';
        icon = Icons.error;
        color = Colors.red;
        break;
    }

    return Column(
      children: [
        Icon(icon, size: 80, color: color),
        const SizedBox(height: 30),
        Text(message, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        LinearProgressIndicator(
          value: _progress,
          backgroundColor: Colors.white10,
          color: color,
          minHeight: 8,
        ),
        const SizedBox(height: 20),
        Text('${(_progress * 100).toInt()}%', style: TextStyle(color: color, fontSize: 16)),
        if (_currentStatus == 'failed')
          TextButton(onPressed: () => setState(() => _currentStatus = 'ready'), child: const Text('返回重试', style: TextStyle(color: Colors.white70))),
      ],
    );
  }
}
