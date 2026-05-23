import 'package:equatable/equatable.dart';

class CheckoutState extends Equatable {
  final int currentStep;
  final String paymentMethod;
  final String discountCode;
  final double discountAmount;
  final double productsValue;
  final double deliveryFee;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  const CheckoutState({
    this.currentStep = 1,
    this.paymentMethod = 'mada',
    this.discountCode = '',
    this.discountAmount = 0.0,
    this.productsValue = 6850.0,
    this.deliveryFee = 150.0,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  double get vat => (productsValue - discountAmount + deliveryFee) * 0.15;
  double get totalAmount => (productsValue - discountAmount + deliveryFee) + vat;

  CheckoutState copyWith({
    int? currentStep,
    String? paymentMethod,
    String? discountCode,
    double? discountAmount,
    double? productsValue,
    double? deliveryFee,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CheckoutState(
      currentStep: currentStep ?? this.currentStep,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      discountCode: discountCode ?? this.discountCode,
      discountAmount: discountAmount ?? this.discountAmount,
      productsValue: productsValue ?? this.productsValue,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        paymentMethod,
        discountCode,
        discountAmount,
        productsValue,
        deliveryFee,
        isSubmitting,
        isSuccess,
        errorMessage,
      ];
}
