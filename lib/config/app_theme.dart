import 'package:flutter/material.dart';

// 앱 전체에서 사용하는 당근 스타일 색상 팔레트
const orange = Color(0xFFFF6F0F);
const ink = Color(0xFF212326);
const muted = Color(0xFF7D8287);
const line = Color(0xFFE8E9EB);
const page = Color(0xFFFAFAFA);

// 모든 화면이 공유하는 Material 테마 생성
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: page,
    colorScheme: ColorScheme.fromSeed(seedColor: orange),
    fontFamily: 'sans',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: ink,
      elevation: 0,
      centerTitle: false,
    ),
  );
}
