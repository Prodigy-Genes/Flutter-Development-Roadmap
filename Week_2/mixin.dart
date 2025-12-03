class LibraryItem{
  String title;
  LibraryItem(this.title);
}

mixin DigitalAccess {
  void download(){
    print("Downloading content...");
  }
}

class Ebook extends LibraryItem with DigitalAccess{
  String author;
  Ebook(String title, this.author) : super(title);
  
  void checkout(){
    print("Checking out ebook: $title by $author");
  }
}


void main(){

  var myEbook = Ebook("Dart Programming", "John Doe");
  myEbook.checkout();
  myEbook.download();
}