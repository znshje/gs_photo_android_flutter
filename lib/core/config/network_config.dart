import 'app_config.dart';

class NetworkConfig {
  static String getUploadInitUrl() => AppConfig.uploadInitPath;
  
  static String getUploadChunkUrl(String uploadId) => 
      AppConfig.uploadChunkPath.replaceAll('{upload_id}', uploadId);
      
  static String getUploadProgressUrl(String uploadId) => 
      AppConfig.uploadProgressPath.replaceAll('{upload_id}', uploadId);
      
  static String getUploadMergeUrl(String uploadId) => 
      AppConfig.uploadMergePath.replaceAll('{upload_id}', uploadId);
      
  static String getUploadCancelUrl(String fileId) => 
      AppConfig.uploadCancelPath.replaceAll('{file_id}', fileId);

  // 默认分片大小: 5MB
  static const int defaultChunkSize = 5 * 1024 * 1024;
}
