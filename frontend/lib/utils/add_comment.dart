import 'package:flutter/material.dart';

class AddComment extends StatefulWidget {
  const AddComment({
    super.key,
    required this.addComment,
  });
  final void Function(String) addComment;
  @override
  State<AddComment> createState() {
    return _AddCommentState();
  }
}

class _AddCommentState extends State<AddComment> {
  final _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(11),
        child: ListView(
          children: [
            TextField(
              controller: _commentController,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                widget.addComment(_commentController.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            )
          ],
        ),
      ),
    );
  }
}
