import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_products.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  void loadProductDetails(String id) async {
    emit(ProductDetailsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final product = MockProducts.products.firstWhere(
        (p) => p['id'] == id,
        orElse: () => throw Exception('المنتج غير موجود'),
      );

      emit(ProductDetailsLoaded(
        product: product,
        selectedColor: (product['colors'] as List).isNotEmpty ? product['colors'][0] : '',
        selectedSize: (product['sizes'] as List).isNotEmpty ? product['sizes'][0] : '',
        selectedMaterial: product['material'] ?? '',
      ));
    } catch (e) {
      emit(const ProductDetailsError('حدث خطأ أثناء تحميل تفاصيل المنتج'));
    }
  }

  void selectColor(String colorHex) {
    if (state is ProductDetailsLoaded) {
      final s = state as ProductDetailsLoaded;
      emit(ProductDetailsLoaded(
        product: s.product,
        selectedColor: colorHex,
        selectedSize: s.selectedSize,
        selectedMaterial: s.selectedMaterial,
      ));
    }
  }

  void selectSize(String size) {
    if (state is ProductDetailsLoaded) {
      final s = state as ProductDetailsLoaded;
      emit(ProductDetailsLoaded(
        product: s.product,
        selectedColor: s.selectedColor,
        selectedSize: size,
        selectedMaterial: s.selectedMaterial,
      ));
    }
  }

  void selectMaterial(String material) {
    if (state is ProductDetailsLoaded) {
      final s = state as ProductDetailsLoaded;
      emit(ProductDetailsLoaded(
        product: s.product,
        selectedColor: s.selectedColor,
        selectedSize: s.selectedSize,
        selectedMaterial: material,
      ));
    }
  }
}
