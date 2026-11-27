// 앱 실행 중 로그인 정보를 공유합니다.
class AuthSession {
  static String? accessToken;
  static int? userId;
  static String? nickname;

  static bool get isLoggedIn =>
      accessToken != null && userId != null;

  // 내 게시물인지 확인할 때 사용합니다.
  static bool isOwner(int sellerId) {
    return isLoggedIn && userId == sellerId;
  }

  // 로그아웃할 때 호출합니다.
  static void clear() {
    accessToken = null;
    userId = null;
    nickname = null;
  }
}