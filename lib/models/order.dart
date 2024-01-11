import 'discount.dart';
import 'product.dart';

class Order {
  String orderId;
  List<Product> products;
  double totalAmount = 0; // Initialize totalAmount with a default value
  Discount? discount;

  Order(this.orderId, this.products) {
    totalAmount = calculateTotalAmount();
  }

  double calculateTotalAmount() {
    double amount = 0;
    for (var product in products) {
      amount += (product.price * product.quantityInStock);
    }
    return amount;
  }
}
