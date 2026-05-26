import 'dart:ui';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String statusText;
  final double progress; // 0.0 to 1.0
  final String timeRemaining;
  final String imageUrl;

  const TaskCard({
    super.key,
    required this.title,
    required this.statusText,
    required this.progress,
    required this.timeRemaining,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16), // 稍微减小内边距以节省空间
            color: const Color(0xFF03081C).withValues(alpha: 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '任务进行中',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // 稍微减小字号
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 左侧缩略图
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        width: screenWidth * 0.18, // 响应式宽度
                        height: screenWidth * 0.18, // 保持正方形
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // 右侧内容
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$statusText ${(progress * 100).toInt()}%',
                            style: const TextStyle(
                              color: Color(0xFF00C6FF),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // 进度条
                          Container(
                            height: 4, // 减细一点更精致
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '预计剩余 $timeRemaining',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 右侧装饰图
                    const SizedBox(width: 8),
                    _buildDecorativeRadar(screenWidth),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeRadar(double screenWidth) {
    final radarSize = screenWidth * 0.12;
    return Container(
      width: radarSize,
      height: radarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF00C6FF).withValues(alpha: 0.2), width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.radar, color: const Color(0xFF00C6FF).withValues(alpha: 0.5), size: radarSize * 0.5),
          Transform.rotate(
            angle: 0.5,
            child: Container(
              width: radarSize * 0.8,
              height: 1,
              color: const Color(0xFF00C6FF).withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

