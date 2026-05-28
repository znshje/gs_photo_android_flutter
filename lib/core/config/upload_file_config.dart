import 'api_config.dart';

class UploadFileConfig {
  static String getUploadInitUrl() => ApiPaths.uploadInitPath;

  static String getUploadChunkUrl(String uploadId) =>
      ApiPaths.uploadChunkPath.replaceAll('{upload_id}', uploadId);

  static String getUploadProgressUrl(String uploadId) =>
      ApiPaths.uploadProgressPath.replaceAll('{upload_id}', uploadId);

  static String getUploadMergeUrl(String uploadId) =>
      ApiPaths.uploadMergePath.replaceAll('{upload_id}', uploadId);

  static String getUploadCancelUrl(String fileId) =>
      ApiPaths.uploadCancelPath.replaceAll('{file_id}', fileId);

  // 默认分片大小: 5MB
  static const int defaultChunkSize = 5 * 1024 * 1024;
}
