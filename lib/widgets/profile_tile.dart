import 'package:flutter/material.dart';

import '../config/app_theme.dart';

// 나의 당근 메뉴 하나를 아이콘·제목·설명·이동 버튼으로 표현합니다.
class ProfileTile extends StatelessWidget {
  const ProfileTile({required this.title, required this.subtitle, required this.icon, this.onTap, super.key});

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      elevation: 0,
      child: ListTile(
        // 설정 메뉴처럼 연결된 항목을 눌렀을 때 다음 화면으로 이동합니다.
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        leading: Icon(icon, color: orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: ink)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: muted),
      ),
    );
  }
}
