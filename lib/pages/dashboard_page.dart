import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../widgets/shared_app_bar.dart';
import '../services/dashboard_service.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _orderFilterStatus = 'All';
  int _orderTimeFilter = 1; // 1=today, 7=week, 30=month

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Add a button to simulate adding a new random order
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            tooltip: 'Simulate New Order',
            onPressed: () {
              // Add a random order
              Provider.of<DashboardService>(
                context,
                listen: false,
              ).addRandomOrder();

              // Show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('New order added!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Dashboard',
            onPressed: () {
              setState(() {
                // This will trigger a rebuild of the widget tree
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(context),
            const SizedBox(height: 24),
            _buildQuickStats(context),
            const SizedBox(height: 24),
            _buildRevenueChart(context),
            const SizedBox(height: 24),
            _buildRecentOrdersWithFilter(context),
            const SizedBox(height: 24),
            _buildPopularItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${_getTimeOfDay()}, Aling Nena',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Here\'s what\'s happening today',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Text(
                'AN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'morning';
    } else if (hour < 17) {
      return 'afternoon';
    } else {
      return 'evening';
    }
  }

  Widget _buildQuickStats(BuildContext context) {
    return Consumer<DashboardService>(
      builder: (context, dashboardService, child) {
        final colorScheme = Theme.of(context).colorScheme;

        // Format currency values
        final currencyFormat = NumberFormat.currency(
          symbol: '₱',
          decimalDigits: 2,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Quick Stats',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              childAspectRatio: 1.5,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _buildStatCard(
                  context,
                  Icons.payments_outlined,
                  'Today\'s Sales',
                  currencyFormat.format(dashboardService.todayRevenue),
                  '${dashboardService.newOrdersToday} orders',
                  colorScheme.primary,
                ),
                _buildStatCard(
                  context,
                  Icons.receipt_long_outlined,
                  'New Orders',
                  '${dashboardService.newOrdersToday}',
                  '${dashboardService.newOrdersThisWeek} this week',
                  colorScheme.secondary,
                ),
                _buildStatCard(
                  context,
                  Icons.people_outline,
                  'Customers',
                  '${dashboardService.todayCustomersCount}',
                  '${dashboardService.totalSales} items sold',
                  Colors.green,
                ),
                _buildStatCard(
                  context,
                  Icons.inventory_2_outlined,
                  'Total Revenue',
                  currencyFormat.format(dashboardService.totalRevenue),
                  'All time',
                  Colors.orange,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    return Consumer<DashboardService>(
      builder: (context, dashboardService, child) {
        // Get daily revenue data
        final dailyRevenue = dashboardService.getDailyRevenueLastWeek();

        // Convert the map to a list of FlSpot points
        final spots =
            dailyRevenue.entries.map((entry) {
              // Calculate days from now (0 is today, 1 is yesterday, etc.)
              final daysFromNow = DateTime.now().difference(entry.key).inDays;
              return FlSpot(6 - daysFromNow.toDouble(), entry.value);
            }).toList();

        // Format the dates for display
        final dateFormat = DateFormat('E'); // Format as "Mon", "Tue", etc.
        final bottomTitles = dailyRevenue.keys.toList();

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Last 7 days',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              );
                              String text;
                              switch (value.toInt()) {
                                case 0:
                                  text = '₱0';
                                  break;
                                case 5000:
                                  text = '₱5K';
                                  break;
                                case 10000:
                                  text = '₱10K';
                                  break;
                                case 15000:
                                  text = '₱15K';
                                  break;
                                default:
                                  return Container();
                              }
                              return Text(text, style: style);
                            },
                            reservedSize: 30,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final style = TextStyle(
                                color: Colors.grey[700],
                                fontSize: 10,
                              );
                              // Only display values at integer positions
                              if (value.toInt() != value) {
                                return Container();
                              }

                              // Convert value to index and get corresponding date
                              final index = value.toInt();
                              if (index < 0 || index >= bottomTitles.length) {
                                return Container();
                              }

                              final date =
                                  bottomTitles[bottomTitles.length - 1 - index];
                              return Text(
                                dateFormat.format(date),
                                style: style,
                              );
                            },
                            reservedSize: 20,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          preventCurveOverShooting: true,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.8),
                            ],
                          ),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      minY: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentOrdersWithFilter(BuildContext context) {
    return Consumer<DashboardService>(
      builder: (context, dashboardService, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Orders',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/orders');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),

            // Filter options
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  // Status filter dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: 'Status',
                      ),
                      value: _orderFilterStatus,
                      items:
                          [
                                'All',
                                'Pending',
                                'Processing',
                                'Delivered',
                                'Completed',
                                'Cancelled',
                              ]
                              .map(
                                (status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _orderFilterStatus = value;
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Time filter dropdown
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: 'Time Period',
                      ),
                      value: _orderTimeFilter,
                      items: [
                        const DropdownMenuItem(value: 1, child: Text('Today')),
                        const DropdownMenuItem(
                          value: 7,
                          child: Text('Last 7 days'),
                        ),
                        const DropdownMenuItem(
                          value: 30,
                          child: Text('Last 30 days'),
                        ),
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('All time'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _orderTimeFilter = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Orders list
            _buildRecentOrders(context),
          ],
        );
      },
    );
  }

  Widget _buildRecentOrders(BuildContext context) {
    return Consumer<DashboardService>(
      builder: (context, dashboardService, child) {
        // Apply filters
        DateTime? sinceDate;
        if (_orderTimeFilter > 0) {
          sinceDate = DateTime.now().subtract(Duration(days: _orderTimeFilter));
        }

        final recentOrders = dashboardService.getRecentOrders(
          limit: 5,
          status: _orderFilterStatus == 'All' ? null : _orderFilterStatus,
          since: sinceDate,
        );

        final currencyFormat = NumberFormat.currency(
          symbol: '₱',
          decimalDigits: 2,
        );
        final colorScheme = Theme.of(context).colorScheme;

        if (recentOrders.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try changing your filters or add new orders',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentOrders.length,
          itemBuilder: (context, index) {
            final order = recentOrders[index];

            // Determine color based on status
            Color statusColor;
            switch (order['status']) {
              case 'Completed':
                statusColor = Colors.green;
                break;
              case 'Processing':
                statusColor = Colors.blue;
                break;
              case 'Delivered':
                statusColor = colorScheme.secondary;
                break;
              case 'Cancelled':
                statusColor = Colors.red;
                break;
              case 'Pending':
              default:
                statusColor = Colors.orange;
            }

            // Get item details for showing what was ordered
            final orderDetails = order['orderDetails'] as List<dynamic>;
            final mainItemName =
                orderDetails.isNotEmpty
                    ? "${orderDetails[0]['name']}"
                    : "No items";

            // Show additional items count if there are more than one item
            final additionalItemsText =
                orderDetails.length > 1
                    ? " + ${orderDetails.length - 1} more"
                    : "";

            return Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Row(
                  children: [
                    // Use Flexible to prevent overflow with order ID
                    Flexible(
                      child: Text(
                        order['id'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order['status'] as String,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      order['customerName'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis for long names
                    ),
                    Text(
                      '$mainItemName$additionalItemsText',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Ensure this is only one line
                    ),
                  ],
                ),
                trailing: SizedBox(
                  width: 100, // Fixed width to prevent overflow
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        // Use FittedBox to scale down text if needed
                        fit: BoxFit.scaleDown,
                        child: Text(
                          currencyFormat.format(order['amount'] as double),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(order['date'] as DateTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Show order details dialog
                  _showOrderDetailsDialog(context, order);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showOrderDetailsDialog(
    BuildContext context,
    Map<String, dynamic> order,
  ) {
    final currencyFormat = NumberFormat.currency(symbol: '₱', decimalDigits: 2);

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Details',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${order['id']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer details
                        const Text(
                          'Customer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Text(
                              (order['customerName'] as String).isNotEmpty
                                  ? (order['customerName'] as String)[0]
                                      .toUpperCase()
                                  : '?',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(order['customerName'] as String),
                          subtitle: Text(
                            '${order['customerPhone']}\n${order['customerEmail']}',
                          ),
                        ),

                        const Divider(),

                        // Order status section with update option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<String>(
                              value: order['status'] as String,
                              items:
                                  [
                                        'Pending',
                                        'Processing',
                                        'Delivered',
                                        'Completed',
                                        'Cancelled',
                                      ]
                                      .map(
                                        (status) => DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (newStatus) {
                                if (newStatus != null &&
                                    newStatus != order['status']) {
                                  // Update the order status
                                  Provider.of<DashboardService>(
                                    context,
                                    listen: false,
                                  ).updateOrderStatus(
                                    order['id'] as String,
                                    newStatus,
                                  );

                                  // Close the dialog
                                  Navigator.pop(context);

                                  // Show confirmation
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Status updated to $newStatus',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Order details
                        Row(
                          children: [
                            Expanded(
                              child: _buildOrderDetailRow(
                                'Date',
                                DateFormat(
                                  'MMM d, yyyy, h:mm a',
                                ).format(order['date'] as DateTime),
                              ),
                            ),
                            Expanded(
                              child: _buildOrderDetailRow(
                                'Payment',
                                order['paymentMethod'] as String,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Order items
                        const Text(
                          'Items',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        ...((order['orderDetails'] as List<dynamic>).map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        item['imageUrl'] as String,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${item['quantity']}x ${item['name']}',
                                  ),
                                ),
                                Text(
                                  currencyFormat.format(item['total']),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                        const Divider(),

                        // Order summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text(
                              currencyFormat.format(
                                (order['amount'] as double) -
                                    (order['deliveryFee'] as double),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee'),
                            Text(currencyFormat.format(order['deliveryFee'])),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              currencyFormat.format(order['amount']),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPopularItems(BuildContext context) {
    return Consumer<DashboardService>(
      builder: (context, dashboardService, child) {
        final popularItems =
            dashboardService.getPopularItems().take(3).toList();
        final colorScheme = Theme.of(context).colorScheme;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Selling Items',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu-management');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularItems.length,
                itemBuilder: (context, index) {
                  final item = popularItems[index];
                  return Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(12),
                            ),
                            child: Image.asset(
                              item['image'] as String,
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 32,
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item['quantity']} orders',
                                    style: TextStyle(
                                      color: colorScheme.secondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Revenue: ₱${(item['revenue'] as double).toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (dateOnly == yesterday) {
      return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(date);
    }
  }
}
