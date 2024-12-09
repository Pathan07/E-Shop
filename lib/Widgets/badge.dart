import 'package:flutter/material.dart';

class badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  const badge({
    super.key,
    required this.child,
    required this.value,
    this.color = Colors.deepOrange,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.deepOrange, // Set color in decoration
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white, // Optional: Set text color for contrast
              ),
            ),
          ),
        ),
      ],
    );
  }
}
