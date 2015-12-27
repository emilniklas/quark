part of quark.test_double;

VerifyCallable get _verify {
  _isCapturingInvocation = true;
  Assertion verify(_) {
    _isCapturingInvocation = false;
    return _startAssertion();
  }
  return verify;
}

Assertion _startAssertion() {
  return new _Assertion(_capturedInvocationTarget, _capturedInvocation);
}

class _Assertion implements Assertion {
  final _TestDouble _target;
  final Invocation _invocation;

  _Assertion(this._target, this._invocation);

  void wasCalled() {
    final wasCalled = _target._history.any(_matching);
    if (!wasCalled) throw new TestFailure('$_invocation was never called on ${_target.runtimeType}');
  }

  bool _matching(Invocation other) {
    String _id(Invocation i) {
      return '${i.memberName}${i.isAccessor}${i.isGetter}${i.isSetter}${i.isMethod}';
    }

    return _id(_invocation) == _id(other);
  }

  static const _undefined = const _Undefined();

  void wasCalledWith([
    arg1 = _undefined,
    arg2 = _undefined,
    arg3 = _undefined,
    arg4 = _undefined,
    arg5 = _undefined,
    arg6 = _undefined,
    arg7 = _undefined,
    arg8 = _undefined,
    arg9 = _undefined,
    arg10 = _undefined,
    arg11 = _undefined,
    arg12 = _undefined,
    arg13 = _undefined,
    arg14 = _undefined,
    arg15 = _undefined,
    arg16 = _undefined,
    arg17 = _undefined
  ]) {
    final args = [arg1, arg2, arg3, arg4, arg5, arg6,
    arg7, arg8, arg9, arg10, arg11, arg12, arg13,
    arg14, arg15, arg16, arg17].where((a) => a != _undefined);

    receivedArguments(args);
  }

  void receivedArguments(positionalArgumentsMatcher, [namedArgumentsMatcher = const {}]) {
    wasCalled();
    final matching = _target._history.where(_matching);
    for (final match in matching) {
      expect(match.positionalArguments, positionalArgumentsMatcher);
      expect(match.namedArguments, namedArgumentsMatcher);
    }
  }
}

class _Undefined {
  const _Undefined();
}
