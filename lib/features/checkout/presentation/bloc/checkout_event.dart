import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override
  List<Object?> get props => [];
}

class SetPaymentMethod extends CheckoutEvent {
  final String paymentMethod;
  const SetPaymentMethod(this.paymentMethod);
  @override
  List<Object?> get props => [paymentMethod];
}

class ApplyDiscountCode extends CheckoutEvent {
  final String code;
  const ApplyDiscountCode(this.code);
  @override
  List<Object?> get props => [code];
}

class SubmitPayment extends CheckoutEvent {}
