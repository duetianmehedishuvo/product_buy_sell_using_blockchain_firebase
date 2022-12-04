import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:product_buy_sell/screens/distributors/search/search_screen.dart';
import 'package:product_buy_sell/util/helper.dart';
import 'package:product_buy_sell/widgets/custom_app_bar.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';

class QRSearchScreen extends StatefulWidget {
  const QRSearchScreen({super.key});

  @override
  State<QRSearchScreen> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRSearchScreen> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Env.themeColors['barColor'],
      appBar: buildAppBar('QR Search'),
      body: Stack(
        children: <Widget>[
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  child: MobileScanner(
                      allowDuplicates: false,
                      fit: BoxFit.cover,
                      controller: cameraController,
                      onDetect: (barcode, args) {
                        if (barcode.rawValue == null) {
                          debugPrint('Failed to scan Barcode');
                        } else {
                          final String code = barcode.rawValue!;
                          debugPrint('Barcode found! $code');
                          debugPrint('Barcode found! 2 ${code.substring(0, 9)}');
                          if (code.startsWith('Products_')) {
                            showMessage(context, message: 'Products Found', isError: false);
                          } else {
                            showMessage(context, message: 'Not Found');
                          }
                          Helper.toScreen(context, SearchScreen(code));
                          //Products_ EHgoqXWwxiEf4/WKWxwIB4GHbwMBfeXu
                          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SearchScreen(qrSearchData: code)));
                        }
                      })
                  // QRView(
                  //     key: qrKey,
                  //     onQRViewCreated: (controller) {
                  //       Provider.of<SearchProvider>(context, listen: false).onQRViewCreated(controller, context);
                  //     },
                  //     overlay: QrScannerOverlayShape())
                  )),
          Positioned(
            right: 0,
            child: IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
          ),
          Positioned(
            left: 0,
            child: IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
