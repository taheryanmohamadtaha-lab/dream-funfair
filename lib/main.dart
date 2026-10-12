import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/save.dart';
import 'screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Save.I.load();
  runApp(const FunfairApp());
}

class FunfairApp extends StatelessWidget {
  const FunfairApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Save.I,
      builder: (context, _) {
        final fa = Save.I.lang == 'fa';
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: fa ? 'شهربازی رؤیایی' : 'Dream Funfair',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF7C4DFF),
          ),
          builder: (context, child) => Directionality(
            textDirection: fa ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
