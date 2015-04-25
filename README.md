# quark

### An extensive testing library


## Abstract

As of this initial version, nothing has been implemented yet. The purpose of this library is to provide a more 
intuitive testing experience to the Dart community.

The Dart team standard `unittest` library is inspired by, and follows conventions to, simple assert-match testing 
tools such as _Jasmine_.

Coming from the active PHP/Composer community, I miss the wide variety of integrated testing tools that can be found 
in that community.

_Quark_, heavily inspired by the PHP unittesting framework _PHPSpec_, aims to provide a class based, object oriented 
way to write tests. Here is the proposed syntax:


## Structure, syntax, and conventions

### Unit testing
#### Overview

##### Implementation
```dart
class Greeter {
  
  String sayHelloTo(String name) {
    
    return 'Hello, $name!';
  }
}
```

##### Test case
```dart
import 'package:quark/quark.dart';
import 'greeter.dart';

class GreeterTest extends UnitTest<Greeter> {

  @test
  it_greets_a_person_by_their_name() {
    
    this.sayHelloTo('Emil').shouldReturn('Hello, Emil!');
  }
}
```

So let's talk about this. Inside the `GreeterTest` class `this` virtually refers to the implemented `Greeter` class. 
But all methods called on the implementation (through some mirroring and som `noSuchMethod` magic) returns an 
`Assertion` object, containing the value returned from the method called on the `Greeter`.

That `Assertion` object can then be queried for its value, through various methods, such as `shouldReturn`. 
Additionally, it too can handle `noSuchMethod` to chain the process over to a potential return value consisting of an
object. In turn, that method will also return an `Assertion`, making statements like this possible:

```dart
this.createGreetable('Emil').greet().shouldReturn('Hello, Emil!');
```

In this example, we're testing some sort of factory-like class (which might not be conventionally correct in the 
Dart world, but it proves a point).

* `createGreetable('Emil')` makes some sort of `Greetable` object and wraps it in an `Assertion`.
* `greet()` is called on the `Assertion` object which delegates it to the `Greetable` inside, and wraps the value in 
a new `Assertion` instance. In our case that value should be 'Hello, Emil!'.
* So we test that by calling `shouldReturn('Hello, Emil!')` on the last `Assertion` object.
* If the `Assertion` object sees that it doesn't contain a value that equals 'Hello, Emil!', it fails the request.