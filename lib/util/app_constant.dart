//constant key
import 'package:product_buy_sell/data/model/response/language_model.dart';

class AppConstant {
  // API BASE URL
  static const String baseUrl = 'https://evue.in/hirecharge/api/';
  static const String imageBaseUrl = 'https://evue.in/hirecharge/images/';
  static const String loginURI = 'login';
  static const String signUPURI = 'register';
  static const String logoutURI = 'logout';
  static const String countTotalCustomer = 'countTotalCustomer';
  static const String countSignupCustomerByDate = 'countSignupCustomerByDate';
  static const String getAllUserByDate = 'getAllUserByDate';
  static const String countCustomerDontPermission = 'countCustomerDontPermission';
  static const String getCustomerDontPermission = 'getCustomerDontPermission';
  static const String userURI = 'allUser';
  static const String updateUserStatus = 'updateUserStatus';
  static const String updateAdminInformation = 'updateAdminInformation';
  static const String addSliderImage = 'addSliderImage';
  static const String addSliderText = 'addSliderText';
  static const String getSlideAndText = 'getSlideAndText';
  static const String deleteSliderText = 'deleteSliderText';
  static const String deleteSliderImage = 'deleteSliderImage';
  static const String updateRunningTextInfo = 'updateRunningTextInfo';
  static const String getSliderData = 'getSliderData';
  static const String getRunningTextSliderData = 'getRunningTextSliderData';


  static const String userByIDURI = 'getUserByID?userID=';
  static const String customerByIDURI = 'customerByID?customer_id=';
  static const String transactionByIDURI = 'getTranactionById';
  static const String transactionURI = 'getAllTranaction';
  static const String meterURI = 'meter';
  static const String deleteCustomerURI = 'deleteCustomer?customer_id=';
  static const String updateCustomerURI = 'customerUpdate';
  static const String addCustomerURI = 'addCustomer';
  static const String addTransactionURI = 'addTranaction';
  static const String updateTransactionURI = 'updateTransaction';
  static const String meterByIDURI = 'meterByID?meterID=';
  static const String deleteMeterBYIDURI = 'deletemeterByID?meterID=';
  static const String deleteTransactionBYIDURI = 'deleteTransaction?id=';
  static const String meterUpdateURI = 'meterUpdate';
  static const String customerURI = 'allCustomer';
  static const String userGetURI = 'user';
  static const String updateUserURI = 'updateUser';
  static const String forgotPasswordURI = 'changePassword';
  // Shared Key
  static const String theme = 'theme';
  static const String light = 'light';
  static const String dark = 'dark';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String userAddress = 'userID';
  static const String name = 'username';
  static const String apiKey = 'Id4YNMmoieLj4OcBDgZteG9VItleQnba4gS';
  static const String userType = 'useremail';
  static const String phone = 'phone';
  static const String postTypeGroup = 'group';
  static const String postTypeTimeline = 'timeline';

  static List<LanguageModel> languagesList = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'Bangla', countryCode: 'BD', languageCode: 'bn'),
  ];
}
