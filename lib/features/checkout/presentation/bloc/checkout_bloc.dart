import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const CheckoutState()) {
    on<SetPaymentMethod>((event, emit) {
      emit(state.copyWith(paymentMethod: event.paymentMethod));
    });

    on<ApplyDiscountCode>((event, emit) {
      if (event.code.toUpperCase() == 'HA15') {
        emit(state.copyWith(
          discountCode: event.code,
          discountAmount: state.productsValue * 0.15,
        ));
      } else {
        emit(state.copyWith(errorMessage: 'كود الخصم غير صحيح'));
      }
    });

    on<SubmitPayment>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));
      await Future.delayed(const Duration(milliseconds: 1500));
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        currentStep: 3,
      ));
    });
  }
}
