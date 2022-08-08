import 'package:flutter/cupertino.dart';
import 'AppColors.dart';
import 'package:intl/intl.dart' as intl;

class AppStyles {
  static const appBarStyle = TextStyle(color: AppColors.black);
  static const mainHeadingStyle = TextStyle(
    color: AppColors.black,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
  static const subHeadingStyle = TextStyle(
    color: AppColors.black,
    fontSize: 12,
  );
  static const secondaryHeadingStlye = TextStyle(
    fontSize: 16,
  );

  static const seeAllStyle = TextStyle(
    fontSize: 14,
  );

  //product card style
  static const cardNameStyle = TextStyle(fontSize: 12);
  static const cardPriceStyle = TextStyle(fontFamily: 'Roboto', fontSize: 12);

  //detail screen styles
  static const productNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );
  static const productPriceStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Roboto',
  );
  static const productQtyStyle = TextStyle(
    fontSize: 25,
    fontFamily: 'Roboto',
  );
  static const cartBtnStyle = TextStyle(fontSize: 16);

  //cart screen styles
  static const cartPriceStyle = TextStyle(fontFamily: 'Roboto', fontSize: 12);
  static const cartTotalPriceStyle =
      TextStyle(fontFamily: 'Roboto', fontSize: 14);
  static const cartQtyStyle = TextStyle(fontFamily: 'Roboto', fontSize: 14);
  static const grandTotalLabelStyle = TextStyle(
    fontSize: 20,
    color: AppColors.white,
  );
  static const grandTotalStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  //number formats
  static var deciPriceFormat = intl.NumberFormat('#,##0.00');
}
