library quark.test.integration;

import 'package:test/test.dart';
import 'package:quark/integration.dart';
import 'package:quark/src/gherkin/gherkin.dart';
import 'mock_runner.dart';
import 'dart:async';

@Feature('''
  Feature: empty
''')
class EmptyIntegrationTest extends IntegrationTest {
  void verify(MockRunner runner) {
    expect(runner.history, isEmpty);
    expect(feature, const Gherkin(
        feature: 'empty'
    ));
  }
}

@Feature('''
  Feature: single

    Scenario: single
      Given x
      When y
      Then z
''')
class SingleScenarioIntegrationTest extends IntegrationTest {
  bool xRan = false;
  bool yRan = false;
  bool zRan = false;

  @Given('x')
  x() {
    xRan = true;
  }

  @When('y')
  y() {
    yRan = true;
  }

  @Then('z')
  z() {
    zRan = true;
  }

  void verify(MockRunner runner) {
    expect(runner.history, [
      'single:>single'
    ]);
    expect(xRan, isTrue);
    expect(yRan, isTrue);
    expect(zRan, isTrue);
    expect(feature, const Gherkin(
        feature: 'single',
        scenarios: const [
          const Scenario(
              description: const Sentence.raw('single'),
              steps: const [
                const GivenStep(const Sentence.raw('x')),
                const WhenStep(const Sentence.raw('y')),
                const ThenStep(const Sentence.raw('z')),
              ]
          )
        ]
    ));
  }
}

abstract class ContextMixin {
  bool externalRun = false;

  @Given('external step')
  externalStep() {
    externalRun = true;
  }
}

@Feature('''
Feature: mix

  Scenario: mix
    Given external step
''')
class MixedInIntegrationTest extends IntegrationTest with ContextMixin {
  void verify(MockRunner runner) {
    expect(runner.history, [
      'mix:>mix'
    ]);
    expect(externalRun, isTrue);
  }
}

@Feature('''
Feature: string
  Scenario: string
    Given string "string"
''')
class StringIntegrationTest extends IntegrationTest {
  String passedIn;

  @Given('string \"(.*)\"')
  string(String string) {
    passedIn = string;
  }

  void verify(_) {
    expect(passedIn, 'string');
  }
}

main() {
  MockRunner runner;

  setUp(() {
    runner = new MockRunner();
  });

  Future run(IntegrationTest test) async {
    test.register(runner);
    await runner.run();
  }

  test('empty_test', () async {
    final t = new EmptyIntegrationTest();
    await run(t);
    t.verify(runner);
  });

  test('single_scenario_test', () async {
    final t = new SingleScenarioIntegrationTest();
    await run(t);
    t.verify(runner);
  });

  test('mixed_in_test', () async {
    final t = new MixedInIntegrationTest();
    await run(t);
    t.verify(runner);
  });

  test('string_test', () async {
    final t = new StringIntegrationTest();
    await run(t);
    t.verify(runner);
  });
}
