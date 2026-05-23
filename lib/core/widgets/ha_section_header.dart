import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_strings.dart';

class HaSectionHeader extends StatelessWidget {
  final String title;
  final Widget? icon;
  final VoidCallback? onViewAll;
  final String? viewAllText;

  const HaSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.onViewAll,
    this.viewAllText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: AppDimensions.spacingS),
            ],
            Text(
              title,
              style: AppTextStyles.sectionTitle,
            ),
          ],
        ),
        if (onViewAll != null)
          InkWell(
            onTap: onViewAll,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingS,
                vertical: AppDimensions.paddingXS,
              ),
              child: Row(
                children: [
                  Text(
                    viewAllText ?? AppStrings.viewAll,
                    style: AppTextStyles.link,
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Iconsax.arrow_left_2,
                    size: 14,
                    color: AppColors.gold,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
