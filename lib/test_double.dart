library quark.test_double;

import 'src/test_double/test_double.dart' as impl;

/// This is the main test double class, which seamlessly conforms to
/// the implicit interface of any class.
///
///     class MyClassDouble extends TestDouble implements MyClass {}
@proxy
abstract class TestDouble extends impl.TestDouble {
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// The [when] function is used to set expectations on a member of the
/// test double. This interface specifies what configuration can be made.
abstract class Expectation {
  /// Specifies the return value of the method.
  ///
  ///     when(object.method()).thenReturn(123);
  ///     assert(object.method() == 123);
  void thenReturn(value);

  /// Overrides the entire method.
  ///
  ///     when(object.method().thenRespond((i) => i.memberName);
  ///     assert(object.method() == #method);
  void thenRespond(responder(Invocation invocation));

  /// Throws an error when the method is called.
  void thenThrow(exception);
}

/// Together with the [WhenCallable] typedef, this getter is used to create expectations
/// on methods on test doubles:
///
///     when(object.method());
WhenCallable get when => impl.when;
typedef Expectation WhenCallable(object);

/// If the default behaviour should be to fall through to an actual class, the
/// test double can be assigned a delegate. This delegate must be annotated with
/// the [delegated] annotation:
///
///     // production implementation
///     class Car {
///       void drive() {
///         print('Wroom!');
///       }
///     }
///
///     // test double
///     class CarDouble extends TestDouble implements Car {}
///
///     // delegate
///     @delegated class CarDelegate extends Car {}
///
///     // in a test
///     final double = new CarDouble();
///     delegate(double, to: new CarDelegate());
///     double.drive(); // Wroom!
void delegate(TestDouble double, {to}) {
  if (to == null) throw new ArgumentError.notNull('to');
  return impl.delegate(double, to);
}
const delegated = const impl.Delegatable();

/// The [verify] function is used to capture member invocations and
/// perform assertions on them. This interface specifies the assertions
/// that can be made.
abstract class Assertion {
  /// Verifies that the method was called.
  void wasCalled();

  /// Verifies that the method was called with these arguments.
  void wasCalledWith([arg1, arg2, arg3, arg4, arg5, arg6, arg7,
  arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17]);

  /// Verifies that the method was called with arguments matching
  /// these matchers.
  void receivedArguments(positionalMatcher, [namedMatcher]);
}

/// Together with the [VerifyCallable] typedef, this getter is used to create
/// assertions on methods on test doubles:
///
///     verify(object.method());
VerifyCallable get verify => impl.verify;
typedef Assertion VerifyCallable(object);
