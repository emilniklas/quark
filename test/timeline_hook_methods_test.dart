library test.timeline_hook_methods_test;

import 'package:test/test.dart';
import 'package:quark/src/timeline_hook_annotation_methods.dart';
import 'package:quark/src/timeline_hook_metadata.dart';
import 'package:quark/src/test/metadata.dart' hide test;

@testMetadata
class ExampleHooks extends TimelineHookMethods {
  final List<String> history = [];

  @beforeAll
  beforeAll1() => history.add('beforeAll1');

  @beforeAll
  beforeAll2() => history.add('beforeAll2');

  @before
  before1() => history.add('before1');

  @before
  before2() => history.add('before2');

  @after
  after1() => history.add('after1');

  @after
  after2() => history.add('after2');

  @afterAll
  afterAll1() => history.add('afterAll1');

  @afterAll
  afterAll2() => history.add('afterAll2');
}

main() {
  callAll(Iterable<Function> functions) {
    for (final function in functions)
        function();
  }

  test('annotations', () {
    final hooks = new ExampleHooks();
    callAll(hooks.beforeAll);
    callAll(hooks.before);
    callAll(hooks.after);
    callAll(hooks.afterAll);
    expect(hooks.history, [
      'beforeAll1',
      'beforeAll2',
      'before1',
      'before2',
      'after1',
      'after2',
      'afterAll1',
      'afterAll2',
    ]);
  });
}
