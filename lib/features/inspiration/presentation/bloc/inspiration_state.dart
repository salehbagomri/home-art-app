import 'package:equatable/equatable.dart';

abstract class InspirationState extends Equatable {
  const InspirationState();
  @override
  List<Object?> get props => [];
}

class InspirationInitial extends InspirationState {}
class InspirationLoading extends InspirationState {}
class InspirationLoaded extends InspirationState {
  final List<Map<String, dynamic>> items;
  final String activeTab; // "إلهام" or "كتالوج"
  final String selectedCategory;

  const InspirationLoaded({
    required this.items,
    required this.activeTab,
    required this.selectedCategory,
  });

  @override
  List<Object?> get props => [items, activeTab, selectedCategory];
}
class InspirationError extends InspirationState {
  final String message;
  const InspirationError(this.message);
  @override
  List<Object?> get props => [message];
}
