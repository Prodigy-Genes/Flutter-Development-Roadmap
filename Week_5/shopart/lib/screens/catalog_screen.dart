import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopart/cart_provider.dart';
import 'package:shopart/model/product.dart';
import 'package:shopart/screens/cart_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(
        id: "1", title: "Mona Lisa", price: 99.99, color: Colors.amber
        ),
        Product(
        id: "2", title: "Starry Night", price: 149.99, color: Colors.blue
        ),
        Product(
        id: "3", title: "The Scream", price: 129.99, color: Colors.red
        ),
        Product(
          id: "4", title: "The Persistence of Memory", price: 119.99, color: Colors.green
        )
    ];
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.art_track),
        title: Text(
          "ShopArt Catalog",
          style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: (){
                // Navigate to cart screen
                Navigator.push(context, MaterialPageRoute(builder: (c) => const CartScreen()));
              }, 
              icon: Icon(Icons.shopping_bag))
          ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3/4,
          ),
          itemCount: products.length,
          itemBuilder: (context, index){
            // Set the products values to product 
            final product = products[index];
            return Container(
              decoration: BoxDecoration(
                color: product.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.title,
                    style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: (){
                      // Add to cart functionality
                      // Over here we call the addToCart method from the CartProvider class
                      context.read<CartProvider>().addToCart(product);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${product.title} has been added to cart"
                        , style: GoogleFonts.lato(color: Colors.white, )
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                        
                        )
                      );
                    }, 
                    child: Text("Add to Cart"))
                ],
              ),
            );
          }),
      ),
    );
  }
}