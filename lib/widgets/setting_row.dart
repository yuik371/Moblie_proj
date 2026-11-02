import 'package:flutter/material.dart';

import '../config/app_theme.dart';

// 앱 설정 메뉴의 제목·부제목·이동 아이콘을 표시합니다.
class SettingRow extends StatelessWidget {
  const SettingRow({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: ink)),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: const Icon(Icons.chevron_right, color: muted),
      ),
    );
  }
}
