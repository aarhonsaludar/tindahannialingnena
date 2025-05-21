import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/order_history_service.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Order History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<OrderHistoryService>(
        builder: (context, orderHistoryService, child) {
          final orders = orderHistoryService.orderHistory;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(
                    'Order #${order['id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${order['timestamp']}\nTotal: ₱${order['total']}',
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (order['items'] as List).length,
                      itemBuilder: (context, itemIndex) {
                        final item = order['items'][itemIndex];
                        return ListTile(
                          leading: Image.asset(
                            item['imageUrl'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['name']),
                          subtitle:
                              item['specialInstructions'] != null
                                  ? Text('Note: ${item['specialInstructions']}')
                                  : null,
                          trailing: Text(
                            '${item['quantity']} × ₱${item['price']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
