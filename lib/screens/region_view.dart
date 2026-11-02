import 'package:flutter/material.dart';

import '../config/app_theme.dart';

// 현재 거래 지역을 확인하고 동네를 선택하는 화면입니다.
class RegionView extends StatelessWidget {
  const RegionView({required this.onBack, required this.onSelected, super.key});

  final VoidCallback onBack;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 동네 설정을 취소하고 홈으로 돌아가는 버튼입니다.
        leading: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
        title: const Text('내 동네 설정', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('동네를 설정하면 가까운 이웃의 소식을 볼 수 있어요', style: TextStyle(color: muted)),
          const SizedBox(height: 20),
          // 동네 검색 기능을 연결할 자리입니다.
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
            child: const Row(children: [Icon(Icons.search, color: muted), SizedBox(width: 10), Text('동네 이름(동, 읍, 면)으로 검색', style: TextStyle(color: muted))]),
          ),
          const SizedBox(height: 34),
          const Text('내 동네', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
          const SizedBox(height: 12),
          InkWell(
            // 현재 동네를 선택하면 홈으로 돌아갑니다.
            onTap: onSelected,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
              child: const Row(
                children: [
                  Icon(Icons.location_on_outlined, color: orange),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('역삼동', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink)), Text('현재 설정된 동네', style: TextStyle(fontSize: 12, color: muted))],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 23),
          // 새로운 동네를 등록할 기능을 연결할 자리입니다.
          const Text('동네 추가하기  +', style: TextStyle(color: orange, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
