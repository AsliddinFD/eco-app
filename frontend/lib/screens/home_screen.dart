import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/providers/categories_provider.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/product_details.dart';
import 'package:frontend/utils/urls.dart';
import 'package:frontend/widgets/drawer.dart';
import 'package:frontend/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/all_products_provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  dynamic filteredContent;

  void filterProducts(id) async {
    final api = Uri.parse(filterProductsApi.replaceAll('category_id', id));
    final response = await http.get(api);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      setState(() {
        filteredContent = Expanded(
          child: ListView.builder(
            itemCount: responseBody.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetail(
                      id: responseBody[index]['id'],
                    ),
                  ),
                );
              },
              child: ProductCard(
                product: responseBody[index],
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: userId == null
            ? TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Log in'),
              )
            : IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(CupertinoIcons.profile_circled),
              ),
        title: const Text('Tech products'),
        
        actions: [
          filteredContent != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      filteredContent = null;
                    });
                  },
                  icon: const Icon(CupertinoIcons.refresh),
                )
              : const Text('')
        ],
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 55,
              child: Consumer(
                builder: (context, watch, child) {
                  final categorySyncVal = ref.watch(getCategories);
                  return categorySyncVal.when(
                    data: (categories) {
                      return ListView.builder(
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(),
                              backgroundColor:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white,
                            ),
                            onPressed: () {
                              filterProducts(
                                categories[index]['id'].toString(),
                              );
                            },
                            child: Text(
                              categories[index]['name'],
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => const Center(
                      child: Text('Error loading categories'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            filteredContent ??
                Expanded(
                  child: Consumer(
                    builder: (context, watch, child) {
                      final productsAsyncValue = ref.watch(getProducts);
                      return productsAsyncValue.when(
                        data: (products) {
                          return ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                      id: products[index]['id'],
                                    ),
                                  ),
                                );
                              },
                              child: ProductCard(
                                product: products[index],
                              ),
                            ),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) => const Center(
                          child: Text('Error loading products'),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
