import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/urls.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.deleteComment,
  });
  final dynamic comment;
  final void Function(int) deleteComment;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.profile_circled),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment['user_name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                ),
              ),
              Flexible(
                child: Text(
                  comment['text'],
                  maxLines: 5,
                ),
              ),
            ],
          ),
          const Spacer(),
          comment['user'] == userId
              ? IconButton(
                  onPressed: () {
                    deleteComment(comment['id']);
                  },
                  icon: const Icon(CupertinoIcons.delete),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
