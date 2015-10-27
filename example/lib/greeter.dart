class Greeting {
  String get phrase => 'Hello';
}

class Greeter {
  final Greeting _greeting;

  Greeter(this._greeting);

  String greet(String name) {
    return '${_greeting.phrase}, $name!';
  }
}