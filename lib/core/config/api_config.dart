// api_config.dart
class ApiPaths {
  // A: 公共的 Server Head (例如你的 GS Server 主机地址)
  static const String baseUrl = 'http://211.87.232.134';
  static const int port=8000;
  // B, C: 具体的业务模块 (例如 3D相册模块)
  static const String albumList = '/album/list';
  static const String moduleCBase = '/core_features';

  // D, E: 具体的任务项 (例如拉取特定的 3DGS 渲染配置或切片数据)
  static const String renderTaskD = '/album/render/task_d';
  static const String renderTaskE = '/album/render/task_e';
}