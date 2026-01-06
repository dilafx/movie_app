import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {}, // Navigate to full settings if needed
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- USER BASICS ---
            _buildProfileHeader(),
            const SizedBox(height: 20),

            // --- ACHIEVEMENTS / STATS ---
            _buildStatsRow(),
            const SizedBox(height: 30),

            // --- WATCH HISTORY ---
            _buildSectionTitle('Continue Watching'),
            _buildHorizontalVideoList(),
            const SizedBox(height: 20),

            // --- MY LISTS ---
            _buildSectionTitle('My Lists'),
            _buildMyListsSection(),
            const SizedBox(height: 20),

            // --- PREFERENCES & SETTINGS ---
            _buildSectionTitle('Account & Settings'),
            _buildSettingsList(context),

            // --- LOGOUT ---
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 1. Profile Header (Avatar, Name, Membership)
  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?img=11',
          ), // Placeholder image
          backgroundColor: Colors.grey,
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'John Doe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'john.doe@example.com',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber, // Premium Gold Color
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Premium Member',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Stats Row (Movies Watched, Hours, etc.)
  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Watched', '124', Icons.movie),
          _buildStatItem('Hours', '305', Icons.access_time),
          _buildStatItem('Reviews', '18', Icons.star),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurpleAccent, size: 30),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // 3. Horizontal Video List (Continue Watching)
  Widget _buildHorizontalVideoList() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 240,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[800],
              image: const DecorationImage(
                image: NetworkImage(
                  'https://placehold.co/600x400/1a1a1a/ffffff?text=Movie+Still',
                ), // Placeholder
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sci-Fi Movie ${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: 0.4 + (index * 0.1),
                          backgroundColor: Colors.white24,
                          color: Colors.deepPurpleAccent,
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 4. My Lists Section
  Widget _buildMyListsSection() {
    return Column(
      children: [
        _buildListTile(Icons.favorite, 'Favorites', '32 Movies', Colors.pink),
        _buildListTile(Icons.bookmark, 'Watchlist', '12 Movies', Colors.blue),
        _buildListTile(
          Icons.history,
          'Recently Watched',
          'View History',
          Colors.orange,
        ),
      ],
    );
  }

  // 5. Settings List
  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          Icons.download_rounded,
          'Downloads',
          '2.4 GB Used',
          Colors.green,
        ),
        _buildListTile(
          Icons.tune,
          'Preferences',
          'Genre, Language',
          Colors.purple,
        ),
        _buildListTile(
          Icons.notifications,
          'Notifications',
          'On',
          Colors.yellow,
        ),
      ],
    );
  }

  // Helper for List Tiles
  Widget _buildListTile(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: () {},
      ),
    );
  }

  // Helper for Section Titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
