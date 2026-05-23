import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_products.dart';
import '../../../../data/mock/mock_categories.dart';
import '../../../../data/mock/mock_inspirations.dart';
import '../../../../data/mock/mock_orders.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final banners = [
        {
          'title': 'نصمم مساحات\nتحكي ذوقك',
          'subtitle': 'أثاث راقٍ، جودة تدوم، وأناقة لكل زاوية',
          'image': 'App_Assets/12.jpeg',
        },
        {
          'title': 'مجموعة غرف النوم الجديدة',
          'subtitle': 'أحدث تصاميم غرف النوم الفاخرة لعام 2026',
          'image': 'App_Assets/7.jpeg',
        },
        {
          'title': 'تخفيضات موسم الصيف',
          'subtitle': 'خصومات تصل إلى 30% على تشكيلة المجالس',
          'image': 'App_Assets/1.jpeg',
        },
      ];

      final categories = MockCategories.categories;
      final featuredProducts = MockProducts.products.take(3).toList();
      final inspirations = MockInspirations.inspirations.take(4).toList();
      final lastOrder = MockOrders.orders.isNotEmpty ? MockOrders.orders.first : null;

      emit(HomeLoaded(
        banners: banners,
        categories: categories,
        featuredProducts: featuredProducts,
        inspirations: inspirations,
        lastOrder: lastOrder,
      ));
    } catch (e) {
      emit(const HomeError('حدث خطأ في تحميل البيانات'));
    }
  }
}
