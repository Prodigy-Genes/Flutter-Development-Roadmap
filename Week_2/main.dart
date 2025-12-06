import 'dart:io';
class LibrarySystem{
  List<String> _Books = ["Lost", "Come back", "Awesome", "From Sun Down"];
  Map<String, String> userCredentials = {
    "Joseph":"123456",
    "Osei":"654321"
  };
  List<String> get Books => _Books;

  void welcome(){
    print("Welcome to this library system");
  }

  void options(){
    print("Here are a list of services the system provides.\n\n1.View books available. \n2.Return a book. \n3.Borrow books. \n4.View borrowed books. \n5.Exit");
  }

  void showBooks(){
    if(Books.isEmpty){
      print("There are no books in the system right now.");
    }
    else {
      print(
        "These are the available books: \n$Books"
      );
    }
  } 

  bool validate(String name, String password){
    if(userCredentials.containsKey(name) && userCredentials[name]==password){
      print("Access Granted!");
      
      return true;
    }
    else{
      print("Access Denied!");
      return false;
    }
  }
  
}

class Members{
  static var library = LibrarySystem();
  bool isLoggedin = false;
  List<String> _borrowedBooks = [];
  String? name;
  String? password;

  void returnBook(String Book){
    if(library.Books.contains(Book)){
      print("You can't return a book we already have");
    }
    else if(Book.isEmpty){
      print("Indicate the book you wish to return.");
    }
    else if(!_borrowedBooks.contains(Book)){
      print("You can't return a book you didn't borrow.");
    }
    else{
      library.Books.add(Book);
      print("Book has been returned.");
    }
  }

  void borrowBook(String Book){
    if(Book.isEmpty){
      print("Indicate the book you wish to borrow");
    }
    else if(!library.Books.contains(Book)){
      print("We don't have the book you wish to borrow. Try something else");
    }
    else{
      library.Books.remove(Book);
      _borrowedBooks.add(Book);
      print("Book borrowed. Congratulations!");
    }
  }

  List<String> get borrowedBooks => _borrowedBooks;
  void showborrowedBooks(){
    if(borrowedBooks.isEmpty){
      print("You have no books borrowed currently");
    }else{
      print("These are your borrowed books: \n$borrowedBooks");
    }
  } 

  void authenticate (){
    print("Enter your name:");
    name = stdin.readLineSync();
    print("Enter your password");
    password = stdin.readLineSync();
    isLoggedin=library.validate( name!, password!);
    
    if(isLoggedin){
      print("Welcome member $name");
    }
    else{
      exit(0);
    }
  }

  void chooseOption(){
    library.options();
    var selected = stdin.readLineSync();
    if(selected == "1"){
      print("----------------------------------------------------");
      library.showBooks();
      print("------------------------------------------------------");
    }
    else if(selected == "2"){
      print("-------------------------------------------------------------");
      print("Enter the book you wish to return");
      String? Book = stdin.readLineSync();
      returnBook(Book!);
      print("---------------------------------------------------------------");
    }
    else if(selected == "3"){
      print("Enter the book you wish to borrow");
      print("-------------------------------------------------------------------");
      String? Book = stdin.readLineSync();
      borrowBook(Book!);
      print("---------------------------------------------------------------------");
    }
    else if(selected == "4"){
      print("---------------------------------------------------------------------");
      showborrowedBooks();
      print("----------------------------------------------------------------------");
    }
    else if(selected == "5"){
      print("-----------------------------------------------------------------------");
      print("Exiting system...");
      print("------------------------------------------------------------------------");
      exit(0);
    }
    else{
      print("Invalid Option");
    }
  }

}


void main(){
  var library = LibrarySystem();
  library.welcome();
  var member = Members();
  member.authenticate();
  while(true){
    member.chooseOption();
  }

  

}