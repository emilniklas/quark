library quark.test.integration;

import 'package:testcase/testcase.dart';
import 'package:quark/integration.dart';
import 'mock_runner.dart';

export 'package:testcase/init.dart';

@Feature('''
  Feature: empty

  Scenario: empty
''')
class EmptyIntegrationTest extends IntegrationTest {
  void verify(MockRunner runner) {
    expect(runner.history, isEmpty);
  }
}

class UnitTestTest extends TestCase {
  MockRunner runner;

  setUp() {
    runner = new MockRunner();
  }

  tearDown() {}

  @test
  empty_test() {
    new EmptyIntegrationTest()
      ..run(runner)
      ..verify(runner);
  }
}
