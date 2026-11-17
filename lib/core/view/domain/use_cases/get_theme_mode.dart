import 'package:flutter/material.dart';
import 'package:ticboom/core/view/domain/repositories/theme_repository.dart';

class GetThemeModeUseCase {
  const GetThemeModeUseCase(this._repository);

  final ThemeRepository _repository;

  Future<ThemeMode> call() {
    return _repository.getThemeMode();
  }
}
