import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/listing.dart';
import '../widgets/listing_tile.dart';

// 우리 동네 상품 목록과 지역·알림·검색 진입 버튼을 보여 주는 홈 화면입니다.
class HomeView extends StatelessWidget {
  const HomeView({
    required this.listings,
    required this.onRegion,
    required this.onSearch,
    required this.onListing,
    super.key,
  });

  final List<Listing> listings;
  final VoidCallback onRegion;
  final VoidCallback onSearch;
  final ValueChanged<int> onListing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  // 지역 영역을 누르면 동네 설정 화면을 엽니다.
                  onTap: onRegion,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('역삼동', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: ink)),
                          Icon(Icons.keyboard_arrow_down, color: muted),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text('내 동네 설정', style: TextStyle(color: muted, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              // 알림 버튼은 향후 알림 목록 화면과 연결할 자리입니다.
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, size: 26)),
              // 검색 버튼을 누르면 검색 탭으로 이동합니다.
              IconButton(onPressed: onSearch, icon: const Icon(Icons.search, size: 29)),
            ],
          ),
        ),
        const Divider(height: 1, color: line),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 20, bottom: 24),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('우리 동네 인기 매물', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: ink)),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 6, 16, 14),
                child: Text('지금 이웃들이 올린 따끈한 소식이에요', style: TextStyle(fontSize: 14, color: muted)),
              ),
              for (var i = 0; i < listings.length; i++)
                ListingTile(listing: listings[i], onTap: () => onListing(i)),
            ],
          ),
        ),
      ],
    );
  }
}
