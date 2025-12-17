import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopart/src/features/cart/presentation/cart_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state,rebuild whenever map changes
    final cartMap =ref.watch(cartProvider);

    // Watch TOTAL 
    final totalPrice = ref.watch(cartTotalProvider);

    final cartItems = cartMap.values.toList(); // Get list of CartItems from map values 
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        actions: [
          IconButton(onPressed: (){
            ref.read(cartProvider.notifier).clearCart();
          }, icon: Icon(Icons.delete))
        ],
      ),

      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index){
          final cartItem = cartItems[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text("${cartItem.quantity}x"),
            ),
            title: Text(cartItem.title),
            subtitle: Text("\$${cartItem.price}"),
            trailing: IconButton(onPressed: (){
              ref.read(cartProvider.notifier).removeSingleCartItem(cartItem.id);
            }, icon: Icon(Icons.remove)
            ),
          );
        },
        
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "Total: \$${totalPrice.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),

      
    );
  }
}