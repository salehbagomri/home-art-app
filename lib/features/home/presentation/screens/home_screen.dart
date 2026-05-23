import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/ha_app_bar.dart';
import '../../../../core/widgets/ha_search_bar.dart';
import '../../../../core/widgets/ha_section_header.dart';
import '../../../../core/widgets/ha_card.dart';
import '../../../../core/widgets/ha_button.dart';
import '../../../../core/widgets/ha_loading.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String key) {
    switch (key) {
      case 'bed':
        return Iconsax.home_1;
      case 'lamp':
        return Iconsax.lamp;
      case 'door':
        return Iconsax.key;
      case 'monitor':
        return Iconsax.monitor;
      case 'building':
        return Iconsax.building;
      case 'kitchen':
        return Iconsax.cup;
      default:
        return Iconsax.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: Scaffold(
        appBar: const HaAppBar(),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const HaLoading();
            } else if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppDimensions.spacingM),
                    HaButton.outlined(
                      text: AppStrings.retry,
                      width: 150,
                      onPressed: () => context.read<HomeCubit>().loadHomeData(),
                    ),
                  ],
                ),
              );
            } else if (state is HomeLoaded) {
              return RefreshIndicator(
                color: AppColors.gold,
                onRefresh: () => context.read<HomeCubit>().loadHomeData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.screenPaddingV),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === 1. شريط البحث ===
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                        child: HaSearchBar(
                          readOnly: true,
                          onTap: () => context.go(AppRoutes.store),
                          onFilterTap: () => context.go(AppRoutes.store),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingL),

                      // === 2. البانر الرئيسي (Hero Banner) ===
                      SizedBox(
                        height: AppDimensions.bannerHeight,
                        child: PageView.builder(
                          controller: _bannerController,
                          itemCount: state.banners.length,
                          itemBuilder: (context, index) {
                            final banner = state.banners[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                image: DecorationImage(
                                  image: AssetImage(banner['image']!),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.nightBrown.withOpacity(0.55),
                                    BlendMode.darken,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(AppDimensions.paddingXL),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    banner['title']!,
                                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
                                  ),
                                  const SizedBox(height: AppDimensions.spacingS),
                                  Text(
                                    banner['subtitle']!,
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.galleryCream),
                                  ),
                                  const SizedBox(height: AppDimensions.spacingL),
                                  HaButton.primary(
                                    text: AppStrings.exploreSpaces,
                                    width: 140,
                                    height: AppDimensions.buttonHeightSmall,
                                    onPressed: () => context.go(AppRoutes.store),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingS),
                      Center(
                        child: SmoothPageIndicator(
                          controller: _bannerController,
                          count: state.banners.length,
                          effect: const ExpandingDotsEffect(
                            activeDotColor: AppColors.gold,
                            dotColor: AppColors.cardBorder,
                            dotHeight: 6,
                            dotWidth: 6,
                            expansionFactor: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),

                      // === 3. الأقسام (Categories Row) ===
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                        child: Text(
                          AppStrings.discoverSpace,
                          style: AppTextStyles.sectionTitle,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingM),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            return GestureDetector(
                              onTap: () => context.go(AppRoutes.store),
                              child: Container(
                                width: AppDimensions.categoryItemWidth,
                                margin: const EdgeInsets.only(left: AppDimensions.spacingM),
                                child: Column(
                                  children: [
                                    Container(
                                      height: AppDimensions.categoryIconSize,
                                      width: AppDimensions.categoryIconSize,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                        border: Border.all(color: AppColors.cardBorder),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(category['iconKey']!),
                                        color: AppColors.woodBrown,
                                        size: AppDimensions.iconM,
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.spacingXS),
                                    Text(
                                      category['name']!,
                                      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),

                      // === 4. قسم ألهمني (Inspiration Section) ===
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                        child: HaSectionHeader(
                          title: '✦ ' + AppStrings.inspireMe,
                          onViewAll: () => context.go(AppRoutes.inspiration),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingM),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                          itemCount: state.inspirations.length,
                          itemBuilder: (context, index) {
                            final item = state.inspirations[index];
                            return GestureDetector(
                              onTap: () => context.go(AppRoutes.inspiration),
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.only(left: AppDimensions.spacingL),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                  image: DecorationImage(
                                    image: AssetImage(item['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        AppColors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
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
                                        '${item['designsCount']} تصاميم',
                                        style: AppTextStyles.caption.copyWith(color: AppColors.galleryCream, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),

                      // === 5. المنتجات المميزة + طلب تصميم خاص (Split View) ===
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 60% - منتجات مميزة
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.featuredProducts,
                                    style: AppTextStyles.sectionTitle,
                                  ),
                                  const SizedBox(height: AppDimensions.spacingM),
                                  ...state.featuredProducts.map((product) {
                                    return GestureDetector(
                                      onTap: () => context.go('/product/${product['id']}'),
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                                        padding: const EdgeInsets.all(AppDimensions.paddingS),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                          border: Border.all(color: AppColors.cardBorder),
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                                              child: Image.asset(
                                                product['images'][0],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: AppDimensions.spacingS),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product['name'],
                                                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.nightBrown),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '${product['price']} ${AppStrings.currency}',
                                                    style: AppTextStyles.priceSmall.copyWith(color: AppColors.gold, fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingM),
                            // 40% - كرت طلب تصميم خاص
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.galleryCream,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                  border: Border.all(color: AppColors.cardBorder),
                                ),
                                padding: const EdgeInsets.all(AppDimensions.paddingM),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Iconsax.ruler,
                                      color: AppColors.gold,
                                      size: 32,
                                    ),
                                    const SizedBox(height: AppDimensions.spacingS),
                                    Text(
                                      AppStrings.requestCustomDesign,
                                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppStrings.customDesignSubtitle,
                                      style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.woodBrown),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppDimensions.spacingL),
                                    HaButton.primary(
                                      text: AppStrings.startDesigning,
                                      height: AppDimensions.buttonHeightSmall,
                                      onPressed: () => context.go(AppRoutes.customDesign),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),

                      // === 6. آخر طلب (My Orders Preview) ===
                      if (state.lastOrder != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                          child: Text(
                            AppStrings.myOrders,
                            style: AppTextStyles.sectionTitle,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                          child: HaCard(
                            padding: const EdgeInsets.all(AppDimensions.paddingL),
                            onTap: () => context.go('/order/${state.lastOrder!['id']}'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppStrings.orderNumber}: ${state.lastOrder!['id']}',
                                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.nightBrown),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${AppStrings.orderDate}: ${state.lastOrder!['date']}',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                  ),
                                  child: Text(
                                    state.lastOrder!['statusText'],
                                    style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXL),
                      ],

                      // === 7. خدمات ما بعد البيع (After Sales Section) ===
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                        child: Text(
                          AppStrings.afterSalesTitle,
                          style: AppTextStyles.sectionTitle,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingM),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildAfterSalesItem(Iconsax.award, AppStrings.warranty),
                            _buildAfterSalesItem(Iconsax.setting, AppStrings.maintenance),
                            _buildAfterSalesItem(Iconsax.rotate_left, AppStrings.returns),
                            _buildAfterSalesItem(Iconsax.ruler, AppStrings.installation),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXXL),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAfterSalesItem(IconData icon, String text) {
    return InkWell(
      onTap: () => context.go(AppRoutes.support),
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.galleryCream,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Icon(
              icon,
              color: AppColors.gold,
              size: AppDimensions.iconM,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.nightBrown),
          ),
        ],
      ),
    );
  }
}
