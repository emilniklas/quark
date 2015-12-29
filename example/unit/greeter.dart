library greeter;

class Greeter {
  final Greeting greeting;

  Greeter(this.greeting);

  String greet(String name) {
    return '${greeting.phrase}, $name!';
  }
}

class Greeting {
  final String phrase;

  const Greeting(this.phrase);
}