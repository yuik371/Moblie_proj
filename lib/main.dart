import 'package:flutter/material.dart';

import 'config/app_theme.dart';
import 'screens/karrot_shell.dart';

// 앱 실행을 시작하는 진입점입니다.
void main() {
  runApp(const KarrotApp());
}

// 앱 전역 테마와 첫 화면을 등록하는 최상위 위젯입니다.
class KarrotApp extends StatelessWidget {
  const KarrotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '중고거래',
      theme: buildAppTheme(),
      home: const KarrotShell(),
    );
  }
}
