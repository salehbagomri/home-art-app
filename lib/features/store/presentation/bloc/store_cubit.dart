import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_products.dart';
import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  List<Map<String, dynamic>> _allProducts = [];
  String _currentSort = 'الأحدث';
  final List<String> _currentFilters = [];

  StoreCubit() : super(StoreInitial());

  void loadStoreData() async {
    emit(StoreLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _allProducts = List<Map<String, dynamic>>.from(MockProducts.products);
      _applyFilterAndSort();
    } catch (e) {
      emit(const StoreError('حدث خطأ أثناء تحميل منتجات المتجر'));
    }
  }

  void changeSort(String sortOption) {
    _currentSort = sortOption;
    _applyFilterAndSort();
  }

  void toggleFilter(String filter) {
    if (_currentFilters.contains(filter)) {
      _currentFilters.remove(filter);
    } else {
      _currentFilters.add(filter);
    }
    _applyFilterAndSort();
  }

  void clearAllFilters() {
    _currentFilters.clear();
    _applyFilterAndSort();
  }

  void toggleFavorite(String productId) {
    final index = _allProducts.indexWhere((p) => p['id'] == productId);
    if (index != -1) {
      final p = _allProducts[index];
      _allProducts[index] = {
        ...p,
        'isFavorite': !(p['isFavorite'] ?? false),
      };
      _applyFilterAndSort();
    }
  }

  void _applyFilterAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_allProducts);

    if (_currentFilters.isNotEmpty) {
      filtered = filtered.where((p) {
        bool matches = true;
        for (var f in _currentFilters) {
          if (f == 'جديد') {
            if (p['isNew'] != true) matches = false;
          } else if (f == 'مفضلة') {
            if (p['isFavorite'] != true) matches = false;
          } else {
            if (p['category'] != f) matches = false;
          }
        }
        return matches;
      }).toList();
    }

    if (_currentSort == 'السعر') {
      filtered.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
    } else if (_currentSort == 'الأكثر مبيعاً') {
      filtered.sort((a, b) => (b['reviewsCount'] as int).compareTo(a['reviewsCount'] as int));
    } else {
      filtered.sort((a, b) {
        final aNew = a['isNew'] == true ? 1 : 0;
        final bNew = b['isNew'] == true ? 1 : 0;
        return bNew.compareTo(aNew);
      });
    }

    emit(StoreLoaded(
      products: filtered,
      activeSort: _currentSort,
      activeFilters: List.from(_currentFilters),
    ));
  }
}
