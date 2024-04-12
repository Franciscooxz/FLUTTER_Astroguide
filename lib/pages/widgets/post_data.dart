import 'package:flutter/material.dart';
import 'package:astroguide_flutter/controllers/post_controller.dart';
import 'package:astroguide_flutter/models/post_model.dart';
import 'package:astroguide_flutter/pages/post_details.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PostData extends StatefulWidget {
  const PostData({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  State<PostData> createState() => _PostDataState();
}

class _PostDataState extends State<PostData> {
  final PostController _postController = Get.put(PostController());
  bool likedPost = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post.user?.name ?? 'Anonimo',
            style: GoogleFonts.poppins(),
          ),
          Text(
            widget.post.user?.email ?? 'anonimus@....',
            style: GoogleFonts.poppins(
              fontSize: 10,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.post.content!,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await _postController.likeAndDislike(widget.post.id);
                  _postController.getAllPosts();
                },
                icon: Icon(
                  Icons.thumb_up,
                  color:
                      widget.post.liked ?? false ? Colors.blue : Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.to(
                    () => PostDetails(
                      post: widget.post,
                    ),
                  );
                },
                icon: const Icon(Icons.message),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
