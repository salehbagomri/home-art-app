import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> banners;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> featuredProducts;
  final List<Map<String, dynamic>> inspirations;
  final Map<String, dynamic>? lastOrder;

  const HomeLoaded({
    required this.banners,
    required this.categories,
    required this.featuredProducts,
    required this.inspirations,
    this.lastOrder,
  });

  @override
  List<Object?> get props => [banners, categories, featuredProducts, inspirations, lastOrder];
}
class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
