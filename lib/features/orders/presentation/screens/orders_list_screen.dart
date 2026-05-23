import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/ha_app_bar.dart';
import '../../../../core/widgets/ha_card.dart';
import '../../../../core/widgets/ha_loading.dart';
import '../../../../core/widgets/ha_button.dart';
import '../bloc/orders_cubit.dart';
import '../bloc/orders_state.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

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
      create: (context) => OrdersCubit()..loadAllOrders(),
      child: Scaffold(
        appBar: const HaAppBar(),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const HaLoading();
            } else if (state is OrdersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppDimensions.spacingM),
                    HaButton.outlined(
                      text: AppStrings.retry,
                      width: 150,
                      onPressed: () => context.read<OrdersCubit>().loadAllOrders(),
                    ),
                  ],
                ),
              );
            } else if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return Center(
                  child: Text('لا توجد طلبات سابقة', style: AppTextStyles.bodyMedium),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                  vertical: AppDimensions.screenPaddingV,
                ),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  final statusColor = _getStatusColor(order['status']);
                  final mainItem = order['items'][0];

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                    child: HaCard(
                      padding: const EdgeInsets.all(AppDimensions.paddingM),
                      onTap: () => context.go('/order/${order['id']}'),
                      child: Row(
                        children: [
                          // Item Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            child: Image.asset(
                              mainItem['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacingM),

                          // Order Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppStrings.orderNumber}: ${order['id']}',
                                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.nightBrown),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                      ),
                                      child: Text(
                                        order['statusText'],
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${AppStrings.orderDate}: ${order['date']}',
                                  style: AppTextStyles.caption,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${AppStrings.orderTotal}: ${order['total']} ${AppStrings.currency}',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacingS),

                          // Arrow Left (RTL forward button)
                          const Icon(
                            Iconsax.arrow_left_2,
                            color: AppColors.subtleText,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
