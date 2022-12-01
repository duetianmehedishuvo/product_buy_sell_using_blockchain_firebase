import 'package:flutter/foundation.dart';

class ZakatProvider with ChangeNotifier {
  double totalZakat = 0;
  double totalAssets = 0;
  double onadoyjoggo = 0;

  calculateZakat(
      {double cash = 0.0,
      double bankColti = 0.0,
      double bankDeposit = 0.0,
      double shareBenefit = 0.0,
      double gold = 0.0,
      double silver = 0.0,
      double assets = 0.0,
      double dueGetMoney = 0.0,
      double otherGetMoney = 0.0,
      double serviceCostMoney = 0.0,
      double badCredit = 0.0,
      double goldMarketPrice = 1.0,
      double silverMarketPrice = 1.0}) {
    totalAssets = cash + bankDeposit + bankColti + shareBenefit + assets + dueGetMoney + gold * goldMarketPrice + silver * silverMarketPrice;
    onadoyjoggo = serviceCostMoney + badCredit;

    totalZakat = totalAssets - onadoyjoggo;

    totalZakat *= 0.025;

    notifyListeners();
  }
}
