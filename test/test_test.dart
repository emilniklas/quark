library quark.test.test;

import 'dart:async';

import 'package:test/test.dart';
import 'package:quark/src/test/test.dart';
import 'mock_runner.dart';
import 'package:tuple/tuple.dart';

class ExampleTest extends Test {
  @override List tests;
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
}
