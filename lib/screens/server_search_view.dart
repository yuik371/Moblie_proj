import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';
import 'post_detail_view.dart';

class ServerSearchView extends StatefulWidget {
  const ServerSearchView({super.key});

  @override
  State<ServerSearchView> createState() => _ServerSearchViewState();
}

class _ServerSearchViewState extends State<ServerSearchView> {
  final _searchController = TextEditingController();

  late Future<List<Post>> _results;
  String _keyword = '';

  @override
  void initState() {
    super.initState();

    // 처음에는 전체 게시물을 보여줍니다.
    _results = PostService.fetchPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();

    setState(() {
      _keyword = _searchController.text.trim();
      _results = PostService.fetchPosts(keyword: _keyword);
    });
  }

  Future<void> _openPost(Post post) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PostDetailView(post: post),
      ),
    );

    // 상세 화면에서 수정·삭제했다면 검색 결과를 갱신합니다.
    if (changed == true && mounted) {
      setState(() {
        _results = PostService.fetchPosts(keyword: _keyword);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: '어떤 상품을 찾으세요?',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: _search,
                tooltip: '검색',
                icon: const Icon(Icons.arrow_forward),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Post>>(
            future: _results,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('검색하지 못했어요. 서버를 확인해주세요.'),
                      TextButton(
                        onPressed: _search,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                );
              }

              final posts = snapshot.data ?? [];

              if (posts.isEmpty) {
                return Center(
                  child: Text(
                    _keyword.isEmpty
                        ? '등록된 게시물이 없어요.'
                        : "'$_keyword' 검색 결과가 없어요.",
                  ),
                );
              }

              return ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text(post.title),
                    subtitle: Text(
                      '${post.region} · ${post.status}\n'
                      '${post.price == null ? "가격 미정" : "${post.price}원"}',
                    ),
                    isThreeLine: true,
                    onTap: () => _openPost(post),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}