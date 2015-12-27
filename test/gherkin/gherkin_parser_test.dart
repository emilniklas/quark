library quark.test.gherkin_parser;

import 'package:testcase/testcase.dart';
import 'package:quark/src/gherkin/gherkin.dart';
export 'package:testcase/init.dart';

class GherkinParserTest extends TestCase {
  setUp() {}

  tearDown() {}

  @test
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
    expect(
        parse('''


          Feature: x



            description

        '''),
        const Gherkin(feature: 'x', description: 'description')
    );
  }

  @test
  empty_scenario() {
    expect(
        parse('Feature\nScenario:'),
        const Gherkin(scenarios: const [
          const Scenario(),
        ])
    );
  }

  @test
  multiple_empty_scenarios() {
    expect(
        parse('Feature\nScenario\nScenario'),
        const Gherkin(scenarios: const [
          const Scenario(),
          const Scenario(),
        ])
    );
  }

  @test
  simple_scenario() {
    expect(
        parse('''
        Feature
          Scenario
            Given x
            When y
            Then z
        '''),
        const Gherkin(scenarios: const [
          const Scenario(steps: const [
            const GivenStep('x'),
            const WhenStep('y'),
            const ThenStep('z'),
          ]),
        ])
    );
  }
}
