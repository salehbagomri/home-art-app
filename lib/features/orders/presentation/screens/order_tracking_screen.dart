import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/ha_app_bar.dart';
import '../../../../core/widgets/ha_card.dart';
import '../../../../core/widgets/ha_loading.dart';
import '../../../../core/widgets/ha_button.dart';
import '../bloc/order_tracking_cubit.dart';
import '../bloc/order_tracking_state.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.guaranteeGreen;
      case 'cancelled':
        return AppColors.error;
      case 'inProgress':
      default:
        return AppColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderTrackingCubit()..loadOrderTracking(orderId),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: const HaAppBar(showBackButton: true),
        body: BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
          builder: (context, state) {
            if (state is OrderTrackingLoading) {
              return const HaLoading();
            } else if (state is OrderTrackingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppDimensions.spacingM),
                    HaButton.outlined(
                      text: AppStrings.retry,
                      width: 150,
                      onPressed: () => context.read<OrderTrackingCubit>().loadOrderTracking(orderId),
                    ),
                  ],
                ),
              );
            } else if (state is OrderTrackingLoaded) {
              final order = state.order;
              final statusColor = _getStatusColor(order['status']);
              final List<dynamic> timeline = order['timeline'];
              final List<dynamic> items = order['items'];

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                  vertical: AppDimensions.screenPaddingV,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      AppStrings.orderTracking,
                      style: AppTextStyles.headlineSmall,
                    ),
                    Text(
                      AppStrings.orderTrackingSubtitle,
                      style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                    ),
                    const SizedBox(height: AppDimensions.spacingL),

                    // Order Info Card
                    HaCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppStrings.orderNumber}: ${order['id']}',
                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${AppStrings.orderDate}: ${order['date']}',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                            ),
                            child: Text(
                              order['statusText'],
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingM),

                    // Contact Support Card
                    HaCard(
                      onTap: () => context.go(AppRoutes.support),
                      child: Row(
                        children: [
                          const Icon(Iconsax.headphone, color: AppColors.gold, size: 24),
                          const SizedBox(width: AppDimensions.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.contactSupport,
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  AppStrings.contactSupportHint,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Iconsax.arrow_left_2, color: AppColors.subtleText, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingM),

                    // Vertical Timeline Card
                    HaCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.orderStatus,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppDimensions.spacingXL),

                          // Vertical Line Tracker
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: timeline.length,
                            itemBuilder: (context, index) {
                              final event = timeline[index];
                              final isCompleted = event['isCompleted'] == true;
                              final isCurrent = event['isCurrent'] == true;

                              return IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Bullet Indicator and line
                                    Column(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isCompleted
                                                ? AppColors.guaranteeGreen
                                                : (isCurrent ? AppColors.gold : AppColors.white),
                                            border: Border.all(
                                              color: isCompleted
                                                  ? AppColors.guaranteeGreen
                                                  : (isCurrent ? AppColors.gold : AppColors.cardBorder),
                                              width: 2,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: isCompleted
                                              ? const Icon(Icons.check, color: AppColors.white, size: 12)
                                              : (isCurrent
                                                  ? Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors.white,
                                                      ),
                                                    )
                                                  : null),
                                        ),
                                        if (index < timeline.length - 1)
                                          Expanded(
                                            child: Container(
                                              width: 2,
                                              color: isCompleted ? AppColors.guaranteeGreen : AppColors.cardBorder,
                                              margin: const EdgeInsets.symmetric(vertical: 4),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: AppDimensions.spacingM),

                                    // Content text
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 24.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event['title'],
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                fontWeight: isCurrent || isCompleted ? FontWeight.bold : FontWeight.normal,
                                                color: isCurrent || isCompleted ? AppColors.nightBrown : AppColors.subtleText,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              event['subtitle'],
                                              style: AppTextStyles.caption,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingM),

                    // Products in Order Card
                    Text(
                      AppStrings.relatedProducts,
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    ...items.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                        child: HaCard(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                child: Image.asset(
                                  item['image'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'الخامة: ${item['material']} | الكمية: ${item['quantity']}',
                                      style: AppTextStyles.caption,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item['price']} ${AppStrings.currency}',
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: AppDimensions.spacingM),

                    // Two Split Cards
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card 1: Order Info
                        Expanded(
                          child: HaCard(
                            padding: const EdgeInsets.all(AppDimensions.paddingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.orderInfo,
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: AppDimensions.spacingM),
                                Text(
                                  '${AppStrings.paymentMethod}: ${order['paymentMethod']}',
                                  style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppStrings.orderTotal}: ${order['total']} ${AppStrings.currency}',
                                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.gold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Card 2: Delivery Info
                        Expanded(
                          child: HaCard(
                            padding: const EdgeInsets.all(AppDimensions.paddingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.deliveryInfo2,
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: AppDimensions.spacingM),
                                Text(
                                  order['deliveryAddress'],
                                  style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppStrings.changeAddress,
                                  style: AppTextStyles.link.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
