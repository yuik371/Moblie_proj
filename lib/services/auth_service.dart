import 'dart:convert';

import 'package:http/http.dart' as http;

import 'post_service.dart';

class AuthService {
  static Future<void> _request(
    String path,
    Map<String, dynamic> body,
    int successCode,
  ) async {
    final response = await http
        .post(
          Uri.parse('${PostService.baseUrl}$path'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != successCode) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(
        data['detail']?.toString() ?? '요청에 실패했습니다.',
      );
    }
  }

  // 인증번호 발송
  static Future<void> sendCode(String email) {
    return _request(
      '/api/email/send-code',
      {'email': email.trim()},
      200,
    );
  }

  // 인증번호 확인
  static Future<void> verifyCode(String email, String code) {
    return _request(
      '/api/email/verify-code',
      {'email': email.trim(), 'code': code.trim()},
      200,
    );
  }

  // 인증한 이메일로 회원가입
  static Future<void> register({
    required String email,
    required String password,
    required String nickname,
  }) {
    return _request(
      '/api/auth/register',
      {
        'email': email.trim(),
        'password': password,
        'nickname': nickname.trim(),
      },
      201,
    );
  }
}