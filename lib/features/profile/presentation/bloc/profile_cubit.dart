import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock/mock_user.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void loadUserProfile() async {
    emit(ProfileLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(ProfileLoaded(MockUser.user));
    } catch (e) {
      emit(const ProfileError('حدث خطأ أثناء تحميل ملف التعريف'));
    }
  }
}
