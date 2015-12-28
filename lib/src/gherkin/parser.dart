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

  Sentence readToEol() {
    return new Sentence(new List.unmodifiable(_readToEol()));
  }

  Iterable<Token> _readToEol() sync* {
    while (!next.isEndOfLine) {
      yield move();
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

class Sentence {
  final List<Token> tokens;
  final String _raw;

  const Sentence(this.tokens) : _raw = null;

  const Sentence.raw(this._raw) : tokens = null;

  String get pattern {
    if (_raw != null) return _raw
        .replaceAllMapped(new RegExp('[^\w\s]'), ($) => r'\' + $[0]);
    return tokens.map(_patternize).join(' ');
  }

  String get asSymbol {
    final String normal = _raw ?? tokens
        .where((t) => t.isWord)
        .map((t) => t.content).join(' ');
    return normal.toLowerCase()
        .replaceAll(new RegExp(r'[^\w_$\s]'), '')
        .replaceAllMapped(new RegExp(' (.)'), (m) => m[1].toUpperCase());
  }

  String get argumentList {
    final p = new Parser(tokens.toList()..add(const Token(TokenType.eof, null, null)));
    return () sync* {
      while(!p.next.isEndOfFile) {
        if (p.next.isA(TokenType.string))
          yield 'String ${p.current.content}';
        p.move();
      }
    }().join(', ');
  }

  String _patternize(Token token) {
    if (token.isWord) return token.content;
    if (token.isA(TokenType.string)) return r'\"(.*)\"';
    return r'\' + token.content.split('').join(r'\');
  }

  String toString() => _raw ?? tokens.map((t) => t.content).join(' ');

  bool operator ==(other) {
    return other is Sentence
        && other.toString() == toString();
  }
}
