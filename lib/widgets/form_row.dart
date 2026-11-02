import 'package:flutter/material.dart';

import '../config/app_theme.dart';

// 상품 등록 화면의 입력 항목 라벨과 안내 문구를 표시합니다.
class FormRow extends StatelessWidget {
  const FormRow({required this.label, required this.hint, super.key});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: ink)),
          const SizedBox(height: 8),
          Text(hint, style: const TextStyle(color: muted)),
          const Divider(color: line),
        ],
      ),
    );
  }
}
