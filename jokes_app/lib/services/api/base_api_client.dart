import 'dart:developer' as developer;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

enum ApiClient { dio, http }

class BaseApiClient {
  static final BaseApiClient _instance = BaseApiClient._internal();
  factory BaseApiClient() => _instance;
  BaseApiClient._internal();

  late final Dio _dio;
  final _httpClient = http.Client();
  final _baseUrl = 'https://v2.jokeapi.dev';

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        developer.log(
          '🌐 Dio Request: ${options.method} ${options.uri}',
          name: 'API',
        );
        developer.log(
          '📝 Dio Parameters: ${options.queryParameters}',
          name: 'API',
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        developer.log(
          '✅ Dio Response [${response.statusCode}]: ${response.requestOptions.uri}',
          name: 'API',
        );
        return handler.next(response);
      },
      onError: (error, handler) {
        developer.log(
          '❌ Dio Error [${error.response?.statusCode}]: ${error.requestOptions.uri}',
          name: 'API',
          error: error.message,
        );
        return handler.next(error);
      },
    ));
  }

  void dispose() {
    _dio.close();
    _httpClient.close();
  }

  Future<Map<String, dynamic>> get({
    required String endpoint,
    required Map<String, dynamic> queryParameters,
    required ApiClient client,
    CancelToken? cancelToken,
  }) async {
    try {
      if (client == ApiClient.dio) {
        final response = await _dio.get(
          endpoint,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );
        return response.data;
      } else {
        final uri = Uri.parse('$_baseUrl$endpoint').replace(
          queryParameters: queryParameters.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
        );

        developer.log(
          '🌐 HTTP Request: GET $uri',
          name: 'API',
        );

        final response = await _httpClient.get(uri);

        developer.log(
          '✅ HTTP Response [${response.statusCode}]: $uri',
          name: 'API',
        );

        if (response.statusCode == 200) {
          return json.decode(response.body) as Map<String, dynamic>;
        } else {
          throw Exception('Failed to load data');
        }
      }
    } catch (e) {
      developer.log(
        '❌ Error: $e',
        name: 'API',
        error: e,
      );
      rethrow;
    }
  }
}
