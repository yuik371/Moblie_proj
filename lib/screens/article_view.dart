import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/listing.dart';
import '../widgets/listing_tile.dart';

// 선택한 상품의 상세 정보와 AR·채팅 진입 버튼을 보여 주는 화면입니다.
class ArticleView extends StatelessWidget {
  const ArticleView({required this.listing, required this.onBack, required this.onAr, required this.onChat, super.key});

  final Listing listing;
  final VoidCallback onBack;
  final VoidCallback onAr;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    final isPhone = listing.kind == ListingKind.iphone;
    return Scaffold(
      appBar: AppBar(
        // 뒤로 가기 버튼은 홈 목록으로 돌아갑니다.
        leading: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
        title: const Text('매물 상세', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Container(
                height: 202,
                width: double.infinity,
                color: const Color(0xFFE1E7EB),
                alignment: Alignment.center,
                child: isPhone
                    ? Image.asset('assets/iphone15_natural_titanium.png', width: 202, height: 202, fit: BoxFit.cover)
                    : ProductThumbnail(listing: listing),
              ),
              Positioned(
                right: 18,
                bottom: 11,
                child: FilledButton.icon(
                  // AR 상품 배치 미리보기 화면을 엽니다.
                  onPressed: onAr,
                  style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: ink),
                  icon: const Icon(Icons.center_focus_strong, color: orange, size: 18),
                  label: const Text('AR로 보기', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ink)),
                const SizedBox(height: 7),
                Text('${listing.category} · ${listing.location}${isPhone ? ' · 자연 티타늄' : ''}', style: const TextStyle(color: muted, fontSize: 14)),
                const SizedBox(height: 22),
                Text(listing.price, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: ink)),
                const Divider(height: 40, color: line),
                const Text('상품 설명', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
                const SizedBox(height: 18),
                Text(
                  isPhone ? '자연 티타늄 색상의 아이폰 15 프로 256G입니다.\n기스 없이 깨끗하게 사용했고 배터리 상태도 좋아요.' : '직접 사용하던 물건입니다. 상태가 좋아요.\n편하게 채팅 주세요 :)',
                  style: const TextStyle(fontSize: 15, height: 1.7, color: ink),
                ),
                const SizedBox(height: 38),
                const Text('거래 희망 장소', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
                const SizedBox(height: 13),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xFFF2F4F5), borderRadius: BorderRadius.circular(14)),
                  child: const Row(children: [Icon(Icons.location_on_outlined, color: orange), SizedBox(width: 13), Text('역삼동 주변', style: TextStyle(fontSize: 16, color: ink))]),
                ),
                const SizedBox(height: 125),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 76,
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: line))),
          padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
          child: Row(
            children: [
              // 찜 기능을 연결할 자리인 관심 상품 버튼입니다.
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border, color: orange, size: 29)),
              const SizedBox(width: 15),
              Expanded(
                child: FilledButton(
                  // 판매자와 채팅방을 시작합니다.
                  onPressed: onChat,
                  style: FilledButton.styleFrom(backgroundColor: orange, minimumSize: const Size.fromHeight(54)),
                  child: const Text('채팅하기', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
