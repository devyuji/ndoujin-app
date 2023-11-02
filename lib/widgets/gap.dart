import 'package:flutter/material.dart';
import 'package:ndoujin/constraint.dart';

class Gap extends StatelessWidget {
  const Gap({
    super.key,
    this.size = kDefaultPadding,
    this.isHorizontal = false,
  });

  final double? size;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isHorizontal ? size : 0,
      height: isHorizontal ? 0 : size,
    );
  }
}
