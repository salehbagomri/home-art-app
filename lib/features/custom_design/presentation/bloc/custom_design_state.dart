import 'package:equatable/equatable.dart';

class CustomDesignState extends Equatable {
  final int currentStep;
  final String spaceType;
  final double width;
  final double length;
  final double height;
  final String dimensionUnit;
  final List<String> preferredMaterials;
  final List<String> preferredColors;
  final String preferredStyle;
  final String notes;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  const CustomDesignState({
    this.currentStep = 0,
    this.spaceType = '',
    this.width = 0.0,
    this.length = 0.0,
    this.height = 0.0,
    this.dimensionUnit = 'متر',
    this.preferredMaterials = const [],
    this.preferredColors = const [],
    this.preferredStyle = '',
    this.notes = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  CustomDesignState copyWith({
    int? currentStep,
    String? spaceType,
    double? width,
    double? length,
    double? height,
    String? dimensionUnit,
    List<String>? preferredMaterials,
    List<String>? preferredColors,
    String? preferredStyle,
    String? notes,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CustomDesignState(
      currentStep: currentStep ?? this.currentStep,
      spaceType: spaceType ?? this.spaceType,
      width: width ?? this.width,
      length: length ?? this.length,
      height: height ?? this.height,
      dimensionUnit: dimensionUnit ?? this.dimensionUnit,
      preferredMaterials: preferredMaterials ?? this.preferredMaterials,
      preferredColors: preferredColors ?? this.preferredColors,
      preferredStyle: preferredStyle ?? this.preferredStyle,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        spaceType,
        width,
        length,
        height,
        dimensionUnit,
        preferredMaterials,
        preferredColors,
        preferredStyle,
        notes,
        isSubmitting,
        isSuccess,
        errorMessage,
      ];
}
