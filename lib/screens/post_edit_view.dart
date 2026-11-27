import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class PostEditView extends StatefulWidget {
  const PostEditView({required this.post, super.key});

  final Post post;

  @override
  State<PostEditView> createState() => _PostEditViewState();
}

class _PostEditViewState extends State<PostEditView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _category;
  late final TextEditingController _region;
  late final TextEditingController _price;

  late String _status;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    // 기존 게시물 내용을 입력란에 채웁니다.
    final post = widget.post;
    _title = TextEditingController(text: post.title);
    _description = TextEditingController(text: post.description);
    _category = TextEditingController(text: post.category);
    _region = TextEditingController(text: post.region);
    _price = TextEditingController(text: post.price?.toString() ?? '');
    _status = post.status;
  }

  @override
  void dispose() {
    for (final controller in [
      _title,
      _description,
      _category,
      _region,
      _price,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final updatedPost = await PostService.updatePost(
        post: widget.post,
        title: _title.text,
        description: _description.text,
        category: _category.text,
        region: _region.text,
        price: _price.text.trim().isEmpty
            ? null
            : int.parse(_price.text.trim()),
        status: _status,
      );

      if (!mounted) return;

      // 서버에서 받은 수정 결과를 상세 화면에 전달합니다.
      Navigator.pop(context, updatedPost);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수정 실패: $error')),
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
    int maxLines = 1,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: !_saving,
        maxLines: maxLines,
        maxLength: maxLength,
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
        appBar: AppBar(title: const Text('게시물 수정')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _field(_title, '상품 제목', maxLength: 100),
              _field(
                _description,
                '상품 설명',
                maxLines: 5,
                maxLength: 5000,
              ),
              _field(_category, '카테고리', maxLength: 50),
              _field(_region, '거래 지역', maxLength: 100),
              TextFormField(
                controller: _price,
                enabled: !_saving,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '판매가격',
                  hintText: '비워두면 가격 미정',
                  suffixText: '원',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return null;

                  final price = int.tryParse(text);
                  if (price == null || price < 0) {
                    return '0 이상의 정수를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: '거래 상태',
                  border: OutlineInputBorder(),
                ),
                items: ['판매중', '예약중', '판매완료']
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ),
                    )
                    .toList(),
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _status = value);
                        }
                      },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? '저장 중...' : '수정 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}