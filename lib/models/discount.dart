// models/discount.dart
import 'order.dart';

typedef DiscountCalculator = double Function(Order order);

abstract class Discount {
  Discount._();

  static DiscountCalculator calculateDiscountAmount = (Order order) {
    double discountAmount = 0;

    if (order.discount != null) {
      if (order.discount is PercentageDiscount) {
        discountAmount = order.totalAmount * (order.discount as PercentageDiscount).percentage / 100;
      } else if (order.discount is FixedDiscount) {
        discountAmount = (order.discount as FixedDiscount).amount;
      }
    }

    return discountAmount;
  };
  static PercentageDiscount percentagediscount(double percentage) {
    return PercentageDiscount(percentage);
  }
}

class PercentageDiscount extends Discount {
  double percentage;

  PercentageDiscount(this.percentage) : super._();
}

class FixedDiscount extends Discount {
  double amount;

  FixedDiscount(this.amount) : super._();
}
