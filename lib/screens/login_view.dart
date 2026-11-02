import 'package:flutter/material.dart';

import '../config/app_theme.dart';

// 휴대폰 번호를 입력해 로그인·회원가입을 시작하는 화면입니다.
class LoginView extends StatelessWidget {
  const LoginView({required this.onBack, required this.onOtp, super.key});

  final VoidCallback onBack;
  final VoidCallback onOtp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 프로필 화면으로 돌아가는 버튼입니다.
        leading: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
        title: const Text('로그인 또는 회원가입', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 52),
            const Icon(Icons.eco, color: orange, size: 75),
            const SizedBox(height: 25),
            const Text('이웃과 함께하는 따뜻한 거래', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: ink)),
            const SizedBox(height: 8),
            const Text('휴대폰 번호로 간편하게 시작해보세요', style: TextStyle(color: muted)),
            const SizedBox(height: 50),
            const TextField(decoration: InputDecoration(labelText: '휴대폰번호', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderSide: BorderSide.none))),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                // 인증번호 입력 화면으로 이동합니다.
                onPressed: onOtp,
                style: FilledButton.styleFrom(backgroundColor: orange, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('인증번호 받기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
