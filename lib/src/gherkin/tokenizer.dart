part of quark.src.gherkin;

class Tokenizer {
  final String source;
  int _offset = 0;

  Tokenizer(this.source);

  List<Tuple2<String, TokenType>> get _tokens => [
    const Tuple2(r'^\n', TokenType.lineBreak),
    const Tuple2(r'^[ \t]+', TokenType.whitespace),
    const Tuple2(r'^\bfeature\b', TokenType.featureKeyword),
    const Tuple2(r'^\:', TokenType.colon),
    const Tuple2(r'^[^\s]+', TokenType.colon),
  ];

  List<Token> tokenize() {
    return new List<Token>.unmodifiable(_tokenize());
  }

  Iterable<Token> _tokenize() sync* {
    while (_offset < source.length) {
      yield _nextToken();
    }
  }

  Token _nextToken() {
    for (final tuple in _tokens) {
      final pattern = new RegExp(tuple.item1, caseSensitive: false);
      if (pattern.hasMatch(_source)) {
        final match = pattern.firstMatch(_source);
        final token = new Token(tuple.item2, _offset, match);
        _offset = token.end;
        return token;
      }
    }
    throw new Exception('Unexpected token "${_source.split(' ').first}" at $_location');
  }

  String get _source {
    return source.substring(_offset);
  }

  String get _location {
    final lines = source
        .substring(0, _offset)
        .split('\n');

    final line = lines.length;
    final col = lines.last.length;

    return '$line:$col';
  }
}
