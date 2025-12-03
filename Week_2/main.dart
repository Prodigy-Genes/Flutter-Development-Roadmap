// Week 2 Assignment : Create a simple library management system with classes for books, members, and loans, demonstrating OOP principles.

abstract class Library {

  String title;
  Library(this.title);

  void checkin();
  void checkout();
}

class Books extends Library {

  String author;
  Books(String title, this.author): super(title);

  @override
  void checkin(){
    print("Checking in a book $title by $author. ");
  }
  @override
  void checkout(){
    print("Checking out a book $title by $author. ");
  }
}

class Members{
  String name;

  Members(this.name);

  List<Books> _borrowedbooks = [];

  void Borrow(Books book){
    book.checkout();
    print("$name has checked out a book ${book.title} by ${book.author}");
    _borrowedbooks.add(book);
    print("Book has been added to borrowed books list");
  }

  void Return(Books book){
    book.checkin();
    print("$name has returned book ${book.title} by ${book.author}");
    _borrowedbooks.remove(book);
    print("Book has been removed from borrowed books list");
  }

  // to print the books in the list, since it is a private list, we need a getter
  List<Books> get borrowedbooks => _borrowedbooks;

  // Now a funtion to display it
  void showList(){
    print("Books borrowed includes: $borrowedbooks");
  } 
}

void main(){

  var myBook = Books("Anarchious", "Prodigygenes");
  var member1 = Members("Joseph");

  member1.Borrow(myBook);
  member1.Return(myBook);

  // Show list of borrowed books
  member1.showList();
}