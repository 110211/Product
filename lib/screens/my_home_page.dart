import 'package:flutter/material.dart';
import '../managers/order_manager.dart';
import '../models/discount.dart';
import '../models/order.dart';
import '../models/product.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> _products = [];
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _productQuantityController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  OrderManager _orderManager = OrderManager();

  void _addProduct() {
    String name = _productNameController.text;
    double price = double.tryParse(_productPriceController.text) ?? 0;
    int quantity = int.tryParse(_productQuantityController.text) ?? 0;

    if (name.isNotEmpty && price > 0 && quantity > 0) {
      Product product = Product(name, price, quantity);
      setState(() {
        _products.add(product);
      });
    }

    // Clear input fields
    _productNameController.clear();
    _productPriceController.clear();
    _productQuantityController.clear();
  }

  void _placeOrder() {
    Order order = Order('ORD001', List.from(_products));
    order.discount = Discount.percentagediscount(10);
    double discountAmount = Discount.calculateDiscountAmount(order);

    _orderManager.addOrder(order);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Summary'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order ID: ${order.orderId}'),
              Text('Total Amount: \$${order.totalAmount}'),
              Text('Discount: \$${discountAmount.toStringAsFixed(2)}'),
              Text('Discounted Total: \$${(order.totalAmount - discountAmount).toStringAsFixed(2)}'),
              SizedBox(height: 16),
              Text('Products:'),
              for (var product in order.products)
                Text('ID: ${product.id}, ${product.name} - \$${product.price} x ${product.quantityInStock}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    setState(() {
      _products.clear();
    });
  }

  void _displayOrders() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('All Orders'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var order in _orderManager.orders)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ID: ${order.orderId}'),
                    Text('Total Amount: \$${order.totalAmount}'),
                    SizedBox(height: 16),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _findOrder(String orderId) {
    Order foundOrder = _orderManager.findOrder(orderId);
    if (foundOrder != null) {
      print('Found Order: ${foundOrder.orderId}, Total Amount: ${foundOrder.totalAmount}');
    } else {
      print('Order not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white, // Đổi màu thành trắng
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _OrderSearchDelegate(_orderManager.orders),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add Product:',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              controller: _productPriceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              controller: _productQuantityController,
              decoration: InputDecoration(labelText: 'Quantity in Stock'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text('Place Order'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addProduct,
                  child: Text('Add to Order'),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _displayOrders,
              child: Text('Display Orders'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSearchDelegate extends SearchDelegate<Order> {
  final List<Order> orders;

  _OrderSearchDelegate(this.orders);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == null || query.isEmpty) {
      return Center(
        child: Text('Enter a search query'),
      );
    }

    List<Order> searchResults = orders
        .where((order) =>
    order.orderId.toLowerCase().contains(query.toLowerCase()) ||
        order.products.any((product) =>
            product.name.toLowerCase().contains(query.toLowerCase())))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Order ID: ${searchResults[index].orderId}'),
          subtitle: Text('Total Amount: \$${searchResults[index].totalAmount}'),
          onTap: () {
            // Xử lý khi chọn một đơn hàng từ kết quả tìm kiếm
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == null || query.isEmpty) {
      return Center(
        child: Text('Enter a search query'),
      );
    }

    List<Order> suggestionList = orders
        .where((order) =>
    order.orderId.toLowerCase().contains(query.toLowerCase()) ||
        order.products.any((product) =>
            product.name.toLowerCase().contains(query.toLowerCase())))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Order ID: ${suggestionList[index].orderId}'),
          subtitle: Text('Total Amount: \$${suggestionList[index].totalAmount}'),
          onTap: () {
            // Xử lý khi chọn một đơn hàng từ gợi ý
          },
        );
      },
    );
  }
}
