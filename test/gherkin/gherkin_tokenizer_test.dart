library quark.test.gherkin_tokenizer;

import 'package:test/test.dart';
import 'package:quark/src/gherkin/gherkin.dart';
import 'package:quark/src/gherkin/tokens.dart';

main() {

  void expectTokens(String source, List expected) {
    final tokenizer = new Tokenizer(source);
    expect(tokenizer.tokenize().map((t) => t.type), expected..add(TokenType.eof));
  }

  void expectToken(String source, TokenType type) {
    expectTokens(source, [type]);
  }

  test('all_tokens', () {
    expectToken('Feature', TokenType.featureKeyword);
    expectToken('Scenario', TokenType.scenarioKeyword);
    expectToken('Given', TokenType.givenKeyword);
    expectToken('When', TokenType.whenKeyword);
    expectToken('Then', TokenType.thenKeyword);
    expectToken('And', TokenType.andKeyword);
    expectToken('But', TokenType.butKeyword);

    expectToken('#c', TokenType.comment);

    expectToken(':', TokenType.colon);

    expectToken('3', TokenType.number);
    expectToken('.2', TokenType.number);

    expectToken('"abc"', TokenType.string);
    expectToken("'abc'", TokenType.string);

    expectToken('abc', TokenType.word);
    expectToken('Abc', TokenType.word);
    expectToken('abc123', TokenType.word);
    expectToken('_abc', TokenType.word);
    expectToken('_.ab.c', TokenType.word);
    expectToken('Åäö', TokenType.word);
    expectToken("It's", TokenType.word);
  });
}
