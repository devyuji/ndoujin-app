import 'package:riverpod_annotation/riverpod_annotation.dart';

part "ui.g.dart";

@riverpod
class IsAdding extends _$IsAdding {
  @override
  bool build() => false;

  void update(bool value) {
    state = value;
  }
}
