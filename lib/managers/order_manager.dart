import '../models/order.dart';

class OrderManager {
  List<Order> orders = [];

  void addOrder(Order order) {
    orders.add(order);
  }

  void displayOrders() {
    for (var order in orders) {
      print('Order ID: ${order.orderId}, Total Amount: ${order.totalAmount}');
    }
  }

  Order findOrder(String orderId) {
    return orders.firstWhere((order) => order.orderId == orderId, orElse: () => Order('', []));
  }
}
