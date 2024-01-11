class Product {
  static int _nextProductId = 1;

  int id;
  String name;
  double price;
  int quantityInStock;

  Product(this.name, this.price, this.quantityInStock) : id = _nextProductId++;
}
