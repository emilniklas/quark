part of quark.src.gherkin;

class Parser {
  final List<Token> source;
  int _pointer = -1;

  Parser._(this.source);

  factory Parser(Iterable<Token> source) {
    return new Parser._(new List.unmodifiable(
        source.where((t) => t.isntAnyOf([
          TokenType.whitespace,
          TokenType.comment,
        ]))
    ));
  }

  Token get current {
    try {
      return source[_pointer];
    } catch (e) {
      return null;
    }
  }

  Token get next {
    return source[_pointer + 1];
  }

  Token move() {
    _pointer++;
    return current;
  }

  Gherkin parse() {
    return new Gherkin.parse(this);
  }

  Parser _expect(bool condition, String reason) {
    if (!condition)
      throw new ParserException(next, reason);
    return this;
  }

  Parser expectAnyOf(Iterable<TokenType> types, [String reason]) {
    return _expect(next.isAnyOf(types), reason ?? 'expected any of $types');
  }

  Parser expect(TokenType type, [String reason]) {
    return expectAnyOf([type], reason);
  }

  Parser expectWord([String reason]) {
    return _expect(next.isWord, reason ?? 'expected word');
  }

  String readToEol() {
    return _readToEol().join(' ');
  }

  Iterable<String> _readToEol() sync* {
    while (next.isntAnyOf([TokenType.eof, TokenType.eol])) {
      final token = expectWord().move();

      yield token.content;
    }
    if (next.isA(TokenType.eol)) move();
  }

  void movePastBlankLines() {
    while (next.isA(TokenType.eol)) move();
  }
}

class ParserException implements Exception {
  final String message;
  final Token token;

  ParserException(this.token, this.message);

  String toString() => 'ParserException: Unexpected token $token, $message';
}
