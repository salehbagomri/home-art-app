import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/ha_app_bar.dart';
import '../../../../core/widgets/ha_card.dart';
import '../../../../core/widgets/ha_button.dart';
import '../../../../core/widgets/ha_loading.dart';
import '../bloc/support_cubit.dart';
import '../bloc/support_state.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'closed':
        return AppColors.subtleText;
      case 'open':
        return AppColors.gold;
      case 'processing':
      default:
        return AppColors.statusInProgress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportCubit()..loadSupportTickets(),
      child: Scaffold(
        appBar: const HaAppBar(),
        body: BlocBuilder<SupportCubit, SupportState>(
          builder: (context, state) {
            if (state is SupportLoading) {
              return const HaLoading();
            } else if (state is SupportError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppDimensions.spacingM),
                    HaButton.outlined(
                      text: AppStrings.retry,
                      width: 150,
                      onPressed: () => context.read<SupportCubit>().loadSupportTickets(),
                    ),
                  ],
                ),
              );
            } else if (state is SupportLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                  vertical: AppDimensions.screenPaddingV,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(Iconsax.headphone, color: AppColors.gold, size: 28),
                        const SizedBox(width: AppDimensions.spacingS),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.support,
                              style: AppTextStyles.headlineSmall,
                            ),
                            Text(
                              AppStrings.supportSubtitle,
                              style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // Grid of 4 Action Cards
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.35,
                      children: [
                        _buildActionCard(Iconsax.call_calling, AppStrings.callUs, AppStrings.phoneSupport),
                        _buildActionCard(Iconsax.message, AppStrings.whatsapp, AppStrings.quickResponse),
                        _buildActionCard(Iconsax.message_question, AppStrings.faq, AppStrings.quickAnswers),
                        _buildActionCard(Iconsax.gallery_export, AppStrings.uploadPhotos, AppStrings.uploadPhotosHint),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // Help Center Banner
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                        image: DecorationImage(
                          image: const AssetImage('App_Assets/3.jpeg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            AppColors.nightBrown.withValues(alpha: 0.5),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.helpCenter,
                                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  AppStrings.helpCenterSubtitle,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.galleryCream),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacingM),
                          HaButton.primary(
                            text: AppStrings.exploreCenter,
                            width: 120,
                            height: 40,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // Current Tickets Section
                    Text(
                      AppStrings.myTickets,
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    ...state.tickets.map((t) {
                      final statusColor = _getStatusColor(t['status']);

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                        child: HaCard(
                          padding: const EdgeInsets.all(AppDimensions.paddingM),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    t['title'],
                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                    ),
                                    child: Text(
                                      t['statusText'],
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'رقم التذكرة: ${t['id']} | ${t['date']}',
                                    style: AppTextStyles.caption,
                                  ),
                                  Text(
                                    t['category'],
                                    style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Text(
                                'التحديث الأخير: ${t['lastUpdate']}',
                                style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: AppDimensions.spacingXL),

                    // Live Chat Card
                    HaCard(
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.galleryCream,
                            backgroundImage: AssetImage('App_Assets/logo/homeart-logo-dark.png'),
                          ),
                          const SizedBox(width: AppDimensions.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.liveChat,
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  AppStrings.liveChatAvailable,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.guaranteeGreen),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Iconsax.arrow_left_2, color: AppColors.subtleText, size: 16),
                        ],
                      ),
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

  Widget _buildActionCard(IconData icon, String title, String subtitle) {
    return HaCard(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.gold, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.nightBrown),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
