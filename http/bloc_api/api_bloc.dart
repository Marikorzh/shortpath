import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../model.dart';
import 'api_event_bloc.dart';
import 'api_state_bloc.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {

  ApiBloc() : super(ApiInitial()) {
    on<FetchApiData>((event, emit) async {
      emit(ApiLoading());
      try {
        final response = await fetchData(event.url); // Передаємо URL в fetchData
        emit(ApiLoaded(data: response.data));
      } catch (e) {
        emit(ApiError(message: 'Failed to fetch data: $e'));
      }
    });
  }

  // Використовуємо URL, який передано
  Future<ApiResponse> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
