import 'package:dio/dio.dart';
import '../models/joke.dart';
import '../models/joke_filters.dart';
import 'api/base_api_client.dart';

class JokeService {
  static final JokeService _instance = JokeService._internal();
  factory JokeService() => _instance;
  JokeService._internal() {
    _apiClient.initialize();
  }

  final _apiClient = BaseApiClient();
  CancelToken? _cancelToken;

  Future<List<Joke>> getJokes({
    int amount = 10,
    Set<JokeCategory> categories = const {
      JokeCategory.programming,
      JokeCategory.misc
    },
    bool safe = true,
    Set<JokeFlag> blacklistFlags = const {},
    JokeType type = JokeType.both,
    required ApiClient client,
  }) async {
    _cancelToken?.cancel('Cancelled by user');
    _cancelToken = CancelToken();

    try {
      final response = await _apiClient.get(
        endpoint: '/joke/${categories.map((c) => c.apiValue).join(",")}',
        queryParameters: {
          'amount': amount,
          'safe': safe,
          'type': type.apiValue,
          if (blacklistFlags.isNotEmpty)
            'blacklistFlags': blacklistFlags.map((f) => f.apiValue).join(','),
        },
        client: client,
        cancelToken: _cancelToken,
      );

      final List<Joke> jokes = [];
      final List<dynamic> results = response['jokes'];

      for (var jokeData in results) {
        jokes.add(Joke.fromJson(jokeData));
      }

      return jokes;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw Exception('Request cancelled');
      }
      rethrow;
    }
  }

  void cancelRequest() {
    _cancelToken?.cancel('Cancelled by user');
    _cancelToken = null;
  }

  void dispose() {
    _apiClient.dispose();
  }
}
