import 'package:equatable/equatable.dart';
import '../model.dart';

abstract class ApiState extends Equatable {
  @override
  List<Object> get props => [];
}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiLoaded extends ApiState {
  final List<Data> data;

  ApiLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

class ApiError extends ApiState {
  final String message;

  ApiError({required this.message});

  @override
  List<Object> get props => [message];
}
