import 'package:flutter/material.dart';

Widget vIconButton({required BuildContext context,required BoxConstraints constraints, required IconData icon, required VoidCallback? onPressed, String text = "", }) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(icon, color: Theme.of(context).colorScheme.inverseSurface, size: constraints.maxHeight*0.6),
            onPressed: onPressed,
          ),
          height: constraints.maxHeight*0.7,
          padding: const EdgeInsets.all(3.0),
          width: double.infinity,
        ),
        Container(
          child: Text(text,
            style: Theme.of(context).textTheme.subtitle2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          height: constraints.maxHeight*0.3,
          padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 3.0),
          width: double.infinity,
        ),
      ],
    ),
  );
}

Widget roundedIconButton({required BuildContext context, required BoxConstraints constraints, required IconData icon, required VoidCallback? onPressed, String text = "",}) {
  return Container(
    padding: const EdgeInsets.all(3.0),
    child: ElevatedButton.icon(
      icon: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.inverseSurface,size: constraints.maxHeight*0.07),
          Text(text, style: Theme.of(context).textTheme.headline6,)
        ],
      ),
      label: Container(),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        padding: const EdgeInsets.only(left:3.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0),
        ),
      ),
    ),
  );
}

class RightTriangleButton extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height/2);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class LeftTriangleButton extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height/2);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height/2);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}