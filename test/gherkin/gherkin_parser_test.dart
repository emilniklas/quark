library quark.test.gherkin_parser;

import 'package:testcase/testcase.dart';
import 'package:quark/src/gherkin/gherkin.dart';
export 'package:testcase/init.dart';

class GherkinParserTest extends TestCase {
  setUp() {}

  tearDown() {}

  //@test
  empty_feature() {
    expect(
        parse(''),
        const Gherkin()
    );
    expect(
        parse('Feature: x'),
        const Gherkin(feature: 'x')
    );
    expect(
        parse('''
          Feature: x
            description
        '''),
        const Gherkin(feature: 'x', description: 'description')
    );
  }
}
