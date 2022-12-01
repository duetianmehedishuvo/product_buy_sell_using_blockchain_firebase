import 'package:flutter/foundation.dart';
import 'package:product_buy_sell/data/repository/admin_dashboard_repo.dart';

class AdminDashboardProvider with ChangeNotifier {
  final AdminDashboardRepo adminDashboardRepo;

  AdminDashboardProvider({required this.adminDashboardRepo});

  bool _isLoading = false;

}
