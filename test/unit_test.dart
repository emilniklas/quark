library test.unit;

import 'package:test/test.dart' hide test;
import 'package:test/test.dart' as dart_test show test;
import 'package:quark/unit.dart';
import 'mock_runner.dart';
import 'dart:async';

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

  @beforeAll
  setUpAll() {
    setUpAllWasCalled = true;
  }

  @before
  setUp() {
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

  Future run(UnitTest test) async {
    test.register(runner);
    await runner.run();
  }

  dart_test.test('single test unit test', () async {
    final t = new SingleTestUnitTest();
    await run(t);
    t.verify(runner);
  });

  dart_test.test('multi test unit test', () async {
    final t = new MultiTestUnitTest();
    await run(t);
    t.verify(runner);
  });

  dart_test.test('set up unit test', () async {
    final t = new SetUpUnitTest();
    await run(t);
    t.verify(runner);
  });
}
