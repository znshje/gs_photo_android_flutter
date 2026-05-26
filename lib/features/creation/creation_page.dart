import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/widgets/background/sci_fi_background.dart';
import '../../core/widgets/buttons/gradient_button.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_config.dart';

class CreationPage extends StatefulWidget {
  const CreationPage({super.key});

  @override
  State<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  String _selectedQuality = '标准';
  bool _enablePostProcess = true;
  double _density = 0.7;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('物体创建配置', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SciFiBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 拍摄物体选择
              _buildSectionTitle('拍摄物体'),
              _buildGlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined, color: Color(0xFF00C6FF), size: 30),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        '未选择物体 (点击上传素材)',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                    const Icon(Icons.add_photo_alternate_outlined, color: Colors.white54),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // 2. 拍摄场景选择
              _buildSectionTitle('拍摄场景'),
              _buildGlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.landscape_outlined, color: Color(0xFFB100FF), size: 30),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        '室内实验室 - 默认场景',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // 3. 参数配置
              _buildSectionTitle('参数配置'),
              _buildGlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildParamRow('重建精度', _buildQualitySelector()),
                    const Divider(color: Colors.white10, height: 30),
                    _buildParamRow('点云密度', _buildDensitySlider()),
                    const Divider(color: Colors.white10, height: 30),
                    _buildParamRow('启用后期优化', Switch(
                      value: _enablePostProcess,
                      onChanged: (v) => setState(() => _enablePostProcess = v),
                      activeColor: const Color(0xFF00C6FF),
                    )),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.06),

              GradientButton(
                label: '开始 3DGS 重建',
                onPressed: () {
                  context.push('$homeTabPath/$creationConfigPath/$uploadProgressPath');
                },
                height: screenHeight * 0.08,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 18)}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.05),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildParamRow(String label, Widget action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        action,
      ],
    );
  }

  Widget _buildQualitySelector() {
    return Row(
      children: ['标准', '高清', '极高'].map((q) {
        bool isSelected = _selectedQuality == q;
        return GestureDetector(
          onTap: () => setState(() => _selectedQuality = q),
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF00C6FF).withValues(alpha: 0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? const Color(0xFF00C6FF) : Colors.white24),
            ),
            child: Text(q, style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontSize: 12)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDensitySlider() {
    return SizedBox(
      width: 120,
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          activeTrackColor: const Color(0xFFB100FF),
          thumbColor: const Color(0xFFB100FF),
          inactiveTrackColor: Colors.white10,
        ),
        child: Slider(
          value: _density,
          onChanged: (v) => setState(() => _density = v),
        ),
      ),
    );
  }
}
