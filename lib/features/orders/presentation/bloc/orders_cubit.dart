import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_orders.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  void loadAllOrders() async {
    emit(OrdersLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(OrdersLoaded(MockOrders.orders));
    } catch (e) {
      emit(const OrdersError('حدث خطأ أثناء تحميل الطلبات'));
    }
  }
}
