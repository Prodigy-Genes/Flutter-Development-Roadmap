// Week 2 Assignment : Create a simple library management system with classes for books, members, and loans, demonstrating OOP principles.

// I decided to add some bit of authentication to the system using mixins for digital access.
import 'dart:io';

abstract class LibraryItem{
  String title;
  LibraryItem(this.title);
  
  void checkout();
  void returnItem();
}

class Book extends LibraryItem{
  String author;
  Book(String title, this.author) : super(title);
  @override
  void checkout(){
    print("Checking out book: $title by $author");
    
  }
  @override
  void returnItem(){
    print("Returning book: $title by $author");
  }
}

mixin DigitalAccess{
  bool isLoggedIn = false;
  String? Currentusername;

  void login(){
    stdout.write("Enter your username: ");
    String username = stdin.readLineSync()!;
    stdout.write("Enter your password: ");
    String password = stdin.readLineSync()!;

    Map<String, String> userCredentials = {
      "prodigygenes": "password1",
      "joseph": "password2",
    };

    if (userCredentials.containsKey(username) && userCredentials[username] == password) {
      isLoggedIn =true;
      Currentusername = username;
      print("Login successful!");
      print("Accessing digital content...");
      print("Welcome to the digital library! $username Enjoy!");
    } else {
      print("Invalid username or password. Please try again.");
    }
  }
}

class Ebook extends LibraryItem with DigitalAccess{
  String author;
  Ebook(String title, this.author) : super(title);

  @override
  void checkout(){
    if(isLoggedIn){
      print("$Currentusername is Checking out ebook: $title by $author");
    }else{
      print("Please login first to access digital content.");
    }
  }

  @override
  void returnItem(){
    if(isLoggedIn){
      print("$Currentusername is Returning ebook: $title by $author");
    }else{
      print("Please login first to access digital content.");
    }
  }
}

class Member {
  String name;
  Member(this.name);

  List<LibraryItem> _Loans = [];

  void borrowItem( LibraryItem item){
    if(item is Ebook && !(item).isLoggedIn){
      print("Please login to borrow digital items.");
    }
    item.checkout(); 
    _Loans.add(item); 
    print(" Member $name has borrowed ${item.title}.");
    print("System: Added '${item.title}' from $name's account.\n");
  }

  void returnItem(LibraryItem item){
    if(_Loans.contains(item)){
      item.returnItem();
      _Loans.remove(item);
      print("Member $name has returned ${item.title}.");
      print("System: Removed '${item.title}' from $name's account.\n");
    }else{
      print("Member $name did not borrow ${item.title}.");
    }
  }
}


void main(){
  var myBook = Book("Anarchious", "Prodigygenes");
  myBook.checkout();
  myBook.returnItem();

  
  var myEbook = Ebook("My Vampire System", "JKS Manga");
  
  print("--- STEP 1: LOGIN ---");
  // User logs into the Ebook system
  myEbook.login(); 

  // Create Member DYNAMICALLY based on who logged in
  if (myEbook.isLoggedIn) {
    // We take the username directly from the Ebook's mixin data
    var activeMember = Member(myEbook.Currentusername!); 
    
    print("\n--- STEP 2: BORROWING ---");
    // Now the member borrows items
    activeMember.borrowItem(myEbook);
     

    print("\n--- STEP 3: RETURNING BOOk ---");
    activeMember.returnItem(myEbook);
  } else {
    print("Session ended: No active member.");
  }




 
 }