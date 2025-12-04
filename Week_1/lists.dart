void main(){
  List<String> fruits = ['Apple', 'Banana', 'Orange'];
  print('Fruits List: $fruits');

  fruits.add('Mango');
  print('Mango added: $fruits');

  fruits.remove('Banana');
  print(' Banana removed: $fruits');

  fruits.removeAt(0);
  print('fruits after removing index 0: $fruits');

  print(fruits.length );

  print('fruits[0]: ${fruits[0]}');

  fruits[1] = 'Grapes';
  print(' fruits after changing index 1: $fruits');

  fruits.sort();
  print('fruits after sorting: $fruits');

  fruits.clear();
  print('fruits after clearing: $fruits');

  // Adding a new item at index 1
  fruits.add("Mango");
  fruits.add("Pineapple");
  fruits.insert(0, "Apple");
  print("fruits after adding Apple at 1 $fruits");

}