library quark.test.gherkin_parser;

import 'package:test/test.dart';
import 'package:quark/src/gherkin/gherkin.dart';

main() {
  test('empty_feature', () {
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
  });

  test('empty_scenario', () {
    expect(
        parse('Feature\nScenario:'),
        const Gherkin(scenarios: const [
          const Scenario(),
        ])
    );
  });

  test('multiple_empty_scenarios', () {
    expect(
        parse('Feature\nScenario\nScenario'),
        const Gherkin(scenarios: const [
          const Scenario(),
          const Scenario(),
        ])
    );
  });

  test('simple_scenario', () {
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
            const GivenStep(const Sentence.raw('x')),
            const WhenStep(const Sentence.raw('y')),
            const ThenStep(const Sentence.raw('z')),
          ]),
        ])
    );
  });

  test('and and but', () {
    expect(
        parse('''
        Feature
          Scenario
            Given xa
            And xb
            But xc
            When ya
            And yb
            But yc
            Then z
        '''),
        const Gherkin(scenarios: const [
          const Scenario(steps: const [
            const GivenStep(const Sentence.raw('xa')),
            const GivenStep(const Sentence.raw('xb')),
            const GivenStep(const Sentence.raw('xc')),
            const WhenStep(const Sentence.raw('ya')),
            const WhenStep(const Sentence.raw('yb')),
            const WhenStep(const Sentence.raw('yc')),
            const ThenStep(const Sentence.raw('z')),
          ]),
        ])
    );
  });
}
