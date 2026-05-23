import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_design_event.dart';
import 'custom_design_state.dart';

class CustomDesignBloc extends Bloc<CustomDesignEvent, CustomDesignState> {
  CustomDesignBloc() : super(const CustomDesignState()) {
    on<NextStepRequested>((event, emit) {
      if (state.currentStep < 6) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<PreviousStepRequested>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<SpaceTypeSelected>((event, emit) {
      emit(state.copyWith(spaceType: event.spaceType));
    });

    on<DimensionUpdated>((event, emit) {
      emit(state.copyWith(
        width: event.width ?? state.width,
        length: event.length ?? state.length,
        height: event.height ?? state.height,
        dimensionUnit: event.unit ?? state.dimensionUnit,
      ));
    });

    on<PreferredStyleSelected>((event, emit) {
      emit(state.copyWith(preferredStyle: event.style));
    });

    on<MaterialToggled>((event, emit) {
      final list = List<String>.from(state.preferredMaterials);
      if (list.contains(event.material)) {
        list.remove(event.material);
      } else {
        list.add(event.material);
      }
      emit(state.copyWith(preferredMaterials: list));
    });

    on<ColorToggled>((event, emit) {
      final list = List<String>.from(state.preferredColors);
      if (list.contains(event.colorHex)) {
        list.remove(event.colorHex);
      } else {
        list.add(event.colorHex);
      }
      emit(state.copyWith(preferredColors: list));
    });

    on<NotesChanged>((event, emit) {
      emit(state.copyWith(notes: event.notes));
    });

    on<SubmitDesignRequest>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));
      await Future.delayed(const Duration(milliseconds: 1500));
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        currentStep: 6,
      ));
    });
  }
}
