import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Map placeholder
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(
                  'https://via.placeholder.com/600x400?text=Map+Location',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
                size: 48,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Address
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Location',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '123 Mabini Street, Poblacion, Metro Manila, Philippines',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Hours
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Opening Hours',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildHourRow('Monday - Friday', '10:00 AM - 10:00 PM'),
                  _buildHourRow('Saturday', '9:00 AM - 11:00 PM'),
                  _buildHourRow('Sunday', '9:00 AM - 9:00 PM'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Contact info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.phone, '+63 (2) 8123 4567'),
                  _buildContactRow(Icons.email, 'info@tindahannialingnena.com'),
                  _buildContactRow(
                    Icons.language,
                    'www.tindahannialingnena.com',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourRow(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(hours),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [Icon(icon, size: 18), const SizedBox(width: 12), Text(text)],
      ),
    );
  }
}
