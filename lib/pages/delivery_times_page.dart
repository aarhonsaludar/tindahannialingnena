import 'package:flutter/material.dart';
import '../themes/filipino_theme.dart';
import 'package:intl/intl.dart'; // Make sure to import this for time formatting

class DeliveryTimesPage extends StatelessWidget {
  const DeliveryTimesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate real-time estimates for pickup and delivery
    final DateTime now = DateTime.now();

    // Calculate estimated pickup time (now + 25-30 minutes)
    final DateTime pickupTime = now.add(const Duration(minutes: 25));
    final DateTime pickupTimeEnd = now.add(const Duration(minutes: 30));

    // Calculate estimated delivery time (now + 45-50 minutes)
    final DateTime deliveryTime = now.add(const Duration(minutes: 45));
    final DateTime deliveryTimeEnd = now.add(const Duration(minutes: 50));

    // Format times
    final timeFormat = DateFormat('h:mm a'); // Format like "3:15 PM"
    final String formattedPickupTime = timeFormat.format(pickupTime);
    final String formattedDeliveryTime = timeFormat.format(deliveryTime);

    // Format the order date
    final dateFormat = DateFormat(
      'EEEE, MMMM d, yyyy',
    ); // Format like "Monday, January 1, 2023"
    final String formattedOrderDate = dateFormat.format(now);

    // Create "ready in" strings
    final String pickupReadyIn =
        '${pickupTime.difference(now).inMinutes}-${pickupTimeEnd.difference(now).inMinutes} minutes';
    final String deliveryArrivingIn =
        '${deliveryTime.difference(now).inMinutes}-${deliveryTimeEnd.difference(now).inMinutes} minutes';

    // Generate a unique order number based on timestamp
    final String orderNumber =
        'ORD-${now.millisecondsSinceEpoch.toString().substring(7)}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FilipinoTheme.filipiniana,
        title: const Text(
          'Estimated Times',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with dynamic order number
              Text(
                'Your Order #$orderNumber',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'We\'re preparing your delicious Filipino cuisine',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),

              const SizedBox(height: 30),

              // Pickup Time Section with dynamic time
              _buildTimeSection(
                context,
                title: 'Estimated Pickup Time',
                icon: Icons.store,
                primaryTime: formattedPickupTime,
                secondaryText: 'Ready in $pickupReadyIn',
                bgColor: FilipinoTheme.mangga.withOpacity(0.1),
                iconColor: FilipinoTheme.mangga,
              ),

              const SizedBox(height: 24),

              // Delivery Time Section with dynamic time
              _buildTimeSection(
                context,
                title: 'Estimated Delivery Time',
                icon: Icons.delivery_dining,
                primaryTime: formattedDeliveryTime,
                secondaryText: 'Arriving in $deliveryArrivingIn',
                bgColor: FilipinoTheme.filipiniana.withOpacity(0.1),
                iconColor: FilipinoTheme.filipiniana,
              ),

              const SizedBox(height: 30),

              // Order Details
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Details',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 24),
                      _buildOrderDetailRow(
                        'Order Date',
                        formattedOrderDate,
                        Icons.calendar_today,
                      ),
                      const SizedBox(height: 16),
                      _buildOrderDetailRow(
                        'Order Status',
                        'Being Prepared',
                        Icons.pending_actions,
                      ),
                      const SizedBox(height: 16),
                      _buildOrderDetailRow(
                        'Payment Method',
                        'Cash on Delivery',
                        Icons.payments_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildOrderDetailRow(
                        'Delivery Address',
                        'Katapatan Homes, Cabuyao Laguna, Philippines',
                        Icons.location_on_outlined,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Important Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Times are estimates and may vary based on order volume and traffic conditions.',
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Track Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Track Delivery'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: FilipinoTheme.filipiniana,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _showCancelDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: const Text('Cancel Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String primaryTime,
    required String secondaryText,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        primaryTime,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    secondaryText,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // Add method to show cancel confirmation dialog
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Order?'),
            content: const Text(
              'Are you sure you want to cancel your order? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No, Keep Order'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Your order has been cancelled'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Yes, Cancel Order'),
              ),
            ],
          ),
    );
  }
}
