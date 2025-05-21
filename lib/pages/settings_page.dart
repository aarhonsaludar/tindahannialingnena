import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  String _taxRate = '12';
  String _currency = '₱';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        // This line ensures the hamburger menu icon is visible and will open the drawer
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colorScheme.primary,
                    child: const Text(
                      'AN',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aling Nena',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Restaurant Owner',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    onPressed: () {
                      // Navigate to profile editing
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Restaurant settings
          _buildSettingsSection(context, 'Restaurant Settings', [
            ListTile(
              title: const Text('Restaurant Name'),
              subtitle: const Text('Tindahan Ni Aling Nena'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Edit restaurant name
              },
            ),
            ListTile(
              title: const Text('Contact Information'),
              subtitle: const Text('+63 (2) 8123 4567'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Edit contact info
              },
            ),
            ListTile(
              title: const Text('Opening Hours'),
              subtitle: const Text('10:00 AM - 10:00 PM'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Edit opening hours
              },
            ),
            ListTile(
              title: const Text('Table Layout'),
              subtitle: const Text('12 Tables'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Edit table layout
              },
            ),
          ]),

          const SizedBox(height: 16),

          // Financial settings
          _buildSettingsSection(context, 'Financial Settings', [
            ListTile(
              title: const Text('Currency Symbol'),
              subtitle: Text(_currency),
              trailing: DropdownButton<String>(
                value: _currency,
                underline: Container(),
                items:
                    ['₱', '\$', '€', '£'].map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currency = newValue;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Tax Rate (%)'),
              subtitle: Text('$_taxRate%'),
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  controller: TextEditingController(text: _taxRate),
                  decoration: const InputDecoration(
                    suffixText: '%',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _taxRate = value;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text('Payment Methods'),
              subtitle: const Text('Cash, Cards, GCash'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Edit payment methods
              },
            ),
          ]),

          const SizedBox(height: 16),

          // Notifications
          _buildSettingsSection(context, 'Notifications', [
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text(
                'Receive alerts for new orders and important updates',
              ),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Sound'),
              subtitle: const Text('Play sound for new orders and alerts'),
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
              },
            ),
          ]),

          const SizedBox(height: 16),

          // About and support
          _buildSettingsSection(context, 'About & Support', [
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to help
              },
            ),
            ListTile(
              leading: const Icon(Icons.policy_outlined),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show privacy policy
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show terms of service
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              subtitle: const Text('Version 1.0.0'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show about dialog
              },
            ),
          ]),

          const SizedBox(height: 24),

          // Logout button
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            onPressed: () {
              // Confirm and logout
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Divider(height: 0),
          ...children,
        ],
      ),
    );
  }
}
