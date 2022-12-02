import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:product_buy_sell/data/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/data/model/response/Product_model.dart';
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

  //TODO:: for Sign Up Section
  Future<bool> assignProduct(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    FireStoreDatabaseHelper.assignProducts(selectDeliveryMan.phone!, selectDistributors.phone!, productID.toString());
    showMessage(context, message: 'Product Assign successfully', isError: false);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  //TODO: FOR get all users
  List<UserModels> distributorsLists = [];
  UserModels selectDistributors = UserModels();
  List<UserModels> deliveryManLists = [];
  UserModels selectDeliveryMan = UserModels();

  getAllData() async {
    distributorsLists = await FireStoreDatabaseHelper.distributorsLists();
    selectDistributors = distributorsLists[0];
    deliveryManLists = await FireStoreDatabaseHelper.deliveryManLists();
    selectDeliveryMan = deliveryManLists[0];
    notifyListeners();
  }

  changeDistributors(value) {
    selectDistributors = value;
    notifyListeners();
  }

  changeDeliveryMan(value) {
    selectDeliveryMan = value;
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

  void getUserInfo(String deliveryManID, String distributorsID,String productID) async {
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
}
