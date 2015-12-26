library quark.src.gherkin.tokens;

enum TokenType {
  whitespace,
  lineBreak,
  colon,

  string,
  number,

  featureKeyword,
  scenarioKeyword,
  givenKeyword,
  whenKeyword,
  thenKeyword,

  word,
}

class Token {
  final TokenType type;
  final Match match;
  final int offset;

  const Token(this.type, this.offset, this.match);

  int get start => offset;
  int get end => offset + match[0].length;
}
