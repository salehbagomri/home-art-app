import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/ha_app_bar.dart';
import '../../../../core/widgets/ha_card.dart';
import '../../../../core/widgets/ha_loading.dart';
import '../../../../core/widgets/ha_button.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadUserProfile(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: const HaAppBar(showBackButton: true),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const HaLoading();
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppDimensions.spacingM),
                    HaButton.outlined(
                      text: AppStrings.retry,
                      width: 150,
                      onPressed: () => context.read<ProfileCubit>().loadUserProfile(),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoaded) {
              final user = state.userData;
              final List<dynamic> addresses = user['savedAddresses'];
              final List<dynamic> measurements = user['savedMeasurements'];
              final List<dynamic> favorites = user['favoriteProducts'];
              final List<dynamic> warranties = user['warrantyCards'];

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                  vertical: AppDimensions.screenPaddingV,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. User Info Card
                    HaCard(
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 36,
                            backgroundColor: AppColors.galleryCream,
                            backgroundImage: AssetImage(AppAssets.logoDark),
                          ),
                          const SizedBox(width: AppDimensions.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user['name'],
                                      style: AppTextStyles.headlineSmall,
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.gold.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.star, color: AppColors.gold, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            AppStrings.premiumMember,
                                            style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 9),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(user['email'], style: AppTextStyles.caption),
                                Text(user['phone'], style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Iconsax.edit_2, color: AppColors.gold, size: 20),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingM),

                    // 2. Loyalty Points Card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.nightBrown,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      ),
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.pointsBalance,
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.subtleText),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Iconsax.coin, color: AppColors.gold, size: 24),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${user['points']}',
                                        style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                ),
                                child: Text(
                                  'المستوى: ${user['level']} 👑',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white10, height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'المطلوب للترقية للمستوى القادم',
                                style: AppTextStyles.caption.copyWith(color: AppColors.subtleText),
                              ),
                              Text(
                                '${user['pointsToUpgrade']} نقطة',
                                style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // 3. Saved Addresses
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.savedAddresses, style: AppTextStyles.sectionTitle),
                        Text(AppStrings.viewAll, style: AppTextStyles.link.copyWith(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: addresses.length + 1,
                        itemBuilder: (context, index) {
                          if (index == addresses.length) {
                            return _buildAddCard(AppStrings.addAddress);
                          }
                          final addr = addresses[index];
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.only(left: 12),
                            child: HaCard(
                              padding: const EdgeInsets.all(AppDimensions.paddingM),
                              showBorder: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(addr['title'], style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    addr['address'],
                                    style: AppTextStyles.caption,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // 4. Saved Measurements
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.savedMeasurements, style: AppTextStyles.sectionTitle),
                        Text(AppStrings.viewAll, style: AppTextStyles.link.copyWith(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: measurements.length + 1,
                        itemBuilder: (context, index) {
                          if (index == measurements.length) {
                            return _buildAddCard(AppStrings.addMeasurement);
                          }
                          final meas = measurements[index];
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.only(left: 12),
                            child: HaCard(
                              padding: const EdgeInsets.all(AppDimensions.paddingM),
                              showBorder: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(meas['title'], style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${meas['width']}x${meas['length']}x${meas['height']} م',
                                    style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // 5. Favorite Products
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.favoriteProducts, style: AppTextStyles.sectionTitle),
                        Text(AppStrings.viewAll, style: AppTextStyles.link.copyWith(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final item = favorites[index];
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.only(left: 12),
                            child: HaCard(
                              padding: EdgeInsets.zero,
                              onTap: () => context.go('/product/${item['id']}'),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(AppDimensions.radiusL),
                                          topRight: Radius.circular(AppDimensions.radiusL),
                                        ),
                                        child: Image.asset(
                                          item['image'],
                                          height: 80,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: Container(
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white.withOpacity(0.9)),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(Icons.favorite, color: AppColors.error, size: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${item['price']} ر.س',
                                          style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // 6. Warranty Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.warrantyCards, style: AppTextStyles.sectionTitle),
                        Text(AppStrings.viewAll, style: AppTextStyles.link.copyWith(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    ...warranties.map((w) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                        child: HaCard(
                          padding: const EdgeInsets.all(AppDimensions.paddingM),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(w['productName'], style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('رقم الضمان: ${w['warrantyNumber']} | صالح حتى: ${w['validUntil']}', style: AppTextStyles.caption),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.guaranteeGreen.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                ),
                                child: Text(
                                  AppStrings.valid,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.guaranteeGreen, fontWeight: FontWeight.bold, fontSize: 9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // 7. Notification Preference Card
                    HaCard(
                      child: Row(
                        children: [
                          const Icon(Iconsax.notification, color: AppColors.gold, size: 24),
                          const SizedBox(width: AppDimensions.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.notificationPrefs, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                Text(AppStrings.manageNotifications, style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          const Icon(Iconsax.arrow_left_2, color: AppColors.subtleText, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // 8. Settings Grid Dashboard
                    Text(AppStrings.settings, style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppDimensions.spacingM),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.15,
                      children: [
                        _buildSettingGridItem(context, Iconsax.user, AppStrings.myAccount, () {}),
                        _buildSettingGridItem(context, Iconsax.lock, AppStrings.changePassword, () {}),
                        _buildSettingGridItem(context, Iconsax.card, AppStrings.paymentMethods, () {}),
                        _buildSettingGridItem(context, Iconsax.profile_circle, AppStrings.personalProfile, () {}),
                        _buildSettingGridItem(context, Iconsax.message_question, AppStrings.help, () {}),
                        _buildSettingGridItem(context, Iconsax.logout, AppStrings.logout, () {
                          context.go(AppRoutes.login);
                        }, isLogout: true),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingXXL),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAddCard(String title) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.gold, style: BorderStyle.values[0] /* dashed mock style */),
          color: AppColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.add_circle, color: AppColors.gold, size: 24),
            const SizedBox(height: 4),
            Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingGridItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return HaCard(
      padding: EdgeInsets.zero,
      showBorder: true,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isLogout ? AppColors.error : AppColors.gold, size: 22),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: isLogout ? AppColors.error : AppColors.nightBrown,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
