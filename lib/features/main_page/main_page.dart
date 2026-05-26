import 'package:flutter/material.dart';
import '../../core/widgets/buttons/gradient_button.dart';
import '../../core/widgets/buttons/square_glass_button.dart';
import '../../core/widgets/carousel/custom_carousel.dart';
import '../../core/widgets/task/task_card.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_config.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent, // 背景已由外层容器处理
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // 5% 左右内边距
            vertical: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomCarousel(
                images: const [
                  'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2072&auto=format&fit=crop',
                  'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=2070&auto=format&fit=crop',
                  'https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?q=80&w=1887&auto=format&fit=crop',
                ],
                height: screenHeight * 0.22, // 轮播图占据 22% 高度
              ),
              SizedBox(height: screenHeight * 0.03), // 动态间距 3%
              GradientButton(
                label: '开始创建',
                onPressed: () {
                  context.push('$homeTabPath/$creationConfigPath');
                },
                height: screenHeight * 0.08, // 按钮高度占据 8%
              ),
              const TaskCard(
                title: '家庭生日相册',
                statusText: 'AI 重建中',
                progress: 0.78,
                timeRemaining: '2 分钟',
                imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=2071&auto=format&fit=crop',
              ),
              SizedBox(height: screenHeight * 0.03),

              SizedBox(height: screenHeight * 0.04),
              // 横向排列四个方形磨砂按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SquareGlassButton(
                    label: '拍摄引导',
                    icon: Icons.camera_alt_outlined,
                    onPressed: () {
                      context.push('$homeTabPath/$cameraGuidePath');
                    },
                    size: screenWidth * 0.2, // 方块按钮占据屏幕宽度 20%
                  ),
                  SquareGlassButton(
                    label: '素材整理',
                    icon: Icons.auto_awesome_motion_outlined,
                    onPressed: () => context.push('$homeTabPath/$localViewerPath'),
                    size: screenWidth * 0.2,
                  ),
                  SquareGlassButton(
                    label: '云端同步',
                    icon: Icons.cloud_done_outlined,
                    onPressed: () => debugPrint('点击：云端同步'),
                    size: screenWidth * 0.2,
                  ),
                  SquareGlassButton(
                    label: '使用说明',
                    icon: Icons.help_outline_rounded,
                    onPressed: () => debugPrint('点击：使用说明'),
                    size: screenWidth * 0.2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
