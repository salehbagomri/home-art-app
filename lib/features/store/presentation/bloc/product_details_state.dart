import 'package:equatable/equatable.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();
  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}
class ProductDetailsLoading extends ProductDetailsState {}
class ProductDetailsLoaded extends ProductDetailsState {
  final Map<String, dynamic> product;
  final String selectedColor;
  final String selectedSize;
  final String selectedMaterial;

  const ProductDetailsLoaded({
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
    required this.selectedMaterial,
  });

  @override
  List<Object?> get props => [product, selectedColor, selectedSize, selectedMaterial];
}
class ProductDetailsError extends ProductDetailsState {
  final String message;
  const ProductDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}
