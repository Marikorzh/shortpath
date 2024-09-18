import 'package:equatable/equatable.dart';

import '../model.dart';

abstract class ApiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApiLoading extends ApiState {}

class ApiLoaded extends ApiState {
  final List<Data> data;

  ApiLoaded({required this.data});

  @override
  List<Object?> get props => [data];  // Тут додаємо поле для порівняння
}

class ApiError extends ApiState {
  final String message;

  ApiError({required this.message});

  @override
  List<Object?> get props => [message];  // Тут також
}

class ApiInitial extends ApiState {}

