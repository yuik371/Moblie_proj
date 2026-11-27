import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

import 'auth_session.dart';

class PostService {
  // 같은 맥북에서 실행 중인 iPhone 시뮬레이터용 주소입니다.
  static const baseUrl = 'http://127.0.0.1:8000';

  static Future<List<Post>> fetchPosts({String? keyword}) async {
    final uri = Uri.parse('$baseUrl/api/posts').replace(
      queryParameters: {
        if (keyword != null && keyword.trim().isNotEmpty)
          'keyword': keyword.trim(),
      },
    );

    // 서버에 게시물 목록을 요청합니다.
    final response = await http.get(uri).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      throw Exception(
        '게시물을 불러오지 못했습니다. (${response.statusCode})',
      );
    }

    // 한글이 깨지지 않도록 UTF-8로 읽습니다.
    final data = jsonDecode(
      utf8.decode(response.bodyBytes),
    ) as List<dynamic>;

    return data
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }
    static Future<String> login(String email, String password) async {
    // 이전 계정의 로그인 정보가 남지 않도록 정리합니다.
    AuthSession.clear();

    final response = await http
        .post(
          Uri.parse('$baseUrl/api/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final data = jsonDecode(
      utf8.decode(response.bodyBytes),
    ) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(
        data['detail']?.toString() ?? '로그인 실패',
      );
    }

    final token = data['access_token'] as String;
    final userId = data['user_id'] as int;
    final nickname = data['nickname'] as String;

    // 다른 화면에서도 사용할 수 있도록 저장합니다.
    AuthSession.accessToken = token;
    AuthSession.userId = userId;
    AuthSession.nickname = nickname;

    return token;
  }

  // 사용자가 입력한 상품 정보를 서버에 등록합니다.
  static Future<void> createPost({
    required String token,
    required String title,
    required String description,
    required String category,
    required String region,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/api/posts'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'title': title.trim(),
            'description': description.trim(),
            'category': category.trim(),
            'region': region.trim(),
            'image_urls': <String>[],
            'price': null,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(data['detail']?.toString() ?? '게시물 등록 실패');
    }
  }
    static Future<void> deletePost(int postId) async {
    final token = AuthSession.accessToken;

    if (!AuthSession.isLoggedIn || token == null) {
      throw Exception('로그인이 필요합니다.');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/posts/$postId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(
        data['detail']?.toString() ?? '삭제하지 못했습니다.',
      );
    }
  }
    static Future<Post> updatePost({
    required Post post,
    required String title,
    required String description,
    required String category,
    required String region,
    required int? price,
    required String status,
  }) async {
    final token = AuthSession.accessToken;

    if (!AuthSession.isLoggedIn || token == null) {
      throw Exception('로그인이 필요합니다.');
    }

    final response = await http
        .put(
          Uri.parse('$baseUrl/api/posts/${post.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'title': title.trim(),
            'description': description.trim(),
            'category': category.trim(),
            'region': region.trim(),
            // 기존 사진 주소를 유지합니다.
            'image_urls': post.imageUrls,
            'price': price,
            'status': status,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final data = jsonDecode(
      utf8.decode(response.bodyBytes),
    ) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(
        data['detail']?.toString() ?? '수정하지 못했습니다.',
      );
    }

    return Post.fromJson(data);
  }
}