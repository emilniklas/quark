part of quark.test_double;

When get _when {
  _isCapturingInvocation = true;
  Expectation when(_) {
    _isCapturingInvocation = false;
    return _startExpectation();
  }
  return when;
}

Invocation _capturedInvocation;
_TestDouble _capturedInvocationTarget;
bool _isCapturingInvocation = false;
Expectation _startExpectation() {
  return new _Expectation(_capturedInvocationTarget, _capturedInvocation);
}

class _Expectation implements Expectation {
  final _TestDouble _target;
  final Invocation _invocation;

  _Expectation(this._target, this._invocation);

  void thenReturn(value) {
    thenRespond((_) => value);
  }

  void thenRespond(responder(Invocation invocation)) {
    _target._storedResponses[_invocation] = responder;
  }

  void thenThrow(exception) {
    thenRespond((_) => throw exception);
  }
}
