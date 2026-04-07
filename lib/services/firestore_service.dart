import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save daily health data
  Future<void> saveHealthData({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final today = DateTime.now();
    final dateId =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('health_data')
        .doc(dateId)
        .set({
      'steps': data['steps'] ?? 0,
      'calories': data['calories'] ?? 0,
      'distance': data['distance'] ?? 0,
      'date': dateId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}