import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopart/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        leading: Icon(Icons.shopping_bag),
        title: Text("My Cart"),
        actions: [
          IconButton(onPressed : ()=> Provider.of<CartProvider>(context, listen: false).clearCart(), 
          icon: Icon(Icons.delete))
        ],
      ),

      // Set Consumer so whenver notifylisteners is set in the provider it rebuilds the widget
      body: Consumer<CartProvider>(builder: (context, cart, child){
        return Column(
          children: [
            // List of cart items
            // Use Expanded to make the list take available space
            Expanded(
              child: ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index){
                  
                  final product = cart.cartItems[index];
                  return ListTile(
                    title: Text(product.title, style: GoogleFonts.lato(),),
                    subtitle: Text("\$${product.price.toStringAsFixed(2)}", style: GoogleFonts.lato(),),
                    trailing: IconButton(
                      // Remove from cart
                      onPressed: () => cart.removeFromCart(product), 
                      icon: Icon(Icons.circle))
                  ,
                  );
                }),
            ),

            // Total Price Section
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.purple,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total:", style: GoogleFonts.lato(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("\$${cart.totalPrice.toStringAsFixed(2)}", style: GoogleFonts.lato(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),)
                ],
              ),
            )
          ],
        );
      })
    );
  }
}