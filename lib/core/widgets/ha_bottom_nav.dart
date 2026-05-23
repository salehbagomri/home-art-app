import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_strings.dart';

class HaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      height: AppDimensions.bottomNavHeight,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.subtleText,
        selectedLabelStyle: AppTextStyles.navLabel.copyWith(color: AppColors.gold, fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.navLabel.copyWith(color: AppColors.subtleText),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Iconsax.home_2),
            ),
            label: AppStrings.navHome,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Iconsax.shop),
            ),
            label: AppStrings.navStore,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Iconsax.clipboard_text),
            ),
            label: AppStrings.navOrders,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Iconsax.headphone),
            ),
            label: AppStrings.navSupport,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Iconsax.user),
            ),
            label: AppStrings.navProfile,
          ),
        ],
      ),
    );
  }
}
