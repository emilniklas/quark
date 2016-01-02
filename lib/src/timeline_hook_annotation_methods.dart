library quark.src.before_after_annotation_methods;

import 'timeline_hook_metadata.dart';
import 'test/metadata.dart';

abstract class TimelineHookMethods {
  final Map<String, Iterable<Function>> __cache = {};

  Iterable<Function> _cache(String id, Iterable<Function> value()) {
    return __cache[id] ??= value();
  }

  Iterable<Function> get before => _cache(
      'before', () => _annotatedWith((o) => o is BeforeMetadata));

  Iterable<Function> get beforeAll => _cache(
      'beforeAll', () => _annotatedWith((o) => o is BeforeAllMetadata));

  Iterable<Function> get after => _cache(
      'after', () => _annotatedWith((o) => o is AfterMetadata));

  Iterable<Function> get afterAll => _cache(
      'afterAll', () => _annotatedWith((o) => o is AfterAllMetadata));

  Iterable<Function> _annotatedWith(bool isAnnotatedWith(Object object)) {
    final mirror = testMetadata.reflect(this);
    final methods = mirror.type.instanceMembers.values
        .where((m) => m.metadata.any(isAnnotatedWith))
        .map((m) => m.simpleName);
    return methods.map((method) => () => mirror.invoke(method, []));
  }
}
