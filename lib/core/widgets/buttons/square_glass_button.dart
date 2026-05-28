import 'dart:ui';
import 'package:flutter/material.dart';

class SquareGlassButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final double? size;

  const SquareGlassButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = size ?? screenWidth * 0.22;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  // 深色磨砂背景
                  color: const Color(0xFFFFFFFF).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  // 边缘反光感：通过极细的高亮边框实现
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 0.8,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                    ).createShader(bounds),
                    child: Icon(
                      icon,
                      size: buttonSize * 0.45, // 图标大小根据按钮大小自动缩放
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.025),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: buttonSize * 0.15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
