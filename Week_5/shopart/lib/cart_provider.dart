import 'package:flutter/material.dart';
import 'model/product.dart';

// This is a class to manage the cart state using Provider's ChangeNotifier class
class CartProvider extends ChangeNotifier {
  // We set a list to hold the products added to the cart using the Product model we crated before
  final List<Product> _cartItems = []; 

  // This is a getter to get the cart items
  List<Product> get cartItems => _cartItems;

  // We calculate the total price of the cart items dynamically
  // by using the fold method to sum up the prices of all products in the cart
  double get totalPrice => _cartItems.fold(0, (total, item) => total + item.price); 

  // This method adds a product to the cart and notifies listeners about the change
  void addToCart(Product newProduct){
    _cartItems.add(newProduct);
    notifyListeners();
  }

  // This method removes a product from the cart and notifies listeners about the change
  void removeFromCart(Product oldProduct){
    _cartItems.remove(oldProduct);
    notifyListeners();
  }

  // This method clears all items from the cart and notifies listeners about the change
  void clearCart(){
    _cartItems.clear();
    notifyListeners();
  }
}