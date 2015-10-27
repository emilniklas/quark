import 'package:greeter/greeter.dart';
import 'package:quark/unit.dart';
export 'package:quark/init.dart';

class GreeterTest extends UnitTest {
  final Greeter _greeter;
  final GreetingDouble _greeting;

  GreeterTest(GreetingDouble greeting)
      : _greeting = greeting,
        _greeter = new Greeter(greeting);

  @test itGreetsSomeone() {
    _greeting.willReturn('Yo', from: #phrase);
    expect(_greeter.greet('John'), equals('Yo, John!'));
  }
}

class GreetingDouble extends TestDouble<Greeting> implements Greeting {}
