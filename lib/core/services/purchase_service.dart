/// Stub for in-app purchase functionality.
/// Replace with actual IAP implementation when ready.
class PurchaseService {
  bool _isPremium = false;

  bool get isPremium => _isPremium;

  Future<void> initialize() async {
    // Stub: No real IAP initialization
  }

  Future<bool> purchasePremium() async {
    // Stub: Simulate successful purchase
    _isPremium = true;
    return true;
  }

  Future<bool> restorePurchases() async {
    // Stub: Simulate restore
    _isPremium = false;
    return false;
  }

  void dispose() {
    // Cleanup
  }
}
