import 'package:flutter/material.dart';

import '../config/app_theme.dart';

// 거래 상대와의 채팅방 목록을 보여 주는 채팅 탭입니다.
class ChatView extends StatelessWidget {
  const ChatView({required this.onRoom, super.key});

  final VoidCallback onRoom;

  @override
  Widget build(BuildContext context) {
    const names = ['민지', '따뜻한 이웃', '원목 책상 판매자'];
    const messages = ['안녕하세요! 아직 판매 중인가요?', '거래 장소를 정했어요.', '네, 오늘 저녁도 가능합니다.'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 18, 16, 4),
          child: Text('채팅', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ink)),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 13),
          child: Text('거래와 소식을 주고받아 보세요', style: TextStyle(color: muted)),
        ),
        // 채팅방 검색 기능을 연결할 자리입니다.
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: const Row(children: [Icon(Icons.search, color: muted), SizedBox(width: 10), Text('채팅방 검색', style: TextStyle(color: muted))]),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: names.length,
            padding: const EdgeInsets.only(top: 10),
            separatorBuilder: (_, __) => const Divider(indent: 82, color: line),
            itemBuilder: (_, i) => ListTile(
              // 채팅 목록을 누르면 첫 번째 채팅방 예시를 엽니다.
              onTap: onRoom,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: CircleAvatar(backgroundColor: i == 0 ? const Color(0xFFFFD1AD) : const Color(0xFFD5E2DC), child: const Icon(Icons.person_outline, color: ink)),
              title: Text(names[i], style: const TextStyle(fontWeight: FontWeight.w700, color: ink)),
              subtitle: Text(messages[i]),
              trailing: Text(i == 0 ? '방금' : '어제', style: const TextStyle(fontSize: 11, color: muted)),
            ),
          ),
        ),
      ],
    );
  }
}
