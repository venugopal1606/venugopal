enum JokeCategory {
  programming,
  misc,
  dark,
  pun,
  spooky,
  christmas;

  String get displayName => name.toUpperCase();

  String get apiValue => name;

  static Set<JokeCategory> get defaultSelection => {
        JokeCategory.programming,
        JokeCategory.misc,
      };
}

enum JokeType {
  both('both'),
  single('single'),
  twopart('twopart');

  final String apiValue;
  const JokeType(this.apiValue);

  String get displayName {
    switch (this) {
      case JokeType.both:
        return 'Both';
      case JokeType.single:
        return 'Single';
      case JokeType.twopart:
        return 'Two Part';
    }
  }
}

enum JokeFlag {
  nsfw,
  religious,
  political,
  racist,
  sexist,
  explicit;

  String get displayName => name.toUpperCase();

  String get apiValue => name;

  static Set<JokeFlag> get defaultBlacklist => Set.from(JokeFlag.values);
}
