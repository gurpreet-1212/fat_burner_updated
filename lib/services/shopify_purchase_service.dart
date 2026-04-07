import 'package:cloud_functions/cloud_functions.dart';

/// Service to check if a user has purchased "Plant Protein" via Shopify.
/// Calls Firebase Cloud Function which securely queries Shopify API.
class ShopifyPurchaseService {
  ShopifyPurchaseService._();
  static final ShopifyPurchaseService instance = ShopifyPurchaseService._();

  final _functions = FirebaseFunctions.instance;

  /// Checks if the user has purchased "Plant Protein".
  /// Requires [email] or [phone] (or both).
  /// Returns true if the product was found in their Shopify order history.
  Future<bool> hasPurchasedPlantProtein({
    String? email,
    String? phone,
  }) async {
    if ((email == null || email.trim().isEmpty) &&
        (phone == null || phone.trim().isEmpty)) {
      throw ArgumentError('Provide at least one of: email, phone');
    }

    final callable = _functions.httpsCallable('checkPlantProteinPurchase');
    final result = await callable.call<Map<String, dynamic>>({
      if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
    });

    final data = result.data;
    if (!data.containsKey('purchased')) {
      return false;
    }
    return data['purchased'] as bool? ?? false;
  }
}
