import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/app_screen.dart';
import '../providers/app_state.dart';
import 'ar_preview_view.dart';
import 'article_view.dart';
import 'chat_room_view.dart';
import 'chat_view.dart';
import 'home_view.dart';
import 'login_view.dart';
import 'otp_view.dart';
import 'profile_view.dart';
import 'region_view.dart';
import 'search_view.dart';
import 'settings_view.dart';
import 'write_view.dart';

// 앱의 모든 화면과 하단 네비게이션을 연결하는 화면 셸입니다.
class KarrotShell extends StatefulWidget {
  const KarrotShell({super.key});

  @override
  State<KarrotShell> createState() => _KarrotShellState();
}

class _KarrotShellState extends State<KarrotShell> {
  final appState = AppState();

  // 상품 인덱스를 저장한 뒤 상세 화면으로 이동합니다.
  void openArticle(int index) {
    setState(() => appState.openArticle(index));
  }

  // 하단 탭을 변경하고 선택 상태를 다시 그립니다.
  void openTab(int index) {
    setState(() => appState.openTab(index));
  }

  // 일반적인 화면 이동을 처리합니다.
  void openScreen(AppScreen next) {
    setState(() => appState.openScreen(next));
  }

  // 상품 작성 완료 후 목록에 상품을 추가하고 홈으로 돌아갑니다.
  void publishListing() {
    setState(appState.publishListing);
  }

  // Android 시스템 뒤로 가기 버튼의 화면 이동을 처리합니다.
  Future<bool> handleBack() async {
    final shouldExit = appState.handleBack();
    if (!shouldExit) setState(() {});
    return shouldExit;
  }

  // 현재 상태에 맞는 실제 화면 위젯을 선택합니다.
  Widget buildScreen() {
    switch (appState.screen) {
      case AppScreen.home:
        return buildMainScaffold(
          tab: 0,
          body: HomeView(
            listings: appState.listings,
            onRegion: () => openScreen(AppScreen.region),
            onSearch: () => openScreen(AppScreen.search),
            onListing: openArticle,
          ),
        );
      case AppScreen.search:
        return buildMainScaffold(
          tab: 1,
          body: SearchView(listings: appState.listings, onListing: openArticle),
        );
      case AppScreen.chat:
        return buildMainScaffold(
          tab: 2,
          body: ChatView(onRoom: () => openScreen(AppScreen.chatRoom)),
        );
      case AppScreen.profile:
        return buildMainScaffold(
          tab: 3,
          body: ProfileView(
            loggedIn: appState.loggedIn,
            onLogin: () => openScreen(AppScreen.login),
            onSettings: () => openScreen(AppScreen.settings),
          ),
        );
      case AppScreen.article:
        return ArticleView(
          listing: appState.listings[appState.selectedListing],
          onBack: () => openScreen(AppScreen.home),
          onAr: () => openScreen(AppScreen.arPreview),
          onChat: () => openScreen(AppScreen.chatRoom),
        );
      case AppScreen.chatRoom:
        return ChatRoomView(
          sentMessage: appState.sentMessage,
          onBack: () => openScreen(AppScreen.chat),
          onSend: () => setState(() => appState.sentMessage = true),
        );
      case AppScreen.write:
        return WriteView(onBack: () => openScreen(AppScreen.home), onPublish: publishListing);
      case AppScreen.region:
        return RegionView(onBack: () => openScreen(AppScreen.home), onSelected: () => openScreen(AppScreen.home));
      case AppScreen.settings:
        return SettingsView(onBack: () => openScreen(AppScreen.profile));
      case AppScreen.login:
        return LoginView(onBack: () => openScreen(AppScreen.profile), onOtp: () => openScreen(AppScreen.otp));
      case AppScreen.otp:
        return OtpView(
          onBack: () => openScreen(AppScreen.login),
          onDone: () => setState(() {
            appState.loggedIn = true;
            appState.screen = AppScreen.profile;
            appState.selectedTab = 3;
          }),
        );
      case AppScreen.arPreview:
        return ArPreviewView(onBack: () => openScreen(AppScreen.article));
    }
  }

  // 홈·검색·채팅·프로필 화면에서 공통으로 사용하는 하단 구조입니다.
  Widget buildMainScaffold({required Widget body, required int tab}) {
    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: NavigationBar(
        height: 76,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFEFE6),
        selectedIndex: tab,
        // 하단 아이콘 버튼을 눌렀을 때 해당 탭으로 이동합니다.
        onDestinationSelected: openTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.search), label: '검색'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: '채팅'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '나의 당근'),
        ],
      ),
      // 홈에서만 보이는 플로팅 버튼으로 상품 작성 화면을 엽니다.
      floatingActionButton: tab == 0
          ? FloatingActionButton(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              onPressed: () => openScreen(AppScreen.write),
              child: const Icon(Icons.add, size: 30),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handleBack,
      child: buildScreen(),
    );
  }
}
