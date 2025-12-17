import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopart/model/cart_item.dart';
import 'package:shopart/model/product.dart';

// 1 DEFINE THE STATE TYPE
// We manage map of ID to CartItem to represent the items in the cart
typedef CartState = Map<String, CartItem>; // typedef is for defining a new name for an existing type 

// 2 CREATE THE NOTIFIER (THE VIEW MODEL)
// We extend Notifier and give it the type of State we want
class CartController extends Notifier<CartState>{
  @override
  // We initialize the state in the build method because it's required by Notifier
  CartState build(){
    // Initialize with an empty map
    return {};
  }

  // LOGIC : ADD TO CART
  void addToCart(Product newProduct){
    if(state.containsKey(newProduct.id)){
      
      // If the product is already in the cart, we update its quantity
      final existing = state[newProduct.id]!;
    
      final updatedCartItem = CartItem(
        id: existing.id,
        title: existing.title,
        quantity: existing.quantity + 1,
        price: existing.price,
      
      );
      // Why we use {...state, ...} : To create a new map with updated values (immutability)
      state={...state, newProduct.id: updatedCartItem};
      

    }else{
      // If the product is not in the cart, we add it
      final newCartItem = CartItem(
        id: newProduct.id,
        title: newProduct.title,
        quantity: 1,
        price: newProduct.price,
      );
      state={...state, newProduct.id: newCartItem};
    }
  }

  // LOGIC : REMOVE SINGLE ITEM FROM CART
  void removeSingleCartItem(String existingCartItem){
    // If Item isn't in cart
    if(!state.containsKey(existingCartItem)) {
      return;
    }

    // if existing item is more than 1
    final existing = state[existingCartItem]!;

    if(existing.quantity>1){
      // Decrease quantity
      final updatedCartItem = CartItem(
        id: existing.id,
        title: existing.title,
        quantity: existing.quantity -1,
        price: existing.price,
      );
      state = {...state, existingCartItem: updatedCartItem};
    }else{
      // Remove item from cart
      final newState = {...state};
      newState.remove(existingCartItem);
      state = newState;
    }

  }
  

  // LOGIC: CLEAR CART
  void clearCart(){
    state = {};
  }
}
// 3. EXPOSE THE VARIABLES AND METHODS TO THE UI
  final cartProvider = NotifierProvider<CartController, CartState>(() {
    return CartController();
  },);

// LOGIC: TOTAL AMOUNT
  final cartTotalProvider = Provider<double>((ref) {
  final cartMap = ref.watch(cartProvider);
  return cartMap.values.fold(0, (sum, item) => sum + (item.price * item.quantity));
});