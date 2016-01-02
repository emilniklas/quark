library quark.src.unit;

import '../test/test.dart';
import 'package:reflectable/mirrors.dart';
import '../../test_double.dart';
import 'package:tuple/tuple.dart';
import '../test/metadata.dart';
import '../test_double/metadata.dart';
import '../timeline_hook_annotation_methods.dart';
export '../timeline_hook_metadata.dart';
export '../test/metadata.dart' show test;

abstract class UnitTest extends Test with TimelineHookMethods {
  List get tests => __tests ??= _tests;
  InstanceMirror get _mirror => testMetadata.reflect(this);

  List __tests;

  List get _tests {
    return [
      new Tuple2(
          '$runtimeType'.replaceFirst(new RegExp(r'test$', caseSensitive: false), '') + ':',
          new List.unmodifiable(_mirror.type.declarations.values
            .where((d) => d.metadata.contains(test))
            .map(_declarationToTestTuple)
          )
      )
    ];
  }

  Tuple2<String, Function> _declarationToTestTuple(DeclarationMirror d) {
    final MethodMirror m = d;
    if (m is! MethodMirror || m.isConstructor || m.isSetter || m.isGetter)
      throw new ArgumentError('Only regular methods can be annotated as tests');
    final mirror = _mirror;
    final arguments = _makeDoubles(d);
    return new Tuple2(_sentence(m.simpleName), () => mirror.invoke(m.simpleName, arguments));
  }

  String _sentence(String symbolName) {
    String camelReplacement(Match $) {
      return '${$[1]} ${$[2].split('').join(' ')}'.toLowerCase();
    }

    return symbolName.replaceAll('_', ' ')
        .replaceAllMapped(new RegExp(r'([a-z])([A-Z]+)'), camelReplacement);
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

