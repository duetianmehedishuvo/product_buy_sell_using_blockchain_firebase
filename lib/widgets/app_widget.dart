
import 'package:flutter/material.dart';

import '../util/image.dart';


Widget getCircularImage(double size, String imageURL) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(size))),
    child: ClipOval(
        child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            placeholder: 'assets/logo/logo.jpeg',
            image: imageURL,
            imageErrorBuilder: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(size),
                child: Image.network('https://image.shutterstock.com/image-vector/image-not-found-grayscale-photo-260nw-1737334631.jpg')))),
  );
}

BoxDecoration boxDecoration(
    {double radius = 2, Color borderColor = Colors.transparent, Color? bgColor, Color? shadowColor, bool showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? Colors.white,
    boxShadow: showShadow
        ? [BoxShadow(color: shadowColor!, offset: const Offset(0, 0), blurRadius: 15, spreadRadius: 3)]
        : [const BoxShadow(color: Colors.transparent)],
    border: Border.all(color: borderColor),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

/// Go back to previous screen.
void finishScreen(BuildContext context, [Object? result]) => Navigator.pop(context, result);

Widget? Function(BuildContext, String) placeholderWidgetFn() => (_, s) => placeholderWidget();

Widget placeholderWidget() => Image.asset(ImagesModel.placeholderImageOne, fit: BoxFit.cover);

class MyAnimatedWidget extends StatelessWidget {
  const MyAnimatedWidget({this.child, this.animation, Key? key}) : super(key: key);
  final Widget? child;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) => Center(
        child: AnimatedBuilder(animation: animation!, builder: (context, child) => Opacity(opacity: animation!.value, child: child), child: child),
      );
}
