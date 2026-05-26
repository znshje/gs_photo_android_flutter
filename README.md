# gs

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
````
lib/
 ├── core/                     # A: 全局公共基础设施
 │   ├── network/              # 核心网络客户端 (HttpClient)
 │   ├── router/               # 核心路由转接器 (RouteAdapter)
 │   ├── theme/                # 全局 UI 规范 (如毛玻璃效果组件)
 │   └── global_state/         # 全局状态 (如登录Token, 当前连接的 GS Server IP)
 │
 ├── features/                 # B, C: 具体的业务领域模块
 │   ├── 3d_album/             # 业务模块 1: 3D相册浏览
 │   │   ├── data/             # 相册列表拉取的 Service 和 Model
 │   │   ├── presentation/     # 页面 UI (AlbumListScreen)
 │   │   └── routes.dart       # ★ 模块内的路由节点片段
 │   │
 │   └── gs_reconstruction/    # 业务模块 2: 3DGS 重建任务 (包含具体的项 D, E)
 │       ├── data/             # 上传数据、轮询渲染进度、下载权重的 Service
 │       ├── presentation/     # 任务配置页、渲染进度页
 │       └── routes.dart       # ★ 模块内的路由节点片段
 │
 └── main.dart                 # App 入口，组装 Core 和 Features
````

使用riverpod管理状态，
现在的需要关注的全局状态
