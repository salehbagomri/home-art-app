import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_orders.dart';
import 'order_tracking_state.dart';

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  OrderTrackingCubit() : super(OrderTrackingInitial());

  void loadOrderTracking(String orderId) async {
    emit(OrderTrackingLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final order = MockOrders.orders.firstWhere(
        (o) => o['id'] == orderId,
        orElse: () => throw Exception('الطلب غير موجود'),
      );
      emit(OrderTrackingLoaded(order));
    } catch (e) {
      emit(const OrderTrackingError('حدث خطأ أثناء تحميل تتبع الطلب'));
    }
  }
}
