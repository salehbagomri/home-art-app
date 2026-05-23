import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HaLoading extends StatelessWidget {
  final double size;
  const HaLoading({super.key, this.size = 32.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
        ),
      ),
    );
  }
}
