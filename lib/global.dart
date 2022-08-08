import 'Product.dart';

List<Product> products = [];

List<Product> cart = [];

List<String> productCatergories = [];

int cartTotalQty = 0;
int cartGrandTotal = 0;

void getTotalQty() {
  //reset the qty first
  cartTotalQty = 0;
  for (var product in cart) {
    cartTotalQty += product.qty;
  }
} //ef

void getGrandTotal() {
  //reset grand total
  cartGrandTotal = 0;
  for (var product in cart) {
    cartGrandTotal += product.qty * product.price;
  }
} //ef

//functions
void incQty(Product product) {
  product.qty++;
}

void decQty(Product product) {
  product.qty--;
  if (product.qty == 0) {
    cart.remove(product);
  }
}

void removeProduct(Product product) {
  cart.remove(product);
}
