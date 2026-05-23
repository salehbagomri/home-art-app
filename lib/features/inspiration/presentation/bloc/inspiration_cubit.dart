import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_inspirations.dart';
import 'inspiration_state.dart';

class InspirationCubit extends Cubit<InspirationState> {
  List<Map<String, dynamic>> _allInspirations = [];
  String _activeTab = 'إلهام';
  String _selectedCategory = 'الكل';

  InspirationCubit() : super(InspirationInitial());

  void loadInspirations() async {
    emit(InspirationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _allInspirations = List<Map<String, dynamic>>.from(MockInspirations.inspirations);
      _applyFilter();
    } catch (e) {
      emit(const InspirationError('حدث خطأ أثناء تحميل بيانات الإلهام'));
    }
  }

  void changeTab(String tab) {
    _activeTab = tab;
    _applyFilter();
  }

  void changeCategory(String category) {
    _selectedCategory = category;
    _applyFilter();
  }

  void toggleLike(String id) {
    final index = _allInspirations.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      final item = _allInspirations[index];
      _allInspirations[index] = {
        ...item,
        'isLiked': !(item['isLiked'] ?? false),
      };
      _applyFilter();
    }
  }

  void toggleSave(String id) {
    final index = _allInspirations.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      final item = _allInspirations[index];
      _allInspirations[index] = {
        ...item,
        'isSaved': !(item['isSaved'] ?? false),
      };
      _applyFilter();
    }
  }

  void _applyFilter() {
    List<Map<String, dynamic>> filtered = List.from(_allInspirations);

    if (_selectedCategory != 'الكل') {
      filtered = filtered.where((item) => item['category'] == _selectedCategory).toList();
    }

    emit(InspirationLoaded(
      items: filtered,
      activeTab: _activeTab,
      selectedCategory: _selectedCategory,
    ));
  }
}
