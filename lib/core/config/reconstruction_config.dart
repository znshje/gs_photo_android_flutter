import 'api_config.dart';

class ReconstructionConfig {
  static String getCreateTaskUrl() => ApiPaths.reconstructionCreateTaskPath;

  static String getStartUploadedUrl(String taskId) =>
      ApiPaths.reconstructionStartUploadedPath.replaceAll('{task_id}', taskId);

  static String getStatusUrl(String taskId) =>
      ApiPaths.reconstructionStatusPath.replaceAll('{task_id}', taskId);

  static String getCancelUrl(String taskId) =>
      ApiPaths.reconstructionCancelPath.replaceAll('{task_id}', taskId);

  static String getLogsUrl(String taskId) =>
      ApiPaths.reconstructionLogsPath.replaceAll('{task_id}', taskId);

  static String getDiagnosticsUrl(String taskId) =>
      ApiPaths.reconstructionDiagnosticsPath.replaceAll('{task_id}', taskId);

  static String getDownloadUrl(String taskId) =>
      ApiPaths.reconstructionDownloadPath.replaceAll('{task_id}', taskId);

  static String getAlgorithmsUrl() => ApiPaths.reconstructionAlgorithmsPath;
}
