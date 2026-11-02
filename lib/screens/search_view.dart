import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/listing.dart';
import '../widgets/listing_tile.dart';

// 추천 검색어와 최근 등록 상품을 보여 주는 검색 화면입니다.
class SearchView extends StatelessWidget {
  const SearchView({required this.listings, required this.onListing, super.key});

  final List<Listing> listings;
  final ValueChanged<int> onListing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 18, 16, 12),
          child: Text('검색', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ink)),
        ),
        // 실제 검색 입력창으로 확장할 자리입니다.
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)),
          child: const Row(children: [Icon(Icons.search, color: muted), SizedBox(width: 11), Text('역삼동 근처에서 검색해보세요.', style: TextStyle(color: muted))]),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 25, 16, 10),
          child: Text('추천 검색어', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ink)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: ['아이폰', '자전거', '캠핑', '원목 가구']
                .map((keyword) => Padding(padding: const EdgeInsets.only(right: 8), child: Chip(label: Text(keyword))))
                .toList(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 7),
          child: Text('최근 등록된 매물', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ink)),
        ),
        Expanded(child: ListView.builder(itemCount: listings.length, itemBuilder: (_, i) => ListingTile(listing: listings[i], onTap: () => onListing(i)))),
      ],
    );
  }
}
