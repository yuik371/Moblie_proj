import 'package:flutter/material.dart';

import '../widgets/setting_row.dart';

// 알림·채팅·언어·개인정보·로그아웃 메뉴를 제공하는 설정 화면입니다.
class SettingsView extends StatelessWidget {
  const SettingsView({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 프로필 화면으로 돌아가는 버튼입니다.
        leading: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
        title: const Text('앱 설정', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SettingRow(title: '알림 설정', subtitle: '거래 및 채팅 알림'),
          SettingRow(title: '채팅 설정', subtitle: '채팅방 알림과 안전 거래'),
          SettingRow(title: '언어 설정', subtitle: '한국어'),
          SettingRow(title: '개인정보 처리방침'),
          SettingRow(title: '로그아웃'),
        ],
      ),
    );
  }
}
