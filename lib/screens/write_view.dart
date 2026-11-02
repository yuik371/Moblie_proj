import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../widgets/form_row.dart';

// 사진·상품 정보·설명을 입력하고 임시 상품을 등록하는 화면입니다.
class WriteView extends StatelessWidget {
  const WriteView({required this.onBack, required this.onPublish, super.key});

  final VoidCallback onBack;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 작성 취소 후 홈으로 돌아가는 버튼입니다.
        leading: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
        title: const Text('내 물건 팔기', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 사진 선택 기능을 연결할 자리입니다.
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(color: const Color(0xFFFFF1E9), borderRadius: BorderRadius.circular(11)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.camera_alt_outlined, color: orange), SizedBox(height: 6), Text('사진 추가', style: TextStyle(color: orange, fontWeight: FontWeight.w700))],
            ),
          ),
          const SizedBox(height: 22),
          const FormRow(label: '제목', hint: '상품 제목을 입력해주세요'),
          const FormRow(label: '가격', hint: '가격을 입력해주세요'),
          const FormRow(label: '카테고리', hint: '카테고리를 선택해주세요'),
          const SizedBox(height: 8),
          Container(
            height: 125,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('상품 설명', style: TextStyle(fontWeight: FontWeight.w700, color: ink)), SizedBox(height: 22), Text('상품의 상태와 거래 정보를 적어주세요', style: TextStyle(color: muted))],
            ),
          ),
          const SizedBox(height: 35),
          // 작성한 상품을 목록에 추가하고 홈으로 이동하는 버튼입니다.
          FilledButton(
            onPressed: onPublish,
            style: FilledButton.styleFrom(backgroundColor: orange, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('작성 완료', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
