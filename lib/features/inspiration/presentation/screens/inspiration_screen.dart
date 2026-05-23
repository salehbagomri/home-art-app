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
import '../../../../core/widgets/ha_search_bar.dart';
import '../../../../core/widgets/ha_loading.dart';
import '../../../../core/widgets/ha_button.dart';
import '../bloc/inspiration_cubit.dart';
import '../bloc/inspiration_state.dart';

class InspirationScreen extends StatefulWidget {
  const InspirationScreen({super.key});

  @override
  State<InspirationScreen> createState() => _InspirationScreenState();
}

class _InspirationScreenState extends State<InspirationScreen> {
  final List<String> _categories = [
    'الكل',
    'غرف النوم',
    'المجالس',
    'المكاتب',
    'المشاريع والفنادق',
    'الأبواب',
    'المطابخ',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InspirationCubit()..loadInspirations(),
      child: Scaffold(
        appBar: const HaAppBar(showBackButton: true),
        body: BlocBuilder<InspirationCubit, InspirationState>(
          builder: (context, state) {
            if (state is InspirationLoading) {
              return const HaLoading();
            } else if (state is InspirationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppDimensions.spacingM),
                    HaButton.outlined(
                      text: AppStrings.retry,
                      width: 150,
                      onPressed: () => context.read<InspirationCubit>().loadInspirations(),
                    ),
                  ],
                ),
              );
            } else if (state is InspirationLoaded) {
              return Column(
                children: [
                  // Upper search & tabs
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPaddingH,
                      AppDimensions.screenPaddingV,
                      AppDimensions.screenPaddingH,
                      0,
                    ),
                    child: Column(
                      children: [
                        HaSearchBar(
                          onFilterTap: () {
                            context.read<InspirationCubit>().changeCategory('الكل');
                          },
                        ),
                        const SizedBox(height: AppDimensions.spacingM),

                        // Segmented Control
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildSegmentButton(
                                  context,
                                  'إلهام',
                                  state.activeTab == 'إلهام',
                                ),
                              ),
                              Expanded(
                                child: _buildSegmentButton(
                                  context,
                                  'كتالوج',
                                  state.activeTab == 'كتالوج',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),

                        // Category Tabs (Horizontal)
                        SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              final cat = _categories[index];
                              final isSelected = state.selectedCategory == cat;

                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<InspirationCubit>().changeCategory(cat);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.nightBrown : AppColors.white,
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                      border: Border.all(
                                        color: isSelected ? AppColors.nightBrown : AppColors.cardBorder,
                                      ),
                                    ),
                                    child: Text(
                                      cat,
                                      style: AppTextStyles.caption.copyWith(
                                        color: isSelected ? AppColors.white : AppColors.nightBrown,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),

                  // Staggered Masonry-style Grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75, // Standard ratio, heights simulated dynamically inside cards
                      ),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        final isLiked = item['isLiked'] == true;
                        final isSaved = item['isSaved'] == true;

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(item['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.2),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.75),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(AppDimensions.paddingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Action icons top row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context.read<InspirationCubit>().toggleSave(item['id']);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.white.withValues(alpha: 0.3),
                                        ),
                                        child: Icon(
                                          isSaved ? Iconsax.archive_book : Iconsax.archive_book,
                                          color: isSaved ? AppColors.gold : AppColors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.read<InspirationCubit>().toggleLike(item['id']);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.white.withValues(alpha: 0.3),
                                        ),
                                        child: Icon(
                                          isLiked ? Iconsax.heart : Iconsax.heart,
                                          color: isLiked ? AppColors.error : AppColors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),

                                // Bottom text
                                Text(
                                  item['title']!,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item['designsCount']} تصاميم مميزة',
                                  style: AppTextStyles.caption.copyWith(color: AppColors.galleryCream, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom CTA Banner
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    decoration: BoxDecoration(
                      color: AppColors.nightBrown,
                      border: Border(
                        top: BorderSide(color: AppColors.cardBorder.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'عثر على كل ما يلهم منزلك',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'تصفح الكتالوج الشامل لجميع الموديلات',
                                style: AppTextStyles.caption.copyWith(color: AppColors.subtleText),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingM),
                        HaButton.primary(
                          text: 'تصفح الكتالوج',
                          width: 130,
                          height: 44,
                          onPressed: () {
                            context.read<InspirationCubit>().changeTab('كتالوج');
                            context.go(AppRoutes.store);
                          },
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

  Widget _buildSegmentButton(BuildContext context, String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<InspirationCubit>().changeTab(title);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM - 4),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  )
                ]
              : null,
        ),
        child: Text(
          title,
          style: AppTextStyles.buttonMedium.copyWith(
            color: isSelected ? AppColors.nightBrown : AppColors.subtleText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
