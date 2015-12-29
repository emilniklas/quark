library test.unit;

import 'package:test/test.dart' hide test;
import 'package:test/test.dart' as dart_test show test;
import 'package:quark/unit.dart';
import 'mock_runner.dart';
import 'package:quark/src/test/runner.dart';

class SingleTestUnitTest extends UnitTest {
  bool testWasRun = false;

  @test
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

  @test
  firstTest() {
    firstTestWasRun = true;
  }

  @test
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

  @test
  a() {}

  @test
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

main() {
  MockRunner runner;

  setUp(() {
    runner = new MockRunner();
  });

  dart_test.test('single test unit test', () {
    new SingleTestUnitTest()
      ..run(runner)
      ..verify(runner);
  });

  dart_test.test('multi test unit test', () {
    new MultiTestUnitTest()
      ..run(runner)
      ..verify(runner);
  });

  dart_test.test('set up unit test', () {
    new SetUpUnitTest()
      ..run(runner)
      ..verify(runner);
  });
}
