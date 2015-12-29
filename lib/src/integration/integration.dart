library quark.src.integration;

import '../test/test.dart';
import '../gherkin/gherkin.dart';
import 'package:tuple/tuple.dart';
import 'package:test/test.dart';
import 'metadata.dart';
import 'package:reflectable/mirrors.dart';

abstract class IntegrationIo {
  String getFileContents(String file);

  static IntegrationIo _instance;

  factory IntegrationIo(IntegrationTest test) {
    return _instance ??= new IntegrationIo._find(test);
  }

  factory IntegrationIo._find(IntegrationTest test) {
    if (integrationIoMetadata.annotatedClasses.isEmpty) {
      throw new TestFailure('To use relative path to feature, the test must load'
          ' either the browser or vm utils.\n\nadd\n    export \'package:quark/browser\';\n'
          'or\n    export \'package:quark/vm\';\n');
    }
    return integrationIoMetadata.annotatedClasses.first.newInstance('', [test]);
  }
}

class Given extends StepMetadata {
  const Given(String pattern) : super(pattern);
}

class When extends StepMetadata {
  const When(String pattern) : super(pattern);
}

class Then extends StepMetadata {
  const Then(String pattern) : super(pattern);
}

@featureMetadata
abstract class IntegrationTest extends Test {
  List get tests {
    return new List.unmodifiable([
        new Tuple2('${feature.feature}:', _scenarios)
    ]);
  }

  Iterable get _scenarios {
    return feature.scenarios.map((s) {
      return new Tuple2(s.description.toString(), () {
        bool failed = false;
        final failures = <String>[];
        for (final step in s.steps) {
          final sentence = '$step';
          final tuples = _steps.where(
              (t) => t.item1.hasMatch(sentence)
          );
          if (tuples.isEmpty) {
            failures.add(_makeSnippet(step));
            failed = true;
          } else if (!failed) {
            for (final tuple in tuples) {
              final regExp = tuple.item1;
              final match = regExp.firstMatch(sentence);
              final groupCount = match.groupCount;
              final indices = <int>[];
              for (var i = 1; i <= groupCount; i++)
                indices.add(i);
              Function.apply(tuple.item2, match.groups(indices));
            }
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
    final snippet = '''
@${step.keyword}('${step.description.pattern}')
${step.description.asSymbol}(${step.description.argumentList}) {
  throw 'Unimplemented';
}
    '''.trim();

    return '$snippet';
  }

  Gherkin __feature;

  Gherkin get feature => __feature ??= _feature;

  Gherkin get _feature {
    final mirror = featureMetadata.reflect(this);

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
    final mirror = featureMetadata.reflect(this);

    final stepMethods = mirror.type.instanceMembers.values
        .where((d) => d.metadata.any((o) => o is StepMetadata));

    return stepMethods.map((d) => _stepMethodToStepTuple(d, mirror));
  }

  Tuple2<RegExp, Function> _stepMethodToStepTuple(
      DeclarationMirror method, InstanceMirror mirror) {
    final StepMetadata annotation = method.metadata
        .firstWhere((o) => o is StepMetadata);
    return new Tuple2(new RegExp('^$annotation\$'), ([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8]) {
      final args = [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8].where((a) => a != null).toList();
      return mirror.invoke(method.simpleName, args);
    });
  }
}

class Feature {
  final String value;

  const Feature([this.value]);
}
