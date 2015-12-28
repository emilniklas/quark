library quark.src.integration;

import '../test/test.dart';
import '../gherkin/gherkin.dart';
import 'package:reflectable/reflectable.dart';
import 'package:tuple/tuple.dart';
import 'package:test/test.dart';

class _IntegrationIoMetadata extends Reflectable {
  const _IntegrationIoMetadata() : super(newInstanceCapability);
}

const integrationIo = const _IntegrationIoMetadata();

abstract class IntegrationIo {
  String getFileContents(String file);

  static IntegrationIo _instance;

  factory IntegrationIo(IntegrationTest test) {
    return _instance ??= new IntegrationIo._find(test);
  }

  factory IntegrationIo._find(IntegrationTest test) {
    if (integrationIo.annotatedClasses.isEmpty) {
      throw new TestFailure('To use relative path to feature, the test must load'
          ' either the browser or vm utils.\n\nadd\n    export \'package:quark/browser\';\n'
          'or\n    export \'package:quark/vm\';\n');
    }
    return integrationIo.annotatedClasses.first.newInstance('', [test]);
  }
}

class _StepMetadata {
  final String pattern;

  const _StepMetadata(this.pattern);

  String toString() => '$runtimeType $pattern';
}

class Given extends _StepMetadata {
  const Given(String pattern) : super(pattern);
}

class When extends _StepMetadata {
  const When(String pattern) : super(pattern);
}

class Then extends _StepMetadata {
  const Then(String pattern) : super(pattern);
}

@_featureAnnotation
abstract class IntegrationTest extends Test {
  List get tests {
    return new List.unmodifiable([
        new Tuple2('${feature.feature}:', _scenarios)
    ]);
  }

  Iterable get _scenarios {
    return feature.scenarios.map((s) {
      return new Tuple2(s.description, () {
        bool failed = false;
        final failures = <String>[];
        for (final step in s.steps) {
          final sentence = '$step';
          final tuple = _steps.firstWhere(
              (t) => t.item1.hasMatch(sentence),
              orElse: () => null
          );
          if (tuple == null) {
            failures.add(_makeSnippet(step));
            failed = true;
          } else if (!failed) {
            tuple.item2();
          }
        }
        if (failed) {
          final message = '${failures.length} missing implementation'
              '${failures.length == 1 ? '' : 's'} in $runtimeType:';
          throw new TestFailure('$message\n\n${failures.join('\n\n')}\n');
        }
      });
    });
  }

  String _makeSnippet(Step step) {
    final methodName = step.description.toLowerCase()
        .replaceAllMapped(new RegExp(' (.)'), (m) => m[1].toUpperCase());
    final snippet = '''
@${step.keyword}('${step.description}')
$methodName() {
  // ...
}
    '''.trim();

    return '$snippet';
  }

  Gherkin __feature;

  Gherkin get feature => __feature ??= _feature;

  Gherkin get _feature {
    final mirror = _featureAnnotation.reflect(this);

    final Feature annotation = mirror.type.metadata
        .firstWhere((o) => o is Feature, orElse: () => null);

    if (annotation == null) return const Gherkin();

    final gherkin = annotation.value.endsWith('.feature')
      ? new IntegrationIo(this).getFileContents(annotation.value)
      : annotation.value;

    return parse(gherkin);
  }

  Iterable<Tuple2<RegExp, Function>> __steps;

  Iterable<Tuple2<RegExp, Function>> get _steps => __steps ??= ___steps;

  Iterable<Tuple2<RegExp, Function>> get ___steps {
    final mirror = _featureAnnotation.reflect(this);

    final stepMethods = mirror.type.declarations.values
        .where((d) => d.metadata.any((o) => o is _StepMetadata));

    return stepMethods.map((d) => _stepMethodToStepTuple(d, mirror));
  }

  Tuple2<RegExp, Function> _stepMethodToStepTuple(
      DeclarationMirror method, InstanceMirror mirror) {
    final _StepMetadata annotation = method.metadata
        .firstWhere((o) => o is _StepMetadata);
    return new Tuple2(new RegExp('^$annotation\$'), () {
      return mirror.invoke(method.simpleName, []);
    });
  }
}

class _FeatureAnnotation extends Reflectable {
  const _FeatureAnnotation() : super(
      subtypeQuantifyCapability,
      typeCapability,
      metadataCapability,
      declarationsCapability,
      instanceInvokeCapability
  );
}

const _featureAnnotation = const _FeatureAnnotation();

class Feature {
  final String value;

  const Feature([this.value]);
}
