import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../core/widgets/buttons/glass_button.dart';
import '../../core/widgets/buttons/gradient_button.dart';

import 'package:go_router/go_router.dart';

class CameraGuideScreen extends StatefulWidget {
  const CameraGuideScreen({super.key});

  @override
  State<CameraGuideScreen> createState() => _CameraGuideScreenState();
}

class _CameraGuideScreenState extends State<CameraGuideScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      } catch (e) {
        debugPrint('相机初始化失败: $e');
      }
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      debugPrint('错误: 相机未初始化');
      return;
    }

    if (_controller!.value.isTakingPicture) {
      return;
    }

    try {
      // 1. 拍摄照片
      final XFile photo = await _controller!.takePicture();

      // 2. 获取存储目录
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String capturesPath = path.join(appDocDir.path, 'captures');
      final Directory capturesDir = Directory(capturesPath);

      if (!await capturesDir.exists()) {
        await capturesDir.create(recursive: true);
      }

      // 3. 构造文件名 (IMG_20240508_143005.jpg)
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'IMG_$timestamp.jpg';
      final String finalPath = path.join(capturesPath, fileName);

      // 4. 保存文件
      await photo.saveTo(finalPath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('照片已保存至: captures/$fileName'),
            backgroundColor: Colors.green,
          ),
        );
        debugPrint('照片保存成功: $finalPath');
      }
    } catch (e) {
      debugPrint('拍摄失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('拍摄或保存失败'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. 底层：相机预览
          if (_isInitialized && _controller != null)
            SizedBox.expand(
              child: CameraPreview(_controller!),
            )
          else
            const Center(child: CircularProgressIndicator(color: Color(0xFF00C6FF))),

          // 2. 顶层：拍摄引导遮罩
          _buildOverlayGuide(context),

          // 3. 顶部返回按钮 (科幻磨砂风格)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: screenWidth * 0.05,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: screenWidth * 0.12,
                    height: screenWidth * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: screenWidth * 0.055,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayGuide(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        children: [
          // 顶部：拍摄角度建议卡片
          Container(
            margin: EdgeInsets.all(screenWidth * 0.05),
            padding: EdgeInsets.all(screenWidth * 0.04),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Column(
              children: [
                Text(
                  '拍摄角度建议',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.035),
                // 引导示意图
                _buildIllustration(screenWidth),
              ],
            ),
          ),
          
          const Spacer(),

          // 底部：操作按钮区（采用库中的按钮）
          Container(
            padding: EdgeInsets.all(screenWidth * 0.06),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              children: [
                // 使用 GlassButton 进行模式选择
                Row(
                  children: [
                    Expanded(
                      child: GlassButton(
                        label: '拍摄',
                        height: screenHeight * 0.065,
                        onPressed: () => debugPrint('切换拍摄模式'),
                        opacity: 0.3,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: GlassButton(
                        label: '录制',
                        height: screenHeight * 0.065,
                        onPressed: () => debugPrint('切换录制模式'),
                        opacity: 0.1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                // 使用 GradientButton 作为主拍摄按钮
                GradientButton(
                  label: '开 始 拍 摄',
                  onPressed: _takePicture,
                  height: screenHeight * 0.08,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Icon(Icons.arrow_downward, color: Colors.white, size: screenWidth * 0.08),
            const Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: screenWidth * 0.18,
              height: screenWidth * 0.18,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.view_in_ar, color: Colors.white, size: screenWidth * 0.09),
            ),
            Positioned(
              left: -screenWidth * 0.0125,
              bottom: screenWidth * 0.0125,
              child: Transform.rotate(
                angle: -0.5,
                child: Icon(Icons.navigation, color: Colors.yellow, size: screenWidth * 0.08),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(Icons.arrow_downward, color: Colors.white, size: screenWidth * 0.08),
            const Text('3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
