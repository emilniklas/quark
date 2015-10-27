import 'package:greeter/greeter.dart';
import 'dart:html';

main() {
  final greeter = new Greeter(new Greeting());
  document.body.append(new DivElement()..text = greeter.greet('Jane'));
}