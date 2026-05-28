import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/task_state.dart';
import '../../core/widgets/task/task_item.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Consumer<TaskState>(
          builder: (context, taskState, child) {
            final tasks = taskState.allTasks;

            if (!taskState.isRestored) {
              return const Center(child: CircularProgressIndicator());
            }

            if (tasks.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      color: Colors.white24,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '暂无任务',
                      style: TextStyle(color: Colors.white24, fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final localPath =
                    task.files.isNotEmpty ? task.files.first.localPath : null;

                return TaskItem(
                  title: task.title,
                  creationTime: _formatDateTime(task.createdAt),
                  status: taskState.getStatusDisplay(task.status),
                  localThumbnailPath: localPath,
                  onView: () => debugPrint('查看任务: ${task.taskId}'),
                  onDelete: () => taskState.removeTask(task.taskId),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)} '
        '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }
}
