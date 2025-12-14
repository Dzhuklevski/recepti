import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_summary.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = 'demo_user';

  Future<void> addFavorite(MealSummary meal) async {
    await _db
        .collection('favorites')
        .doc(userId)
        .collection('meals')
        .doc(meal.id)
        .set({
      'id': meal.id,
      'name': meal.name,
      'thumbnail': meal.thumb,
      'category': meal.category,
    });
  }

  Future<void> removeFavorite(String mealId) async {
    await _db
        .collection('favorites')
        .doc(userId)
        .collection('meals')
        .doc(mealId)
        .delete();
  }

  Stream<QuerySnapshot> getFavorites() {
    return _db
        .collection('favorites')
        .doc(userId)
        .collection('meals')
        .snapshots();
  }

  Stream<bool> isFavorite(String mealId) {
    return _db
        .collection('favorites')
        .doc(userId)
        .collection('meals')
        .doc(mealId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> toggleFavorite(MealSummary meal) async {
    final ref = _db
        .collection('favorites')
        .doc(userId)
        .collection('meals')
        .doc(meal.id);

    final snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.delete();
    } else {
      await addFavorite(meal);
    }
  }
}
