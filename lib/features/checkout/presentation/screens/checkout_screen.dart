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
import '../../../../core/widgets/ha_button.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _couponCtrl = TextEditingController();
  final List<String> _stepperLabels = ['السلة', 'الطلب', 'الدفع', 'التأكيد'];

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: const HaAppBar(showBackButton: true),
        body: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state.currentStep == 3) {
              return _buildSuccessView(context);
            }

            return Column(
              children: [
                // 1. Title section
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.screenPaddingH,
                    AppDimensions.screenPaddingV,
                    AppDimensions.screenPaddingH,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.orderSummary,
                        style: AppTextStyles.headlineSmall,
                      ),
                      Text(
                        AppStrings.orderSummarySubtitle,
                        style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // 2. Stepper
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      final isCompleted = index < state.currentStep;
                      final isCurrent = index == state.currentStep;

                      return Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: index == 0
                                        ? Colors.transparent
                                        : (isCompleted || isCurrent ? AppColors.gold : AppColors.cardBorder),
                                    thickness: 2,
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted || isCurrent ? AppColors.gold : AppColors.white,
                                    border: Border.all(
                                      color: isCompleted || isCurrent ? AppColors.gold : AppColors.cardBorder,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: isCompleted
                                      ? const Icon(Icons.check, color: AppColors.white, size: 12)
                                      : Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: isCurrent ? AppColors.white : AppColors.subtleText,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: index == 3
                                        ? Colors.transparent
                                        : (isCompleted ? AppColors.gold : AppColors.cardBorder),
                                    thickness: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _stepperLabels[index],
                              style: TextStyle(
                                fontSize: 9,
                                color: isCurrent ? AppColors.gold : AppColors.subtleText,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // 3. Main Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                    child: Column(
                      children: [
                        // Order details preview
                        HaCard(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                child: Image.asset(
                                  'App_Assets/1.jpeg',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'أريكة زاوية فاخرة - موديل أليغانس',
                                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'المساحة: غرفة معيشة | المقاس: 4 مقاعد',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),

                        // Delivery details
                        HaCard(
                          child: Row(
                            children: [
                              const Icon(Iconsax.truck_fast, color: AppColors.gold, size: 24),
                              const SizedBox(width: AppDimensions.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.deliveryAndWarranty,
                                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${AppStrings.expectedDate}: 2026-05-27',
                                      style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),

                        // Delivery Address
                        HaCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Iconsax.location, color: AppColors.gold, size: 24),
                                  const SizedBox(width: AppDimensions.spacingM),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.deliveryAddress,
                                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'الرياض، حي النرجس، فيلا 12',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                AppStrings.edit,
                                style: AppTextStyles.link.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),

                        // Coupon code
                        HaCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _couponCtrl,
                                  style: AppTextStyles.bodyMedium,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.enterDiscountCode,
                                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.subtleText),
                                    prefixIcon: const Icon(Iconsax.discount_shape, size: 20, color: AppColors.woodBrown),
                                    filled: true,
                                    fillColor: AppColors.inputFill,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              HaButton.primary(
                                text: AppStrings.apply,
                                width: 80,
                                height: 50,
                                onPressed: () {
                                  context.read<CheckoutBloc>().add(ApplyDiscountCode(_couponCtrl.text));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),

                        // Price details breakdown
                        HaCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppStrings.priceDetails, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: AppDimensions.spacingM),
                              _buildPriceRow(AppStrings.productsValue, '${state.productsValue} ${AppStrings.currency}'),
                              if (state.discountAmount > 0) ...[
                                const SizedBox(height: 8),
                                _buildPriceRow('خصم كود الترويج (${state.discountCode})', '-${state.discountAmount} ${AppStrings.currency}', isDiscount: true),
                              ],
                              const SizedBox(height: 8),
                              _buildPriceRow(AppStrings.deliveryFee, '${state.deliveryFee} ${AppStrings.currency}'),
                              const SizedBox(height: 8),
                              _buildPriceRow(AppStrings.vat, '${state.vat.toStringAsFixed(2)} ${AppStrings.currency}'),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppStrings.totalAmount, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                  Text(
                                    '${state.totalAmount.toStringAsFixed(2)} ${AppStrings.currency}',
                                    style: AppTextStyles.priceLarge.copyWith(color: AppColors.gold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppStrings.includesVat,
                                style: AppTextStyles.caption.copyWith(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),

                        // Payment Methods
                        HaCard(
                          child: RadioGroup<String>(
                            groupValue: state.paymentMethod,
                            onChanged: (val) {
                              if (val != null) {
                                context.read<CheckoutBloc>().add(SetPaymentMethod(val));
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.paymentMethodLabel, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: AppDimensions.spacingM),
                                _buildPaymentRadio(context, 'mada', AppStrings.mada, Iconsax.card, state.paymentMethod),
                                const Divider(height: 12),
                                _buildPaymentRadio(context, 'visa', AppStrings.visa, Iconsax.wallet_money, state.paymentMethod),
                                const Divider(height: 12),
                                _buildPaymentRadio(context, 'applePay', AppStrings.applePay, Iconsax.mobile, state.paymentMethod),
                                const Divider(height: 12),
                                _buildPaymentRadio(context, 'tamara', AppStrings.tamara, Iconsax.direct_send, state.paymentMethod),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXXL),
                      ],
                    ),
                  ),
                ),

                // 4. Secure checkout button
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
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
                  child: Column(
                    children: [
                      HaButton.primary(
                        text: AppStrings.approveAndPay,
                        isLoading: state.isSubmitting,
                        icon: const Icon(Iconsax.shield_tick, color: AppColors.white, size: 18),
                        onPressed: () {
                          context.read<CheckoutBloc>().add(SubmitPayment());
                        },
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.shield_tick, size: 14, color: AppColors.guaranteeGreen),
                          SizedBox(width: 4),
                          Text(
                            AppStrings.securePayment,
                            style: TextStyle(fontSize: 10, color: AppColors.guaranteeGreen),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: isDiscount ? AppColors.guaranteeGreen : AppColors.nightBrown,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRadio(BuildContext context, String value, String title, IconData icon, String groupValue) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () {
        context.read<CheckoutBloc>().add(SetPaymentMethod(value));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              activeColor: AppColors.gold,
            ),
            const SizedBox(width: 8),
            Icon(icon, color: isSelected ? AppColors.gold : AppColors.woodBrown, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.gold : AppColors.nightBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Iconsax.tick_circle,
              color: AppColors.guaranteeGreen,
              size: 80,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Text(
              'تم الدفع بنجاح!',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'رقم العملية: TXN-448209',
              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'تم اعتماد طلبك وبدء العمل على تجهيزه وتوصيله. يمكنك تتبع حالة الطلب خطوة بخطوة من شاشة الطلبات.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.woodBrown),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingHuge),
            HaButton.primary(
              text: 'تتبع الطلب',
              width: 180,
              onPressed: () => context.go('/order/ORD-9874'), // Route to the mock order we created
            ),
            const SizedBox(height: AppDimensions.spacingM),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}
