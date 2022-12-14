import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/data/model/response/report_models.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/data/repository/admin_dashboard_repo.dart';
import 'package:product_buy_sell/helper/date_converter.dart';
import 'package:product_buy_sell/helper/secret_key.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class AdminDashboardProvider with ChangeNotifier {
  final AdminDashboardRepo adminDashboardRepo;

  AdminDashboardProvider({required this.adminDashboardRepo});

  String manufacturerDate = DateConverter.dateFormatStyle2(DateTime.now());
  DateTime manufacturerDateTime = DateTime.now();

  changeManufacturerDate(BuildContext context) async {
    var dateTime =
        await showDatePicker(context: context, initialDate: manufacturerDateTime, firstDate: DateTime(1980), lastDate: DateTime.now());
    if (dateTime != null) {
      manufacturerDateTime = dateTime;
      manufacturerDate = DateConverter.dateFormatStyle2(dateTime);
      notifyListeners();
    }
  }

  String expireDateText = DateConverter.dateFormatStyle2(DateTime.now());
  DateTime expireDate = DateTime.now();

  changeExpireDate(BuildContext context) async {
    var dateTime = await showDatePicker(context: context, initialDate: expireDate, firstDate: DateTime(1980), lastDate: DateTime.now());
    if (dateTime != null) {
      expireDate = dateTime;
      expireDateText = DateConverter.dateFormatStyle2(dateTime);
      notifyListeners();
    }
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int productID = 0;

  //TODO:: for Sign Up Section
  Future<bool> addProduct(ProductModel productModels, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    productID = productModels.productId!;
    FireStoreDatabaseHelper.addProduct(productModels);
    showMessage(context, message: 'Product added successfully', isError: false);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  //TODO:: for assignGovernmentProduct
  Future<bool> assignGovernmentProduct(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    FireStoreDatabaseHelper.assignProductOnDistributors(selectDistributors.phone!, productID.toString());
    showMessage(context, message: 'Product Assign successfully', isError: false);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  //TODO:: for assignProduct
  Future<bool> assignProduct(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    FireStoreDatabaseHelper.assignProducts(selectRetailer.phone!, selectDistributors.phone!, productID.toString());
    showMessage(context, message: 'Product Assign successfully', isError: false);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  //TODO:: for assignProductOnDistributors
  Future<bool> assignProductOnDistributors(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    FireStoreDatabaseHelper.assignProductOnDistributors(selectDistributors.phone!, productID.toString());
    showMessage(context, message: 'Product Assign successfully', isError: false);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  //TODO:: for assignProductOnRetailers
  Future<bool> assignProductOnRetailers(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    FireStoreDatabaseHelper.assignProductOnRetailers(selectRetailer.phone!, productID.toString());
    showMessage(context, message: 'Product Assign successfully', isError: false);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  updateProductID(int p) {
    productID = p;
  }

  //TODO: FOR get all users
  List<UserModels> distributorsLists = [];
  UserModels selectDistributors = UserModels();
  List<UserModels> retailerLists = [];
  UserModels selectRetailer = UserModels();

  getAllData() async {
    distributorsLists = await FireStoreDatabaseHelper.distributorsLists();
    selectDistributors = distributorsLists[0];
    notifyListeners();
  }

  getAllData1() async {
    retailerLists = await FireStoreDatabaseHelper.deliveryManLists();
    selectRetailer = retailerLists[0];
    notifyListeners();
  }

  changeDistributors(value) {
    selectDistributors = value;
    notifyListeners();
  }

  changeRetailers(value) {
    selectRetailer = value;
    notifyListeners();
  }

  Uint8List? imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  void captureScreenshot() async {
    final bytes = await screenshotController.captureFromWidget(qrCodeWidget());
    await saveImage(bytes);
  }

  Widget qrCodeWidget() {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: SfBarcodeGenerator(
        value: "Products_ ${encryptedText(productID.toString())}",
        symbology: QRCode(),
        showValue: true,
      ),
    );
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();

    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareXFiles([XFile(image.path)]);

    final time = DateTime.now().toIso8601String().replaceAll('.', '_').replaceAll(':', "_");
    final result = await ImageGallerySaver.saveImage(bytes, name: 'screenshot_$time');
    return result['filePath'];
  }

  UserModels deliveryManModels = UserModels();
  UserModels distributorsModels = UserModels();

  void getUserInfo(String deliveryManID, String distributorsID, String productID) async {
    _isLoading = true;
    productID = productID;
    // notifyListeners();
    deliveryManModels = UserModels();
    distributorsModels = UserModels();
    deliveryManModels = await FireStoreDatabaseHelper.getUserData(deliveryManID);
    distributorsModels = await FireStoreDatabaseHelper.getUserData(distributorsID);
    _isLoading = false;
    notifyListeners();
  }

  void getDistributorsDetails(String distributorsID, String p) async {
    _isLoading = true;
    productID = int.parse(p);
    distributorsModels = UserModels();
    distributorsModels = await FireStoreDatabaseHelper.getUserData(distributorsID);
    _isLoading = false;
    notifyListeners();
  }

  ProductModel productModel = ProductModel();
  bool isLoadingProduct = false;

  void getProducts(String productID) async {
    isLoadingProduct = true;
    productModel = ProductModel();
    productModel = await FireStoreDatabaseHelper.getProduct(productID);
    isLoadingProduct = false;
    notifyListeners();
  }

  List<ProductModel> products = [];

  void getDeliveryManProductInfo(String deliveryManID) async {
    _isLoading = true;
    products.clear();
    products = [];
    products.addAll(await FireStoreDatabaseHelper.getDeliveryManAssignProducts(deliveryManID));
    _isLoading = false;
    notifyListeners();
  }

  // Future<bool> updateProducts(int index, int status) async {
  //   _isLoading = true;
  //   try {
  //     await FireStoreDatabaseHelper.updateProductStatus(productID.toString(), status: status);
  //     products[index].status = status;
  //     _isLoading = false;
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<bool> verifiedByGovernmentProduct() async {
    _isLoading = true;
    try {
      await FireStoreDatabaseHelper.verifiedByGovernmentProduct(productID.toString());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifiedByRetailerProduct() async {
    _isLoading = true;
    try {
      await FireStoreDatabaseHelper.verifiedByRetailerProduct(productID.toString());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> confirmProduct(String productID, String customerID) async {
    _isLoading = true;
    try {
      await FireStoreDatabaseHelper.confirmProduct(productID, customerID);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  //TODO:: for Report Section
  Future<bool> addReport(ReportModels reportModels, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    FireStoreDatabaseHelper.addReports(reportModels);
    showMessage(context, message: 'Report added successfully', isError: false);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> updateReportStatus(int status, String productID) async {
    _isLoading = true;
    try {
      await FireStoreDatabaseHelper.updateReports(productID, status: status);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
