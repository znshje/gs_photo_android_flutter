class AppConfig {
  // 基础服务器地址
  static const String baseUrl = 'http://211.87.232.134';
  static const int port=8000;
  // 路由配置
  static const String publicHead = '/api/v1/';
  static const String authLoginPath = '/auth/login';
  static const String authRegisterPath = '/auth/register';
  static const String reconstructionStaPath = '/reconstruction/start';
  static const String reconstructionStatusPath = '/reconstruction/status';
  static const String reconstructionDownloadPath = '/reconstruction/download';

  // 图片上传接口路径
  static const String uploadPath = '/common/upload';

  // 分片上传接口路径
  static const String uploadInitPath = 'upload/init';
  static const String uploadChunkPath = 'upload/{upload_id}/chunk';
  static const String uploadProgressPath = 'upload/{upload_id}/progress';
  static const String uploadMergePath = 'upload/{upload_id}/merge';
  static const String uploadCancelPath = 'upload/{file_id}/cancel';

  // 模型预览接口路径 (预留)
  static const String previewPath = '/preview';

  // 认证 Token (运行时存储)
  static String? authToken;






  // 超时时间配置 (单位：毫秒)
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 30000;
}
