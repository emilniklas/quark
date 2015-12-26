library quark.test.unit;

import 'package:testcase/testcase.dart';
import 'package:quark/unit.dart' hide test;
import 'package:quark/unit.dart' as quark show test;
import 'mock_runner.dart';
import 'package:quark/src/test/runner.dart';

export 'package:testcase/init.dart';

class SingleTestUnitTest extends UnitTest {
  bool testWasRun = false;

  @quark.test
  itWorks() {
    testWasRun = true;
  }

  void verify(MockRunner runner) {
    expect(testWasRun, isTrue);
    expect(runner.history, [
      'SingleTestUnit:>it works'
    ]);
  }
}

class MultiTestUnitTest extends UnitTest {
  bool firstTestWasRun = false;
  bool secondTestWasRun = false;

  @quark.test
  firstTest() {
    firstTestWasRun = true;
  }

  @quark.test
  secondTest() {
    secondTestWasRun = true;
  }

  void verify(MockRunner runner) {
    expect(firstTestWasRun, isTrue);
    expect(secondTestWasRun, isTrue);
    expect(runner.history, [
      'MultiTestUnit:>first test',
      'MultiTestUnit:>second test',
    ]);
  }
}

class SetUpUnitTest extends UnitTest {
  bool setUpAllWasCalled = false;
  final List<int> setUpCalls = [];

  @override void run(Runner runner) {
    runner.setUpAll(setUpAll);
    (runner as MockRunner).runSetUpAll();
    super.run(runner);
    (runner as MockRunner).runTearDownAll();
  }

  @override setUpAll() {
    setUpAllWasCalled = true;
  }

  @override setUp() {
    setUpCalls.add(0);
  }

  @quark.test
  a() {}

  @quark.test
  b() {}

  void verify(MockRunner runner) {
    expect(runner.history, [
      'SetUpUnit:>a',
      'SetUpUnit:>b',
    ]);
    expect(setUpAllWasCalled, isTrue);
    expect(setUpCalls, [0, 0]);
  }
}

class UnitTestTest extends TestCase {
  MockRunner runner;

  setUp() {
    runner = new MockRunner();
  }

  tearDown() {}

  @test
  single_test_unit_test() {
    new SingleTestUnitTest()
      ..run(runner)
      ..verify(runner);
  }

  @test
  multi_test_unit_test() {
    new MultiTestUnitTest()
      ..run(runner)
      ..verify(runner);
  }

  @test
  set_up_unit_test() {
    new SetUpUnitTest()
      ..run(runner)
      ..verify(runner);
  }
}
