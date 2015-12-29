library quark.test_double.test_double;

import 'metadata.dart';
export 'metadata.dart';

import 'package:test/test.dart';
import '../../test_double.dart' as interface show Assertion, Expectation, VerifyCallable, WhenCallable;
import 'package:reflectable/mirrors.dart';
import 'package:reflectable/reflectable.dart';

part 'when.dart';
part 'verify.dart';

@testDoubleMetadata
class TestDouble {
  Map<Invocation, Function> _storedResponses = {};
  InstanceMirror _delegate;
  List<Invocation> _history = [];

  noSuchMethod(Invocation invocation) {
    if (isCapturingInvocation) {
      capturedInvocationTarget = this;
      capturedInvocation = invocation;
      return null;
    }

    _history.add(invocation);

    String _id(Invocation i) {
      return '${i.memberName}${i.isAccessor}${i.isGetter}${i.isSetter}${i.isMethod}';
    }

    bool isInvocation(Invocation other) => _id(other) == _id(invocation);

    if (_storedResponses.keys.any(isInvocation)) {
      final key = _storedResponses.keys.firstWhere(isInvocation);
      return _storedResponses[key](invocation);
    } else if (_delegate != null) {
      return _delegate.delegate(invocation);
    }
    return null;
  }
}
