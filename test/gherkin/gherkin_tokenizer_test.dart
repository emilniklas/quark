library quark.test.gherkin_tokenizer;

import 'package:testcase/testcase.dart';
import 'package:quark/src/gherkin/gherkin.dart';
import 'package:quark/src/gherkin/tokens.dart';
export 'package:testcase/init.dart';

class GherkinTokenizerTest extends TestCase {
  setUp() {}

  tearDown() {}

  void expectTokens(String source, List expected) {
    final tokenizer = new Tokenizer(source);
    expect(tokenizer.tokenize().map((t) => t.type), expected);
  }

  void expectToken(String source, TokenType type) {
    expectTokens(source, [type]);
  }

  @test
  all_tokens() {
    expectToken('Feature', TokenType.featureKeyword);
    expectToken(':', TokenType.colon);
  }
}
