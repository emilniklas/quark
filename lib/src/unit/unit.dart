library quark.src.unit;

import '../test/test.dart';
import 'package:reflectable/mirrors.dart';
import '../../test_double.dart';

export 'package:test/test.dart' hide test;

const test = null;

abstract class UnitTest extends Test {
  List get tests => __tests ??= _tests;
  InstanceMirror get _mirror => testCaseMetadata.reflect(this);

  List __tests;

  List get _tests {
    return new List.unmodifiable(_mirror.type.declarations.values
        .where((d) => d.metadata.contains(test))
        .map(_declarationToFunction));
  }

  Function _declarationToFunction(MethodMirror d) {
    if (d is! MethodMirror || d.isConstructor || d.isSetter || d.isGetter)
      throw new ArgumentError('Only regular methods can be annotated as tests');
    final mirror = _mirror;
    final arguments = _makeDoubles(d);
    return () => mirror.invoke(d.simpleName, arguments);
  }

  List<TestDouble> _makeDoubles(MethodMirror method) {
    return method.parameters.map(_instantiateDouble).toList();
  }

  TestDouble _instantiateDouble(ParameterMirror param) {
    if (param.isNamed)
      throw new ArgumentError('Tests can only have positional arguments');
    if (!param.hasReflectedType)
      throw new ArgumentError('Type annotations on the arguments of a test is required');
    final ClassMirror type = testDoubleMetadata.reflectType(param.reflectedType);
    return type.newInstance('', []);
  }
}

