import '../models/app_screen.dart';
import '../models/listing.dart';

// (백엔드 기능 추가 예정)백엔드 없이 화면 전환과 샘플 데이터를 관리하는 앱 상태 클래스
class AppState {
  AppScreen screen = AppScreen.home;
  int selectedTab = 0;
  int selectedListing = 0;
  bool loggedIn = false;
  bool sentMessage = false;

  // 앱 시작 시 홈 화면에 보여 줄 샘플 상품 목록입니다.
  final listings = <Listing>[
    Listing(
      title: '아이폰 15 프로 256G',
      location: '역삼동',
      time: '3분 전',
      price: '950,000원',
      category: '디지털기기',
      kind: ListingKind.iphone,
    ),
    Listing(
      title: '무인양품 원목 책상',
      location: '대치동',
      time: '12분 전',
      price: '45,000원',
      category: '가구/인테리어',
      kind: ListingKind.desk,
    ),
    Listing(
      title: '나이키 운동화 새상품',
      location: '삼성동',
      time: '27분 전',
      price: '35,000원',
      category: '스포츠/레저',
      kind: ListingKind.shoes,
    ),
    Listing(
      title: '고양이 자동 급식기',
      location: '논현동',
      time: '1시간 전',
      price: '20,000원',
      category: '반려동물',
      kind: ListingKind.feeder,
    ),
    Listing(
      title: '상태 좋은 전자레인지',
      location: '역삼동',
      time: '2시간 전',
      price: '나눔',
      category: '생활가전',
      kind: ListingKind.microwave,
    ),
  ];

  // 상품 상세 화면으로 이동할 상품 인덱스를 저장합니다.
  void openArticle(int index) {
    selectedListing = index;
    screen = AppScreen.article;
  }

  // 하단 네비게이션 탭을 선택하고 해당 화면으로 이동합니다.
  void openTab(int index) {
    selectedTab = index;
    screen = AppScreen.values[index];
  }

  // 지정한 화면으로 이동합니다.
  void openScreen(AppScreen next) {
    screen = next;
  }

  // 작성 완료된 임시 상품을 목록 맨 앞에 추가합니다.
  void publishListing() {
    listings.insert(
      0,
      Listing(
        title: '새로 등록한 물건',
        location: '역삼동',
        time: '방금 전',
        price: '가격 협의',
        category: '생활/가공식품',
        kind: ListingKind.microwave,
      ),
    );
    selectedTab = 0;
    screen = AppScreen.home;
  }

  // 현재 화면의 뒤로 가기 목적지를 정하고, 앱 종료 여부를 반환합니다.
  bool handleBack() {
    if (screen == AppScreen.home) return true;

    switch (screen) {
      case AppScreen.chatRoom:
        screen = AppScreen.chat;
        selectedTab = 2;
        break;
      case AppScreen.settings:
      case AppScreen.otp:
        screen = AppScreen.profile;
        selectedTab = 3;
        break;
      case AppScreen.article:
      case AppScreen.write:
      case AppScreen.region:
      case AppScreen.login:
      case AppScreen.arPreview:
        screen = AppScreen.home;
        selectedTab = 0;
        break;
      default:
        screen = AppScreen.home;
        selectedTab = 0;
    }
    return false;
  }
}
