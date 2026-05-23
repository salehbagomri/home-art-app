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
import '../../../../core/widgets/ha_button.dart';
import '../../../../core/widgets/ha_loading.dart';
import '../../../../core/widgets/ha_card.dart';
import '../bloc/product_details_cubit.dart';
import '../bloc/product_details_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentImageIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageController.dispose();
    _currentImageIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsCubit()..loadProductDetails(widget.productId),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: HaAppBar(
          showBackButton: true,
          actions: [
            IconButton(
              icon: const Icon(Iconsax.heart, color: AppColors.white),
              onPressed: () {},
            ),
            const SizedBox(width: AppDimensions.paddingS),
          ],
        ),
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const HaLoading();
            } else if (state is ProductDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppDimensions.spacingM),
                    HaButton.outlined(
                      text: AppStrings.retry,
                      width: 150,
                      onPressed: () => context.read<ProductDetailsCubit>().loadProductDetails(widget.productId),
                    ),
                  ],
                ),
              );
            } else if (state is ProductDetailsLoaded) {
              final product = state.product;
              final List<dynamic> images = product['images'];

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: AppDimensions.paddingHuge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Image Gallery
                          Stack(
                            children: [
                              SizedBox(
                                height: 300,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: images.length,
                                  onPageChanged: (idx) => _currentImageIndex.value = idx,
                                  itemBuilder: (context, index) {
                                    return Image.asset(
                                      images[index],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              // Counter Badge (1/6 style)
                              Positioned(
                                bottom: 12,
                                left: 16,
                                child: ValueListenableBuilder<int>(
                                  valueListenable: _currentImageIndex,
                                  builder: (context, idx, child) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.nightBrown.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                      ),
                                      child: Text(
                                        '${idx + 1} / ${images.length}',
                                        style: AppTextStyles.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // "New" Badge
                              if (product['isNew'] == true)
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.guaranteeGreen,
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                                    ),
                                    child: const Text(
                                      AppStrings.newBadge,
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spacingM),

                          // Thumbnails row
                          if (images.length > 1) ...[
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return ValueListenableBuilder<int>(
                                    valueListenable: _currentImageIndex,
                                    builder: (context, currentIdx, child) {
                                      final isSelected = index == currentIdx;
                                      return GestureDetector(
                                        onTap: () {
                                          _pageController.animateToPage(
                                            index,
                                            duration: const Duration(milliseconds: 350),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 8),
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                                            border: Border.all(
                                              color: isSelected ? AppColors.gold : AppColors.cardBorder,
                                              width: isSelected ? 2 : 1,
                                            ),
                                            image: DecorationImage(
                                              image: AssetImage(images[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingL),
                          ],

                          // 2. Product Info
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product['name'],
                                        style: AppTextStyles.headlineMedium,
                                      ),
                                    ),
                                    const Icon(
                                      Iconsax.bag_2,
                                      color: AppColors.gold,
                                      size: 28,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDimensions.spacingS),

                                // Rating and Price
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: AppColors.gold, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${product['rating']}',
                                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '(${product['reviewsCount']} ${AppStrings.reviews})',
                                          style: AppTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${product['price']} ${AppStrings.currency}',
                                          style: AppTextStyles.priceLarge.copyWith(color: AppColors.gold),
                                        ),
                                        Text(
                                          AppStrings.includesTax,
                                          style: AppTextStyles.caption.copyWith(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDimensions.spacingL),

                                // Description
                                Text(
                                  product['description'],
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.woodBrown),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppStrings.showMore,
                                  style: AppTextStyles.link.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                const SizedBox(height: AppDimensions.spacingXL),

                                // === Options ===
                                // Colors Picker
                                if ((product['colors'] as List).isNotEmpty) ...[
                                  Text(
                                    AppStrings.colorLabel,
                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: AppDimensions.spacingS),
                                  Row(
                                    children: (product['colors'] as List).map((colorHex) {
                                      final isSelected = state.selectedColor == colorHex;
                                      return GestureDetector(
                                        onTap: () => context.read<ProductDetailsCubit>().selectColor(colorHex),
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 12),
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected ? AppColors.gold : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: AppDimensions.spacingL),
                                ],

                                // Sizes Picker
                                if ((product['sizes'] as List).isNotEmpty) ...[
                                  Text(
                                    AppStrings.sizeLabel,
                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: AppDimensions.spacingS),
                                  Row(
                                    children: (product['sizes'] as List).map((size) {
                                      final isSelected = state.selectedSize == size;
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: ChoiceChip(
                                          selected: isSelected,
                                          label: Text(size),
                                          selectedColor: AppColors.white,
                                          labelStyle: AppTextStyles.caption.copyWith(
                                            color: isSelected ? AppColors.gold : AppColors.nightBrown,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                          backgroundColor: AppColors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                            side: BorderSide(
                                              color: isSelected ? AppColors.gold : AppColors.cardBorder,
                                              width: isSelected ? 1.5 : 1,
                                            ),
                                          ),
                                          onSelected: (val) {
                                            if (val) {
                                              context.read<ProductDetailsCubit>().selectSize(size);
                                            }
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: AppDimensions.spacingL),
                                ],

                                // Material Picker
                                Text(
                                  AppStrings.materialLabel,
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: AppDimensions.spacingS),
                                InputChip(
                                  label: Text('${state.selectedMaterial} >'),
                                  backgroundColor: AppColors.white,
                                  side: const BorderSide(color: AppColors.cardBorder),
                                  onPressed: () {},
                                ),
                                const SizedBox(height: AppDimensions.spacingXL),

                                // Delivery Info
                                Container(
                                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                                  decoration: BoxDecoration(
                                    color: AppColors.galleryCream,
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Iconsax.truck_fast, color: AppColors.gold, size: 24),
                                      const SizedBox(width: AppDimensions.spacingM),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppStrings.deliveryInfo,
                                              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.nightBrown),
                                            ),
                                            Text(
                                              AppStrings.freeInstallation,
                                              style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Action Buttons Bottom Bar
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
                    child: Row(
                      children: [
                        // Left 35% - Add to Cart
                        Expanded(
                          flex: 35,
                          child: HaButton.outlined(
                            text: AppStrings.addToCart,
                            icon: const Icon(Iconsax.bag_2, color: AppColors.gold, size: 18),
                            onPressed: () => context.go(AppRoutes.checkout),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingM),
                        // Right 65% - Custom size design request
                        Expanded(
                          flex: 65,
                          child: HaButton.primary(
                            text: AppStrings.orderCustomSize,
                            icon: const Icon(Iconsax.ruler, color: AppColors.white, size: 18),
                            onPressed: () => context.go(AppRoutes.customDesign),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
