import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductImagesCarousel extends StatelessWidget {
  const ProductImagesCarousel({super.key, required this.images});
  final dynamic images;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: images.length,
      itemBuilder: (context, index, index1) => Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(images[index]),
            fit: BoxFit.cover,
          ),
        ),
      ),
      options: CarouselOptions(
        height: 300,
        autoPlay: false,
        enableInfiniteScroll: false,
      ),
    );
  }
}
