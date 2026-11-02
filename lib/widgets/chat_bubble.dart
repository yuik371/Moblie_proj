import 'package:flutter/material.dart';

import '../config/app_theme.dart';

// 채팅방에서 보낸 사람에 따라 좌우 정렬이 달라지는 말풍선입니다.
class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.text, required this.mine, super.key});

  final String text;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: mine ? const Color(0xFFFFEBDD) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(text, style: const TextStyle(color: ink)),
      ),
    );
  }
}
