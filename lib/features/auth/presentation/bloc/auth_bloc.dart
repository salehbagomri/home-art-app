import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 1000));
      if (event.username.isNotEmpty && event.password.length >= 6) {
        emit(const AuthAuthenticated('سارة محمد'));
      } else {
        emit(const AuthError('يرجى إدخال اسم مستخدم وكلمة مرور صحيحة (6 خانات على الأقل)'));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 1000));
      if (event.name.isNotEmpty && event.email.isNotEmpty && event.password.length >= 6) {
        emit(const AuthAuthenticated('سارة محمد'));
      } else {
        emit(const AuthError('يرجى ملء جميع الحقول بشكل صحيح'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      emit(AuthUnauthenticated());
    });
  }
}
