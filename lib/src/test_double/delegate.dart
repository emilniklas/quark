part of quark.test_double;

class _Delegatable extends Reflectable {
  const _Delegatable() : super(delegateCapability, instanceInvokeCapability);
}

void _delegate(_TestDouble double, to) {
  final reflector = Reflectable.getInstance(_Delegatable);

  final mirror = reflector.reflect(to);

  double._delegate = mirror;
}
