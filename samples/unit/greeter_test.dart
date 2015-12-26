import 'package:quark/quark.dart';

import 'greeter.dart';

export 'package:quark/init.dart';

class GreeterTest extends UnitTest {
  /// Tests the behaviour of the [Greeter] greeting
  /// a person given a [Greeting] and a name.
  @test itGreetsAPerson(GreetingDouble greeting) {
    // Create a greeter from the greeting test double
    final greeter = new Greeter(greeting);

    // The greeting will return "Yo"
    when(greeting.phrase).thenReturn('Yo');

    // Make the assertion
    expect(greeter.greet('buddy'), 'Yo, buddy!');

    // Verify that the phrase was fetched from the greeting.
    verify(greeting.phrase).wasCalled();
  }
}

class GreetingDouble extends TestDouble implements Greeting {}