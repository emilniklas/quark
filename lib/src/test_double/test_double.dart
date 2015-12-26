part of quark.test_double;

class _TestDouble {
  Map<Invocation, Function> _storedResponses = {};
  InstanceMirror _delegate;
  List<Invocation> _history = [];

  noSuchMethod(Invocation invocation) {
    if (_isCapturingInvocation) {
      _capturedInvocationTarget = this;
      _capturedInvocation = invocation;
      return null;
    }

    _history.add(invocation);

    String _id(Invocation i) {
      return '${i.memberName}${i.isAccessor}${i.isGetter}${i.isSetter}${i.isMethod}';
    }

    isInvocation(Invocation other) => _id(other) == _id(invocation);

    if (_storedResponses.keys.any(isInvocation)) {
      final key = _storedResponses.keys.firstWhere(isInvocation);
      return _storedResponses[key](invocation);
    } else if (_delegate != null) {
      return _delegate.delegate(invocation);
    }
    return null;
  }
}
