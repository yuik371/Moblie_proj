import 'package:flutter/material.dart';

import '../services/auth_session.dart';
import '../services/post_service.dart';

class WriteView extends StatefulWidget {
  const WriteView({
    required this.onBack,
    required this.onPublish,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onPublish;

  @override
  State<WriteView> createState() => _WriteViewState();
}

class _WriteViewState extends State<WriteView> {
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _region = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    for (final controller in [
      _title,
      _description,
      _category,
      _region,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;

    final token = AuthSession.accessToken;

    // 나의 당근에서 로그인한 정보를 사용합니다.
    if (!AuthSession.isLoggedIn || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('나의 당근에서 먼저 로그인해주세요.'),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await PostService.createPost(
        token: token,
        title: _title.text,
        description: _description.text,
        category: _category.text,
        region: _region.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상품이 등록되었습니다.')),
      );

      widget.onPublish();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('등록 실패: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    required int maxLength,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: !_saving,
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label 항목을 입력해주세요.';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _saving ? null : widget.onBack,
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('내 물건 팔기'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _field(_title, '상품 제목', maxLength: 100),
              _field(
                _description,
                '상품 설명',
                maxLength: 5000,
                maxLines: 5,
              ),
              _field(_category, '카테고리', maxLength: 50),
              _field(_region, '거래 지역', maxLength: 100),
              const Text(
                '사진 업로드와 AI 가격 측정은 추후 연결됩니다.\n'
                '현재는 사진 없이 가격 미정으로 등록됩니다.',
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F0F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_saving ? '등록 중...' : '작성 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}