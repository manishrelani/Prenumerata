import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logging/logging.dart';

import 'core/di/service_locator.dart';
import 'core/routes/route_generator.dart';
import 'core/routes/screen_name.dart';
import 'core/theme/app_theme.dart';
import 'core/util/global.dart';
import 'core/widget/custom_circuler_progress.dart';

Logger _log = Logger('main.dart');

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  _log.info('App started in debug mode 🚀');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  _log.info('Going Portrait mode screen 👹');

  runApp(
    GlobalLoaderOverlay(
      overlayColor: Colors.black38,
      overlayWidgetBuilder: (_) => const Center(child: CustomCirculerProgress()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _initializeAppServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.onGenerateRoute,
      initialRoute: ScreenName.onboard,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
    );
  }

  void _initializeAppServices() async {
    try {
      await initServiceLocator();
      _log.info('Initialization done successfully ✅');
    } catch (e, s) {
      //log
      _log.warning('Initialization failed ❌ $e $s');
    } finally {
      FlutterNativeSplash.remove();
    }
  }
}
