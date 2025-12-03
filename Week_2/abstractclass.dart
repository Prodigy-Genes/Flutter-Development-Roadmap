abstract class Animal {
  String name, color;
  Animal(this.name, this.color); // Constructor
  void eat(); // Abstract method
  void sleep(); // Abstract method

}
// Abstract class cannot be instantiated directly
class Dog extends Animal{
  Dog(String name, String color): super(name,color);
  // overriding abstract methods
  @override
  void eat(){
    print("Dod is eating");
  }

  @override
  void sleep(){
    print("$name is sleeping");
  }

  // Non-abstract method
  void colorTypes(){
    List<String> colors = ["Brown", "Black", "White"];
    for(var color in colors){
      print("A list of colors from: $color");
    }
  }

}

void main (){

  var dog = Dog("Buddy", "Brown");
  dog.eat();
  dog.sleep();
  dog.colorTypes();
}