import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/widgets/bar/custom_nav_bar.dart';
import 'core/widgets/background/sci_fi_background.dart';
import 'core/router/route_adapter.dart';
import 'core/state/task_state.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GS App',
      routerConfig: RouteAdapter.createRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationWrapper extends StatelessWidget {
  const MainNavigationWrapper({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SciFiBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: navigationShell),
        bottomNavigationBar: CustomNavBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
        ),
      ),
    );
  }
}



