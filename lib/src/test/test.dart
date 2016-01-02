library quark.test;

import 'runner.dart';
import 'package:tuple/tuple.dart';
import 'metadata.dart';
import 'dart:async';

@testMetadata
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

  Iterable<Function> get before;
  Iterable<Function> get beforeAll;
  Iterable<Function> get after;
  Iterable<Function> get afterAll;

  void register(Runner runner) {
    _compundFunction(beforeAll, runner.setUpAll);
    _compundFunction(before, runner.setUp);
    _compundFunction(after, runner.tearDown);
    _compundFunction(afterAll, runner.tearDownAll);
    _registerIterable(runner, tests ?? []);
  }

  void _compundFunction(Iterable<Function> functions, void callback(function())) {
    if (functions.isEmpty) return;
    callback(() => Future.wait(functions.map((f) async => f())));
  }

  void _registerIterable(Runner runner, Iterable items) {
    for (final item in items) {
      if (item is Function) {
        _registerTest(runner, item);
      } else if (item is Tuple2) {
        _registerTuple(runner, item as Tuple2<String, dynamic>);
      } else {
        throw new Exception('Malformed test suite');
      }
    }
  }

  void _registerTuple(Runner runner, Tuple2<String, dynamic> tuple) {
    final description = tuple.item1;
    if (description is! String) {
      throw new Exception('Descriptions must be Strings');
    }

    final item = tuple.item2;
    if (item is Function) {
      _registerTest(runner, item, description);
    } else if (item is Iterable) {
      runner.group(description, () {
        _registerIterable(runner, item);
      });
    } else {
      throw new Exception('Malformed test suite');
    }
  }

  void _registerTest(Runner runner, Function test, [String description = '<no description>']) {
    runner.test(description, () => test());
  }
}
