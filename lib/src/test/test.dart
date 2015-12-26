library quark.test;

import 'runner.dart';
import 'package:tuple/tuple.dart';

abstract class Test {
  /// Returns an iterable with [Function]s and/or [Tuple2]s of strings and
  /// either [Iterable]s of the same types as this property or [Function].
  ///
  ///     [Function]
  ///     [Tuple2<String, Function>]
  ///     [Tuple2<String, [...]>]
  ///
  /// This makes it possible to construct any group/test hierarchy.
  /// Here's an example:
  ///
  ///     get tests => [
  ///       () => "Top level test",
  ///       new Tuple("Top level group", [
  ///         () => "Inner level test",
  ///         new Tuple("Inner level group", [
  ///           () => "Yet another level test",
  ///           // ...
  ///         ]),
  ///       ]),
  ///     ];
  Iterable get tests;

  void run(Runner runner) {
    _runIterable(runner, tests ?? []);
  }

  void _runIterable(Runner runner, Iterable items) {
    for (final item in items) {
      if (item is Function) {
        _runTest(runner, item);
      } else if (item is Tuple2) {
        _runTuple(runner, item);
      } else {
        throw new Exception('Malformed test suite');
      }
    }
  }

  void _runTuple(Runner runner, Tuple2<String, dynamic> tuple) {
    final description = tuple.item1;
    if (description is! String) {
      throw new Exception('Descriptions must be Strings');
    }

    final item = tuple.item2;
    if (item is Function) {
      _runTest(runner, item, description);
    } else if (item is Iterable) {
      runner.group(description, () {
        _runIterable(runner, item);
      });
    } else {
      throw new Exception('Malformed test suite');
    }
  }

  void _runTest(Runner runner, Function test, [String description = '<no description>']) {
    runner.test(description, test);
  }
}
