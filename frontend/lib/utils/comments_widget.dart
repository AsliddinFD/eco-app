import 'package:flutter/material.dart';
import 'package:frontend/utils/comments_widget_card.dart';

class Comments extends StatefulWidget {
  const Comments({
    super.key,
    required this.comments,
    required this.deleteComment,
  });
  final List<dynamic> comments;
  final void Function(int) deleteComment;
  @override
  State<Comments> createState() {
    return _CommentsState();
  }
}

class _CommentsState extends State<Comments> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      )),
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
          print(widget.comments[0]);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: isExpanded ? 200.0 : 50.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.comments.isEmpty)
                      const Center(
                        child: Text('No comments yet'),
                      )
                    else if (widget.comments.length == 1)
                      CommentCard(
                        deleteComment: widget.deleteComment,
                        comment: widget.comments[0],
                      )
                    else
                      CommentCard(
                        deleteComment: widget.deleteComment,
                        comment: widget.comments[0],
                      ),
                    if (isExpanded)
                      ...widget.comments.skip(1).map(
                            (comment) => CommentCard(
                              deleteComment: widget.deleteComment,
                              comment: comment,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
