import 'package:flutter/material.dart';
import 'package:shopart/model/cart_item.dart';
import 'model/product.dart';

// This is a class to manage the cart state using Provider's ChangeNotifier class
class CartProvider extends ChangeNotifier {
  // We set a dictionary to hold the products added to the cart using the Product model we crated before
  final Map<String, CartItem>  _cartItems = {}; 

  // This is a getter to get the cart items
  Map<String, CartItem> get cartItems => _cartItems;

  // We calculate the total price of the cart items dynamically
    double get totalPrice{
      double total =0.0;
      _cartItems.forEach((key, cartItem){
        total += cartItem.price * cartItem.quantity;
      });
      return total;
    }

  // This method adds a product to the cart and notifies listeners about the change
  void addToCart(Product newProduct){
    if(_cartItems.containsKey(newProduct.id)){
      _cartItems.update(
        newProduct.id,
        (existingCartItem){
          return CartItem(
            id: existingCartItem.id, 
            title: existingCartItem.id, 
            quantity: existingCartItem.quantity + 1, 
            price: existingCartItem.price
            );
        }
      );
    }else{
     _cartItems.putIfAbsent(
      newProduct.id, 
      () => CartItem(
        id: newProduct.id, 
        title: newProduct.title, 
        quantity: 1, 
        price: newProduct.price)
      );
    }
    notifyListeners();
  }

  // This method removes a single quantity of a product from the cart and notifies listeners about the change
  void removeSingleItem(String oldProduct){
    if(!_cartItems.containsKey(oldProduct)){
      return;
    }
    if(_cartItems.containsKey(oldProduct) && _cartItems[oldProduct]!.quantity > 1){
      _cartItems.update(
        oldProduct,
        (existingCartItem){
          return CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity -1,
            price: existingCartItem.price, 
          );
        }
      );
    } else{
      _cartItems.remove(oldProduct);
    }
    notifyListeners();
  }


  // This method clears all items from the cart and notifies listeners about the change
  void clearCart(){
    _cartItems.clear();
    notifyListeners();
  }
}