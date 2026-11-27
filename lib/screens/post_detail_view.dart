import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/auth_session.dart';
import '../services/post_service.dart';
import 'post_edit_view.dart';

class PostDetailView extends StatefulWidget {
  const PostDetailView({required this.post, super.key});

  final Post post;

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
    bool _deleting = false;
  bool _changed = false;
  late Post _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  Future<void> _edit() async {
    final updatedPost = await Navigator.of(context).push<Post>(
      MaterialPageRoute(
        builder: (_) => PostEditView(post: _post),
      ),
    );

    if (updatedPost == null || !mounted) return;

    setState(() {
      _post = updatedPost;
      _changed = true;
    });
  }

  Future<void> _delete() async {
    // 실수로 삭제하지 않도록 확인합니다.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('게시물 삭제'),
        content: const Text('이 게시물을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              '삭제',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);

    try {
      await PostService.deletePost(widget.post.id);

      if (!mounted) return;

      // 목록 화면에 삭제됐다는 결과를 전달합니다.
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제 실패: $error')),
      );

      setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = _post; 
    final isOwner = AuthSession.isOwner(post.sellerId);

    return Scaffold(
            appBar: AppBar(
        leading: IconButton(
          onPressed: _deleting
              ? null
              : () => Navigator.pop(context, _changed),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('상품 상세'),
        actions: [
          if (isOwner)
            IconButton(
              onPressed: _deleting ? null : _edit,
              tooltip: '수정',
              icon: const Icon(Icons.edit_outlined),
            ),
          if (isOwner)
            IconButton(
              onPressed: _deleting ? null : _delete,
              tooltip: '삭제',
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (post.imageUrls.isNotEmpty)
            Image.network(
              Uri.parse('${PostService.baseUrl}/')
                  .resolve(post.imageUrls.first)
                  .toString(),
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 160,
                child: Icon(Icons.image_outlined, size: 60),
              ),
            )
          else
            const SizedBox(
              height: 160,
              child: Icon(
                Icons.image_outlined,
                size: 60,
                color: Colors.grey,
              ),
            ),
          const SizedBox(height: 20),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text('${post.category} · ${post.region}'),
          const SizedBox(height: 16),
          Text(
            post.price == null ? '가격 미정' : '${post.price}원',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text('거래 상태: ${post.status}'),
          Text('AI 분석: ${post.analysisStatus}'),
          if (post.aiRecommendedPrice != null)
            Text('AI 추천가격: ${post.aiRecommendedPrice}원'),
          const Divider(height: 32),
          Text(
            post.description,
            style: const TextStyle(fontSize: 16),
          ),
          if (_deleting)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}