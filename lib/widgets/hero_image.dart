import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  
  const HeroImage({
    Key? key,
    required this.imageUrl,
    required this.heroTag,
    this.width = double.infinity,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final image = imageUrl.startsWith('http') || imageUrl.startsWith('https')
      ? NetworkImage(imageUrl) as ImageProvider
      : AssetImage(imageUrl);
    
    final imageWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        image: DecorationImage(
          image: image,
          fit: fit,
        ),
      ),
    );
    
    return Hero(
      tag: heroTag,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: imageWidget,
      ),
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return imageWidget;
          },
        );
      },
    );
  }
}
