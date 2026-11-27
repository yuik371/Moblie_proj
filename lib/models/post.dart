// FastAPI가 보내는 게시물 정보를 담습니다.
class Post {
  final int id;
  final String title;
  final String description;
  final String region;
  final String category;
  final List<String> imageUrls;
  final int? price;
  final int? aiRecommendedPrice;
  final String status;
  final String analysisStatus;
  final int sellerId;

  const Post({
    required this.id,
    required this.title,
    required this.description,
    required this.region,
    required this.category,
    required this.imageUrls,
    required this.price,
    required this.aiRecommendedPrice,
    required this.status,
    required this.analysisStatus,
    required this.sellerId,
  });

  // 서버의 JSON 데이터를 Dart 객체로 변환합니다.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      region: json['region'] as String,
      category: json['category'] as String,
      imageUrls: List<String>.from(json['image_urls'] as List),
      price: json['price'] as int?,
      aiRecommendedPrice: json['ai_recommended_price'] as int?,
      status: json['status'] as String,
      analysisStatus: json['analysis_status'] as String,
      sellerId: json['seller_id'] as int,
    );
  }
}