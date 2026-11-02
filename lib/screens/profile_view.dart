import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../widgets/profile_tile.dart';

// 로그인 상태와 판매·관심·설정 메뉴를 보여 주는 나의 당근 화면입니다.
class ProfileView extends StatelessWidget {
  const ProfileView({required this.loggedIn, required this.onLogin, required this.onSettings, super.key});

  final bool loggedIn;
  final VoidCallback onLogin;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      children: [
        const Text('나의 당근', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ink)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              const CircleAvatar(radius: 35, backgroundColor: Color(0xFFFFE0C3), child: Icon(Icons.person_outline, size: 35, color: ink)),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loggedIn ? '따뜻한 이웃' : '로그인해주세요', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: ink)),
                    const SizedBox(height: 6),
                    const Text('매너온도 36.5°C', style: TextStyle(color: orange, fontWeight: FontWeight.w700)),
                    if (!loggedIn) ...[
                      const SizedBox(height: 10),
                      // 로그인·회원가입 화면으로 이동하는 버튼입니다.
                      FilledButton(onPressed: onLogin, style: FilledButton.styleFrom(backgroundColor: orange), child: const Text('로그인 / 회원가입')),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ProfileTile(title: '판매내역', subtitle: '내가 올린 매물', icon: Icons.inventory_2_outlined),
        ProfileTile(title: '관심목록', subtitle: '찜한 매물', icon: Icons.bookmark_border),
        ProfileTile(title: '동네생활', subtitle: '이웃과 소통하기', icon: Icons.forum_outlined),
        ProfileTile(title: '앱 설정', subtitle: '알림 · 언어 · 계정', icon: Icons.settings_outlined, onTap: onSettings),
      ],
    );
  }
}
