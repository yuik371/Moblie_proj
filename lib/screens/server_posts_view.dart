import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

import 'post_detail_view.dart';

class ServerPostsView extends StatefulWidget {
  const ServerPostsView({super.key});

  @override
  State<ServerPostsView> createState() => _ServerPostsViewState();
}

class _ServerPostsViewState extends State<ServerPostsView> {
  late Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();

    // 화면이 처음 열릴 때 서버에 목록을 요청합니다.
    _posts = PostService.fetchPosts();
  }

  Future<void> _refresh() async {
    final request = PostService.fetchPosts();

    setState(() {
      _posts = request;
    });

    // 실패 화면은 FutureBuilder에서 표시합니다.
    try {
      await request;
    } catch (_) {}
  }

  // 선택한 실제 게시물의 내용을 보여줍니다.
    Future<void> _openPost(Post post) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PostDetailView(post: post),
      ),
    );

    // 삭제 후 돌아오면 목록을 새로 불러옵니다.
    if (changed == true && mounted) {
      await _refresh();
    }
  }

  Widget _photo(Post post, {required double height}) {
    final placeholder = Container(
      height: height,
      color: const Color(0xFFF2F2F2),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 40,
        color: Colors.grey,
      ),
    );

    if (post.imageUrls.isEmpty) return placeholder;

    // 상대 경로로 받은 사진 주소도 서버 주소에 연결합니다.
    final url = Uri.parse('${PostService.baseUrl}/')
        .resolve(post.imageUrls.first)
        .toString();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '우리 동네 매물',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _refresh,
                tooltip: '새로고침',
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: FutureBuilder<List<Post>>(
            future: _posts,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '게시물을 불러오지 못했어요.\n서버 실행 상태를 확인해주세요.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _refresh,
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final posts = snapshot.data ?? [];

              if (posts.isEmpty) {
                return const Center(
                  child: Text('아직 등록된 게시물이 없어요.'),
                );
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: posts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: SizedBox(
                        width: 72,
                        child: _photo(post, height: 72),
                      ),
                      title: Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${post.region} · ${post.status}\n'
                        '${post.price == null ? "가격 미정" : "${post.price}원"}',
                      ),
                      isThreeLine: true,
                      onTap: () => _openPost(post),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}