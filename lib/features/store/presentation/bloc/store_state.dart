import 'package:equatable/equatable.dart';

abstract class StoreState extends Equatable {
  const StoreState();
  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {}
class StoreLoading extends StoreState {}
class StoreLoaded extends StoreState {
  final List<Map<String, dynamic>> products;
  final String activeSort;
  final List<String> activeFilters;

  const StoreLoaded({
    required this.products,
    required this.activeSort,
    required this.activeFilters,
  });

  @override
  List<Object?> get props => [products, activeSort, activeFilters];
}
class StoreError extends StoreState {
  final String message;
  const StoreError(this.message);
  @override
  List<Object?> get props => [message];
}
