import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_tickets.dart';
import 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit() : super(SupportInitial());

  void loadSupportTickets() async {
    emit(SupportLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(SupportLoaded(MockTickets.tickets));
    } catch (e) {
      emit(const SupportError('حدث خطأ أثناء تحميل تذاكر الدعم'));
    }
  }
}
