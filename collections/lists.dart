// Create a list of names and print all names using list.
import 'dart:io';


List<String> name = ["Joey", "Scholes", "Messi", "Ronaldo", "Neymar", "Mbappe"];

void main(){
  for(var i in name){
    stdout.write(i + ", ");
  }
}