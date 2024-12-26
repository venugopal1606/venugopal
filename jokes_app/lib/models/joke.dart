class Joke {
  final int id;
  final String type;
  final String category;
  final String setup;
  final String delivery;
  final String joke;
  final bool safe;
  final String lang;
  final Map<String, bool> flags;

  Joke({
    required this.id,
    required this.type,
    required this.category,
    this.setup = '',
    this.delivery = '',
    this.joke = '',
    required this.safe,
    required this.lang,
    required this.flags,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      type: json['type'],
      category: json['category'],
      setup: json['setup'] ?? '',
      delivery: json['delivery'] ?? '',
      joke: json['joke'] ?? '',
      safe: json['safe'],
      lang: json['lang'],
      flags: Map<String, bool>.from(json['flags'] ?? {}),
    );
  }

  String get content {
    if (type == 'single') {
      return joke;
    } else {
      return '$setup\n\n$delivery';
    }
  }

  String get preview {
    if (type == 'single') {
      return joke.length > 100 ? '${joke.substring(0, 100)}...' : joke;
    } else {
      return setup.length > 100 ? '${setup.substring(0, 100)}...' : setup;
    }
  }

  List<String> get activeFlags {
    return flags.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
