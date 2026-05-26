import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../core/widgets/task/task_item.dart';
class TaskPage extends StatelessWidget {
  const TaskPage({super.key});
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.only(top: 20),
          children: [
            TaskItem(
              title: '家庭生日相册',
              creationTime: '2026-05-08 14:30',
              status: '已完成',
              thumbnailUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=2071&auto=format&fit=crop',
              onView: () => debugPrint('查看任务'),
              onDelete: () => debugPrint('删除任务'),
            ),
            TaskItem(
              title: '公司宣传视频',
              creationTime: '2026-05-07 09:15',
              status: '已完成',
              thumbnailUrl: 'https://images.unsplash.com/photo-1497215728101-856f4ea42174?q=80&w=2070&auto=format&fit=crop',
              onView: () => debugPrint('查看任务'),
              onDelete: () => debugPrint('删除任务'),
            ),
            TaskItem(
              title: '宠物成长记录',
              creationTime: '2026-05-05 18:45',
              status: '已完成',
              thumbnailUrl: 'https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?q=80&w=2070&auto=format&fit=crop',
              onView: () => debugPrint('查看任务'),
              onDelete: () => debugPrint('删除任务'),
            ),
        ],
      ),
    );
  }
}
