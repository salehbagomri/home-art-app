import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class HaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;
  final Color? color;
  final VoidCallback? onTap;

  const HaCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.showBorder = false,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingL),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: showBorder ? Border.all(color: AppColors.cardBorder, width: 1) : null,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
