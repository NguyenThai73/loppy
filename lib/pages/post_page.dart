import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<Post> _posts = [
    Post(
      id: '1',
      content: 'Loppy hom nay an rat nhieu ngo! 🌽',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likeCount: 5,
      comments: [
        Comment(author: 'Ban A', content: 'Dang yeu qua!'),
        Comment(author: 'Ban B', content: 'Loppy thich ngo nhi?'),
      ],
    ),
    Post(
      id: '2',
      content: 'Loppy vua xay xong 1 cai dam moi trong bon tam! 🦫',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likeCount: 12,
      comments: [
        Comment(author: 'Ban C', content: 'Hai ly gioi qua!'),
      ],
    ),
    Post(
      id: '3',
      content: 'Hom nay cho Loppy di kham suc khoe, bac si noi Loppy rat khoe manh! 💪',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      likeCount: 20,
    ),
  ];

  void _addPost() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bai viet moi'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Ban dang nghi gi ve Loppy?',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huy'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _posts.insert(
                    0,
                    Post(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      content: controller.text.trim(),
                    ),
                  );
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Dang'),
          ),
        ],
      ),
    );
  }

  void _toggleLike(Post post) {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likeCount += post.isLiked ? 1 : -1;
    });
  }

  void _showComments(Post post) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Binh luan (${post.comments.length})',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (post.comments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('Chua co binh luan nao')),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.3,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: post.comments.length,
                    itemBuilder: (_, i) {
                      final c = post.comments[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.brown.shade200,
                          child: Text(c.author[0]),
                        ),
                        title: Text(c.author),
                        subtitle: Text(c.content),
                        dense: true,
                      );
                    },
                  ),
                ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Viet binh luan...',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        setModalState(() {
                          post.comments.add(
                            Comment(
                              author: 'Toi',
                              content: controller.text.trim(),
                            ),
                          );
                        });
                        setState(() {});
                        controller.clear();
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} ngay truoc';
    if (diff.inHours > 0) return '${diff.inHours} gio truoc';
    if (diff.inMinutes > 0) return '${diff.inMinutes} phut truoc';
    return 'Vua xong';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _posts.isEmpty
          ? const Center(child: Text('Chua co bai viet nao'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _posts.length,
              itemBuilder: (_, i) {
                final post = _posts[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.brown.shade300,
                              child: const Text('🦫',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Loppy Owner',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _timeAgo(post.createdAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => _toggleLike(post),
                              child: Row(
                                children: [
                                  Icon(
                                    post.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: post.isLiked
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${post.likeCount}'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            InkWell(
                              onTap: () => _showComments(post),
                              child: Row(
                                children: [
                                  const Icon(Icons.comment_outlined,
                                      size: 22, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('${post.comments.length}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
