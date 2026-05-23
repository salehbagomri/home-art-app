import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_strings.dart';

class HaSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String? hintText;
  final bool readOnly;
  final VoidCallback? onTap;

  const HaSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.hintText,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.searchBarHeight,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        onTap: onTap,
        textAlignVertical: TextAlignVertical.center,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText ?? AppStrings.search,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.subtleText),
          prefixIcon: const Icon(
            Iconsax.search_normal_1,
            color: AppColors.woodBrown,
            size: AppDimensions.iconS,
          ),
          suffixIcon: onFilterTap != null
              ? IconButton(
                  icon: const Icon(
                    Iconsax.setting_4,
                    color: AppColors.woodBrown,
                    size: AppDimensions.iconS,
                  ),
                  onPressed: onFilterTap,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }
}
