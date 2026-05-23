import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/ha_app_bar.dart';
import '../../../../core/widgets/ha_search_bar.dart';
import '../../../../core/widgets/ha_card.dart';
import '../../../../core/widgets/ha_loading.dart';
import '../../../../core/widgets/ha_button.dart';
import '../bloc/store_cubit.dart';
import '../bloc/store_state.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _filterOptions = [
    'جديد',
    'المجالس',
    'غرف النوم',
    'المكاتب',
    'المشاريع والفنادق',
    'المطابخ',
    'الأبواب',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreCubit()..loadStoreData(),
      child: Scaffold(
        appBar: const HaAppBar(),
        body: BlocBuilder<StoreCubit, StoreState>(
          builder: (context, state) {
            if (state is StoreLoading) {
              return const HaLoading();
            } else if (state is StoreError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppDimensions.spacingM),
                    HaButton.outlined(
                      text: AppStrings.retry,
                      width: 150,
                      onPressed: () => context.read<StoreCubit>().loadStoreData(),
                    ),
                  ],
                ),
              );
            } else if (state is StoreLoaded) {
              return Column(
                children: [
                  // Search Bar + Header section
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
                        // Search Bar
                        HaSearchBar(
                          controller: _searchCtrl,
                          onChanged: (val) {
                            // Local search filter mock
                            // (Just triggers state reload with matching products)
                          },
                          onFilterTap: () {
                            // Show active filters dialog or toggle first filter
                            context.read<StoreCubit>().toggleFilter('جديد');
                          },
                        ),
                        const SizedBox(height: AppDimensions.spacingL),

                        // Store Header
                        Row(
                          children: [
                            const Icon(Iconsax.shop, color: AppColors.gold, size: 28),
                            const SizedBox(width: AppDimensions.spacingS),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.store,
                                  style: AppTextStyles.headlineSmall,
                                ),
                                Text(
                                  AppStrings.storeSubtitle,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingM),

                        // Sort Row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                '${AppStrings.sortBy}: ',
                                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: AppDimensions.spacingS),
                              _buildSortChip(context, AppStrings.newest, 'الأحدث', state.activeSort),
                              const SizedBox(width: AppDimensions.spacingS),
                              _buildSortChip(context, AppStrings.bestSelling, 'الأكثر مبيعاً', state.activeSort),
                              const SizedBox(width: AppDimensions.spacingS),
                              _buildSortChip(context, 'السعر', 'السعر', state.activeSort),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),

                        // Filter Chips (Horizontal)
                        SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filterOptions.length,
                            itemBuilder: (context, index) {
                              final filter = _filterOptions[index];
                              final isSelected = state.activeFilters.contains(filter);

                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FilterChip(
                                  selected: isSelected,
                                  label: Text(filter),
                                  selectedColor: AppColors.nightBrown,
                                  checkmarkColor: AppColors.white,
                                  labelStyle: AppTextStyles.caption.copyWith(
                                    color: isSelected ? AppColors.white : AppColors.nightBrown,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  backgroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                    side: BorderSide(
                                      color: isSelected ? AppColors.nightBrown : AppColors.cardBorder,
                                    ),
                                  ),
                                  onSelected: (val) {
                                    context.read<StoreCubit>().toggleFilter(filter);
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        // Active Filters Row
                        if (state.activeFilters.isNotEmpty) ...[
                          const SizedBox(height: AppDimensions.spacingS),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${state.products.length} ${AppStrings.productsCount}',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.woodBrown),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<StoreCubit>().clearAllFilters();
                                },
                                child: const Text(
                                  AppStrings.clearAll,
                                  style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: AppDimensions.spacingS),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${state.products.length} ${AppStrings.productsCount}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.woodBrown),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Products Grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPaddingH,
                        vertical: AppDimensions.paddingS,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        final isFavorite = product['isFavorite'] == true;

                        return HaCard(
                          padding: EdgeInsets.zero,
                          onTap: () => context.go('/product/${product['id']}'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image and badges
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(AppDimensions.radiusL),
                                      topRight: Radius.circular(AppDimensions.radiusL),
                                    ),
                                    child: Image.asset(
                                      product['images'][0],
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // "New" Badge
                                  if (product['isNew'] == true)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.guaranteeGreen,
                                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                                        ),
                                        child: const Text(
                                          AppStrings.newBadge,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  // Heart Toggle
                                  Positioned(
                                    top: 4,
                                    left: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.white.withValues(alpha: 0.85),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          isFavorite ? Iconsax.heart : Iconsax.heart,
                                          color: isFavorite ? AppColors.error : AppColors.woodBrown,
                                        ),
                                        onPressed: () {
                                          context.read<StoreCubit>().toggleFavorite(product['id']);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Product Info
                              Padding(
                                padding: const EdgeInsets.all(AppDimensions.paddingM),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${product['material']} - ${product['category']}',
                                      style: AppTextStyles.caption.copyWith(color: AppColors.subtleText),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppDimensions.spacingM),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${product['price']} ${AppStrings.currency}',
                                          style: AppTextStyles.priceSmall.copyWith(color: AppColors.gold),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.gold.withValues(alpha: 0.1),
                                          ),
                                          child: const Icon(
                                            Iconsax.bag_2,
                                            size: 16,
                                            color: AppColors.gold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

  Widget _buildSortChip(BuildContext context, String label, String value, String activeValue) {
    final isSelected = value == activeValue;
    return ChoiceChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: AppColors.gold,
      labelStyle: AppTextStyles.caption.copyWith(
        color: isSelected ? AppColors.white : AppColors.nightBrown,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        side: BorderSide(
          color: isSelected ? AppColors.gold : AppColors.cardBorder,
        ),
      ),
      onSelected: (val) {
        if (val) {
          context.read<StoreCubit>().changeSort(value);
        }
      },
    );
  }
}
