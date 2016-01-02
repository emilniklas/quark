library quark.test.test;

import 'dart:async';

import 'package:test/test.dart';
import 'package:quark/src/test/test.dart';
import 'mock_runner.dart';
import 'package:tuple/tuple.dart';

class ExampleTest extends Test {
  @override List tests;
  @override List<Function> before = [];
  @override List<Function> after = [];
  @override List<Function> beforeAll = [];
  @override List<Function> afterAll = [];
}

main() {
  Future runTests(Iterable tests) async {
    final t = new ExampleTest();
    t.tests = tests;
    final runner = new MockRunner();
    t.register(runner);
    await runner.run();
  }

  Future waitFor(Future future, String message, {int seconds: 3}) {
    return future.timeout(new Duration(seconds: seconds), onTimeout: () {
      fail(message);
    });
  }

  test('single_top_level_test', () async {
    final c = new Completer();
    await runTests([
      () => c.complete()
    ]);
    await waitFor(c.future, 'Test never ran');
  });

  test('multiple_top_level_tests', () async {
    final c = new StreamController();
    await runTests([
      () => c.add(0),
      () => c.add(0),
      () => c.add(0),
    ]);

    final results = await waitFor(
        c.stream.take(3).toList(),
        'Not all tests ran'
    );
    expect(results, [0, 0, 0]);
  });

  test('nested_tests', () async {
    final c = new StreamController();
    await runTests([
      () => c.add(0),
      new Tuple2('x', () => c.add(0)),
      new Tuple2('x', [
        () => c.add(0),
        new Tuple2('x', () => c.add(0)),
      ]),
    ]);

    final results = await waitFor(
        c.stream.take(4).toList(),
        'Not all tests ran'
    );
    expect(results, [0, 0, 0, 0]);
  });

  test('lifetime', () async {
    final history = <String>[];
    final t = new ExampleTest();
    Function addToHistory(String identifier) {
      return () {
        history.add(identifier);
      };
    }

    t.beforeAll = [
      addToHistory('beforeAll1'),
      addToHistory('beforeAll2'),
    ];

    t.before = [
      addToHistory('before1'),
      addToHistory('before2'),
    ];

    t.after = [
      addToHistory('after1'),
      addToHistory('after2'),
    ];

    t.afterAll = [
      addToHistory('afterAll1'),
      addToHistory('afterAll2'),
    ];

    t.tests = [
      addToHistory('t1'),
      addToHistory('t2'),
    ];

    final runner = new MockRunner();
    t.register(runner);
    await runner.run();

    expect(history, [
      'beforeAll1',
      'beforeAll2',
      'before1',
      'before2',
      't1',
      'after1',
      'after2',
      'before1',
      'before2',
      't2',
      'after1',
      'after2',
      'afterAll1',
      'afterAll2',
    ]);
  });
}
