import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/shared_app_bar.dart';
import '../utils/user_session.dart';
import '../models/user_model.dart';
import 'edit_profile_page.dart'; // Add this import

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Consumer<UserSession>(
        builder: (context, userSession, _) {
          final currentUser = userSession.currentUser;

          // Handle case where no user is logged in
          if (currentUser == null) {
            return _buildNotLoggedInView(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // User avatar
                _buildUserAvatar(context, currentUser),

                const SizedBox(height: 16),

                // User name
                Text(
                  currentUser.name,
                  style: Theme.of(context).textTheme.displaySmall,
                ),

                const SizedBox(height: 4),

                // User email
                Text(
                  currentUser.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                // User type badge
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: currentUser.userColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    userSession.isAdmin
                        ? 'Administrator'
                        : userSession.isCustomer
                        ? 'Customer'
                        : 'Guest',
                    style: TextStyle(
                      color: currentUser.userColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // User details card
                _buildUserDetailsCard(context, currentUser),

                const SizedBox(height: 24),
                const Divider(),

                // Profile options
                _buildProfileOption(
                  context,
                  Icons.history,
                  'Order History',
                  () {
                    Navigator.pushNamed(context, '/order-history');
                  },
                ),

                if (!userSession.isAdmin)
                  _buildProfileOption(
                    context,
                    Icons.favorite,
                    'Favorites',
                    () {},
                  ),

                _buildProfileOption(
                  context,
                  Icons.credit_card,
                  'Payment Methods',
                  () {},
                ),

                if (!userSession.isAdmin)
                  _buildProfileOption(
                    context,
                    Icons.local_shipping,
                    'Delivery Addresses',
                    () {},
                  ),

                _buildProfileOption(context, Icons.settings, 'Settings', () {}),

                const Divider(),

                // Logout button
                _buildProfileOption(
                  context,
                  Icons.exit_to_app,
                  'Logout',
                  () async {
                    // Log out the user
                    await userSession.logout();
                    // Return to login screen
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  textColor: Colors.red,
                  iconColor: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Not Logged In',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'Please log in to view your profile',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context, User currentUser) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: currentUser.userColor,
          backgroundImage:
              currentUser.profileImage != null
                  ? NetworkImage(currentUser.profileImage!)
                  : null,
          child:
              currentUser.profileImage == null
                  ? Text(
                    currentUser.initials,
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  )
                  : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(currentUser.userIcon, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildUserDetailsCard(BuildContext context, User currentUser) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Phone number
            if (currentUser.phoneNumber != null) ...[
              _buildInfoRow(
                context,
                Icons.phone,
                'Phone',
                currentUser.phoneNumber!,
              ),
              const SizedBox(height: 12),
            ],

            // Address
            if (currentUser.address != null) ...[
              _buildInfoRow(
                context,
                Icons.home,
                'Address',
                currentUser.address!,
              ),
              const SizedBox(height: 12),
            ],

            // Joined date - placeholder since this isn't in the user model yet
            _buildInfoRow(
              context,
              Icons.calendar_today,
              'Member Since',
              'January 2023', // This would come from the user model in a real app
            ),

            const SizedBox(height: 16),

            // Edit profile button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to edit profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
