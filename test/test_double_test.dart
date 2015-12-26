library quark.test.test_double;

import 'package:testcase/testcase.dart';
import 'package:quark/test_double.dart';

export 'package:testcase/init.dart';

class TestDoubleTest extends TestCase {
  setUp() {}

  tearDown() {}

  @test
  it_works() {
    expect(new MyClassDouble().method(), null);
  }

  @test
  it_can_override_a_return_value() {
    final double = new MyClassDouble();
    when(double.method()).thenReturn('override');
    expect(double.method(), 'override');
  }

  @test
  it_can_provide_a_handler() {
    final double = new MyClassDouble();
    when(double.method()).thenRespond((invocation) {
      return invocation.memberName;
    });
    expect(double.method(), #method);
    expect(double.method, null);
  }

  @test
  it_can_provide_an_exception() {
    final double = new MyClassDouble();
    when(double.method()).thenThrow(new Exception());
    expect(() => double.method(), throws);
  }

  @test
  it_can_specify_fall_through() {
    final double = new MyClassDouble();
    delegate(double, to: new MyClassDelegate());
    expect(double.method(), 'response');
    when(double.method()).thenReturn('override');
    expect(double.method(), 'override');
  }

  @test
  it_can_verify_that_something_was_called() {
    final double = new MyClassDouble();
    expect(() => verify(double.method()).wasCalled(), throwsA(new isInstanceOf<TestFailure>()));
    double.method();
    verify(double.method()).wasCalled();
  }

  @test
  it_can_verify_that_something_was_called_with_arguments() {
    final double = new MyClassDouble();
    double.method(1, 2, 3);
    expect(() => verify(double.method()).wasCalledWith(4, 5, 6), throwsA(new isInstanceOf<TestFailure>()));
    expect(() => verify(double.method()).wasCalledWith(4, 5), throwsA(new isInstanceOf<TestFailure>()));
    verify(double.method()).wasCalledWith(1, 2, 3);
  }
}

class MyClass {
  String method([a, b, c]) => 'response';
}

@delegated class MyClassDelegate extends MyClass {}

class MyClassDouble extends TestDouble implements MyClass {}
