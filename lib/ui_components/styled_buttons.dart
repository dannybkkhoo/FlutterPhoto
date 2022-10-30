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