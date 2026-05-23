import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_assets.dart';
import '../constants/app_strings.dart';

class HaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? title;

  const HaAppBar({
    super.key,
    this.showBackButton = false,
    this.actions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.nightBrown,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      leadingWidth: showBackButton ? 56 : 140,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Iconsax.arrow_right_3, color: AppColors.white),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.pop();
                }
              },
            )
          : Padding(
              padding: const EdgeInsets.only(right: AppDimensions.paddingL),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.galleryCream,
                    backgroundImage: AssetImage(AppAssets.logoDark),
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.welcomeBack,
                        style: AppTextStyles.caption.copyWith(color: AppColors.subtleText),
                      ),
                      Text(
                        'سارة محمد',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      title: title ?? Image.asset(
        AppAssets.appBarLogo,
        height: AppDimensions.logoAppBarHeight,
        fit: BoxFit.contain,
      ),
      actions: actions ?? [
        if (!showBackButton) ...[
          Row(
            children: [
              const Icon(Iconsax.location, size: 16, color: AppColors.gold),
              const SizedBox(width: 4),
              Text(
                'الرياض',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
              ),
            ],
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Iconsax.notification, color: AppColors.white),
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 8,
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppDimensions.paddingM),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);
}
