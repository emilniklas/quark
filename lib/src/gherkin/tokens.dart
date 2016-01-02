library quark.src.gherkin.tokens;

enum TokenType {
  eof,
  eol,
  whitespace,
  colon,
  comment,

  string,
  number,

  featureKeyword,
  scenarioKeyword,
  givenKeyword,
  whenKeyword,
  thenKeyword,
  andKeyword,
  butKeyword,

  word,
}

class Token {
  final TokenType type;
  final Match match;
  final int offset;

  const Token(this.type, this.offset, this.match);

  int get start => offset;
  int get end => offset + content.length;

  String get content => match?.group(0) ?? '';

  bool isAnyOf(Iterable<TokenType> types) {
    for (final type in types) {
      if (this.type == type) return true;
    }
    return false;
  }

  bool isntAnyOf(Iterable<TokenType> types) {
    return !isAnyOf(types);
  }

  bool isA(TokenType type) {
    return this.type == type;
  }

  bool isntA(TokenType type) {
    return this.type != type;
  }

  String toString() {
    return '${
        '$type'.substring(10)
    }[$offset]${
        content == '' ? '' : '<${content.replaceAll('\n', r'\n')}>'
    }';
  }

  bool get isEndOfFile => isA(TokenType.eof);

  bool get isStepKeyword => isActualStepKeyword || isAnyOf([
    TokenType.andKeyword,
    TokenType.butKeyword,
  ]);

  bool get isActualStepKeyword => isAnyOf([
    TokenType.givenKeyword,
    TokenType.whenKeyword,
    TokenType.thenKeyword,
  ]);

  bool get isKeyword => isStepKeyword || isAnyOf([
    TokenType.scenarioKeyword,
    TokenType.featureKeyword,
  ]);

  bool get isEndOfLine => isEndOfFile || isA(TokenType.eol);

  bool get isWord => isKeyword || isA(TokenType.word);
}
