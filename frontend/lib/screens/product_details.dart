import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/cart_notifier.dart';
import 'package:frontend/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/add_comment.dart';
import 'package:frontend/utils/comments_widget.dart';
import 'package:frontend/utils/urls.dart';
import 'package:frontend/widgets/product_carousel_images.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({super.key, required this.id});
  final int id;
  @override
  ConsumerState<ProductDetail> createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  List<Map<String, dynamic>> cartItems = [];
  Widget mainContent = const CircularProgressIndicator();
  String name = '';
  int count = 0;
  dynamic responseData;
  dynamic commentsData;
  dynamic images;
  bool isLoading = false;
  @override
  void initState() {
    getProductDetail();
    super.initState();
  }

  void addComment(String text) async {
    if (userId == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else if (text.isNotEmpty) {
      final api = Uri.parse(createCommentApi);
      final response = await http.post(
        api,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Token $token'
        },
        body: json.encode({
          'text': text,
          'product': widget.id,
          'user': userId,
          'user_name': user_name,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          getProductDetail();
        });
      } else {
        print(response.body);
      }
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: const Text('Please fill the comment field'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  void deleteComment(id) async {
    final api = Uri.parse(deleteCommentApi.replaceAll('id', id.toString()));
    final response = await http.delete(api, headers: {
      'Content-type': 'application/json',
      'Authorization': 'Token $token'
    });
    if (response.statusCode == 204) {
      getProductDetail();
    } else {
      print(response.body);
    }
  }

  void addtoCart(productId) async {
    if (userId == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      final addCart = ref.watch(
        addToCartProviderFuture(productId.toString()),
      );
    }
  }

  void getProductDetail() async {
    final api = Uri.parse(
      productDetailApi.replaceAll('id', widget.id.toString()),
    );
    final response = await http.get(api);

    if (response.statusCode == 200) {
      responseData = json.decode(response.body)['product'];
      commentsData = json.decode(response.body)['comments'];
      images = responseData['images'].split(' ');
      setState(() {
        name = responseData['name'];
      });
    }
  }

  addToLiked(productId) async {
    final api = Uri.parse(
      likeProductApi.replaceAll('product_id', productId.toString()),
    );
    final response = await http.put(api, headers: {
      'Content-type': 'application/json',
      'Authorization': 'Token $token'
    });

    if (response.statusCode == 200) {
      getProductDetail();
      print(response.body);
    } else {
      print(response.body);
    }
  }

  removeFromTheLiked(productId) async {
    final api = Uri.parse(
      unlikeProductApi.replaceAll('product_id', productId.toString()),
    );

    final response = await http.put(api, headers: {
      'Content-type': 'application/json',
      'Authorization': 'Token $token'
    });

    if (response.statusCode == 200) {
      getProductDetail();
      print(response.body);
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          userId == null
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  icon: const Icon(CupertinoIcons.heart),
                )
              : IconButton(
                  onPressed: () {
                    if (responseData != null) {
                      !responseData['is_liked']
                          ? addToLiked(responseData['id'])
                          : removeFromTheLiked(responseData['id']);
                    }
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      userId == null
                          ? CupertinoIcons.star
                          : responseData != null && responseData['is_liked']
                              ? CupertinoIcons.star_fill
                              : CupertinoIcons.star,
                      key: ValueKey(
                          responseData != null && responseData['is_liked']),
                    ),
                  ),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: responseData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ProductImagesCarousel(
                    images: images,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '\$${double.parse(responseData['price']).toInt()}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    responseData['description'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Comments'),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) => AddComment(
                              addComment: addComment,
                            ),
                          );
                          getProductDetail();
                        },
                        child: const Text('Add comment'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Comments(
                    comments: commentsData,
                    deleteComment: deleteComment,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      addtoCart(responseData['id']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
