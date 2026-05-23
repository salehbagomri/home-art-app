import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

enum HaButtonType { primary, outlined, text }

class HaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final HaButtonType type;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;

  const HaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = HaButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  const HaButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  }) : type = HaButtonType.primary;

  const HaButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  }) : type = HaButtonType.outlined;

  const HaButton.textButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  }) : type = HaButtonType.text;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;
    final double buttonHeight = height ?? AppDimensions.buttonHeight;
    final double buttonWidth = width ?? double.infinity;

    Widget content = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == HaButtonType.primary ? AppColors.white : AppColors.gold,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppDimensions.spacingS),
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    style: type == HaButtonType.primary
                        ? AppTextStyles.buttonLarge.copyWith(color: AppColors.white)
                        : AppTextStyles.buttonLarge.copyWith(color: AppColors.gold),
                  ),
                ),
              ),
            ],
          );

    switch (type) {
      case HaButtonType.primary:
        return SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.goldLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            child: content,
          ),
        );
      case HaButtonType.outlined:
        return SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.gold,
              disabledForegroundColor: AppColors.goldLight,
              side: const BorderSide(color: AppColors.gold, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            child: content,
          ),
        );
      case HaButtonType.text:
        return SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: TextButton(
            onPressed: isDisabled ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.gold,
              disabledForegroundColor: AppColors.goldLight,
            ),
            child: content,
          ),
        );
    }
  }
}
