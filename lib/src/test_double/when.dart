part of quark.test_double.test_double;

Invocation capturedInvocation;
TestDouble capturedInvocationTarget;
bool isCapturingInvocation = false;
interface.WhenCallable get when {
  isCapturingInvocation = true;
  Expectation when(_) {
    isCapturingInvocation = false;
    return new Expectation(capturedInvocationTarget, capturedInvocation);
  }
  return when;
}

class Expectation implements interface.Expectation {
  final TestDouble _target;
  final Invocation _invocation;

  Expectation(this._target, this._invocation);

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
