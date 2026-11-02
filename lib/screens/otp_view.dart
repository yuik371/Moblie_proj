import 'package:flutter/material.dart';

import '../config/app_theme.dart';

// 문자로 받은 인증번호를 입력해 로그인 상태로 전환하는 화면입니다.
class OtpView extends StatelessWidget {
  const OtpView({required this.onBack, required this.onDone, super.key});

  final VoidCallback onBack;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 로그인 화면으로 돌아가는 버튼입니다.
        leading: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
        title: const Text('전화번호 인증', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 55),
            const Text('인증번호를 입력해주세요', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ink)),
            const SizedBox(height: 10),
            const Text('문자로 전송된 6자리 인증번호를 입력하세요.', style: TextStyle(color: muted)),
            const SizedBox(height: 35),
            const TextField(decoration: InputDecoration(labelText: '인증번호 6자리', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderSide: BorderSide.none))),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                // 인증을 완료하고 프로필 화면으로 이동합니다.
                onPressed: onDone,
                style: FilledButton.styleFrom(backgroundColor: orange, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
