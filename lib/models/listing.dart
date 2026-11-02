// 상품 카드에 표시할 상품 종류
enum ListingKind { iphone, desk, shoes, feeder, microwave }

// 중고거래 
class Listing {
  Listing({
    required this.title,
    required this.location,
    required this.time,
    required this.price,
    required this.category,
    required this.kind,
  });

  final String title;
  final String location;
  final String time;
  final String price;
  final String category;
  final ListingKind kind;

  // 사용자가 상품을 찜했는지 여부 확인
  bool liked = false;
}
