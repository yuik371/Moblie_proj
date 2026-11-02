import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../widgets/chat_bubble.dart';

// 한 판매자와 실제 거래 대화를 확인하고 메시지를 전송하는 화면입니다.
class ChatRoomView extends StatelessWidget {
  const ChatRoomView({required this.sentMessage, required this.onBack, required this.onSend, super.key});

  final bool sentMessage;
  final VoidCallback onBack;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 채팅 목록으로 돌아가는 버튼입니다.
        leading: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
        title: const Text('민지', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(alignment: Alignment.centerLeft, child: Text('거래 매너를 지키며 따뜻하게 대화해요', style: TextStyle(fontSize: 12, color: muted))),
          ),
          const ChatBubble(text: '안녕하세요! 아직 판매 중인가요?', mine: false),
          const ChatBubble(text: '네, 판매 중이에요. 관심 가져주셔서 감사합니다!', mine: true),
          const ChatBubble(text: '오늘 저녁 역삼역 근처에서 거래 가능할까요?', mine: false),
          if (sentMessage) const ChatBubble(text: '네, 좋아요! 도착하면 연락드릴게요.', mine: true),
          const Spacer(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
                      decoration: BoxDecoration(color: const Color(0xFFF4F5F6), borderRadius: BorderRadius.circular(24)),
                      child: const Text('메시지 보내기', style: TextStyle(color: muted)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 전송 버튼을 누르면 예시 답장이 추가됩니다.
                  FilledButton(
                    onPressed: onSend,
                    style: FilledButton.styleFrom(backgroundColor: orange, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14)),
                    child: const Text('전송'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
