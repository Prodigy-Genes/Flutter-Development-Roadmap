// Write a program in Dart that generates random password

import 'dart:math';
List<String> letters = ["a","b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

void randomPassword(dynamic password){
    for(var i = 0; i < 10; i++){
        password.add(letters[Random().nextInt(letters.length)]);
        password.add(numbers[Random().nextInt(numbers.length)]);

        

    }
    password.shuffle(Random());
    print(password.join());

    }

    void main(){
        List<dynamic> password = [];
        randomPassword(password);
        
    }
