class Storage {
  void save(){
    print("Saved data to disk...");
  }
}

class Cloudstorage implements Storage {
  @override
  void save(){
    print("Saved data to cloud storage...");
  }
}


void main(){
  var cloud = Cloudstorage();
  cloud.save();
}