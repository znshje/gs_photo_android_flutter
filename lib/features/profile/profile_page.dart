import 'dart:ui';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 保持全局背景可见
      appBar: AppBar(
        title: const Text(
          '个人中心',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. 个人信息卡片 (基于原型图设计)
            _buildUserInfoCard(context),
            
            const SizedBox(height: 30),
            
            // 2. 功能列表 (预留位)
            _buildMenuItem(Icons.history, '历史记录'),
            _buildMenuItem(Icons.settings_outlined, '通用设置'),
            _buildMenuItem(Icons.info_outline, '关于我们'),
            
            const SizedBox(height: 50),
            
            // 3. 退出登录按钮
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF).withOpacity(0.05),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                // 蓝色头像圆圈
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0072FF).withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0072FF).withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person, size: 45, color: Colors.white),
                ),
                const SizedBox(width: 24),
                // 信息展示区
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '个人 ID: GS_User888',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => debugPrint('点击：修改信息'),
                        child: Text(
                          '修改信息',
                          style: TextStyle(
                            color: const Color(0xFF00C6FF).withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white.withOpacity(0.7)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
        onTap: () => debugPrint('点击了：$title'),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).pop(), // 简单返回登录页
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.red.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('退出登录', style: TextStyle(color: Colors.redAccent)),
    );
  }
}
