import 'package:flutter/material.dart';
import '../data/upgrade_data.dart';

class UpgradeController extends ChangeNotifier {
  bool _isYearly = false;

  bool get isYearly => _isYearly;

  String get proPrice =>
      _isYearly ? UpgradeData.proPlan.yearlyPrice : UpgradeData.proPlan.monthlyPrice;

  String get proPriceLabel =>
      _isYearly
          ? 'Then ${UpgradeData.proPlan.yearlyPrice}/mo. Cancel anytime.'
          : 'Then ${UpgradeData.proPlan.monthlyPrice}/mo. Cancel anytime.';

  void toggleBillingPeriod(bool yearly) {
    if (_isYearly != yearly) {
      _isYearly = yearly;
      notifyListeners();
    }
  }
}
