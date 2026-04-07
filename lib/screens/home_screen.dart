import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool takenToday = false;

  @override
  void initState() {
    super.initState();
    _loadTodayStatus();
  }

  /// 🔥 Load today's checkbox state from Firestore
  Future<void> _loadTodayStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final todayDoc = DateTime.now().toString().substring(0, 10);

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("daily")
        .doc(todayDoc)
        .get();

    if (doc.exists) {
      setState(() {
        takenToday = doc.data()?["fatBurnerTaken"] ?? false;
      });
    }
  }

  /// 🔥 Save checkbox state
  Future<void> _updateStatus(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final todayDoc = DateTime.now().toString().substring(0, 10);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("daily")
        .doc(todayDoc)
        .set({
      "fatBurnerTaken": value,
      "timestamp": Timestamp.now(),
    });

    setState(() {
      takenToday = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Image.asset("images/Betteralt_main_logo.jpeg", height: 28),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 👋 Greeting
            Text(
              "Hello ${user?.displayName ?? "User"} 👋",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// 🧪 Fat Burner Card
            _fatBurnerCard(),

            const SizedBox(height: 24),

            /// 📊 Title
            const Text(
              "Today's Summary",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 12),

            /// 📊 Cards
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    "Steps",
                    "1240",
                    Icons.directions_walk,
                    0.6,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoCard(
                    "Calories",
                    "320",
                    Icons.local_fire_department,
                    0.4,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    "Sleep",
                    "7.5h",
                    Icons.bed,
                    0.75,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoCard(
                    "Weight",
                    "72kg",
                    Icons.monitor_weight,
                    0.5,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🧪 Fat Burner Card (UPGRADED)
  Widget _fatBurnerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [

          /// 🖼 Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "images/fat_burner.jpeg",
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 16),

          /// 🧾 Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fat Burner",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  takenToday ? "Taken today ✅" : "Not taken yet",
                  style: TextStyle(
                    color: takenToday ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// 🔘 Switch (better UX)
          Switch(
            value: takenToday,
            activeColor: Colors.green,
            onChanged: _updateStatus,
          ),
        ],
      ),
    );
  }

  /// 📊 Info Card (FIXED + UPGRADED)
  Widget _infoCard(
    String title,
    String value,
    IconData icon,
    double progress,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Icon(icon, color: color),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}