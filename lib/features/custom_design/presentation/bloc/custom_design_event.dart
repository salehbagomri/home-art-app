import 'package:equatable/equatable.dart';

abstract class CustomDesignEvent extends Equatable {
  const CustomDesignEvent();
  @override
  List<Object?> get props => [];
}

class NextStepRequested extends CustomDesignEvent {}
class PreviousStepRequested extends CustomDesignEvent {}
class SpaceTypeSelected extends CustomDesignEvent {
  final String spaceType;
  const SpaceTypeSelected(this.spaceType);
  @override
  List<Object?> get props => [spaceType];
}
class DimensionUpdated extends CustomDesignEvent {
  final double? width;
  final double? length;
  final double? height;
  final String? unit;
  const DimensionUpdated({this.width, this.length, this.height, this.unit});
  @override
  List<Object?> get props => [width, length, height, unit];
}
class PreferredStyleSelected extends CustomDesignEvent {
  final String style;
  const PreferredStyleSelected(this.style);
  @override
  List<Object?> get props => [style];
}
class MaterialToggled extends CustomDesignEvent {
  final String material;
  const MaterialToggled(this.material);
  @override
  List<Object?> get props => [material];
}
class ColorToggled extends CustomDesignEvent {
  final String colorHex;
  const ColorToggled(this.colorHex);
  @override
  List<Object?> get props => [colorHex];
}
class NotesChanged extends CustomDesignEvent {
  final String notes;
  const NotesChanged(this.notes);
  @override
  List<Object?> get props => [notes];
}
class SubmitDesignRequest extends CustomDesignEvent {}
