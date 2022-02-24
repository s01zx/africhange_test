import 'dart:async';
import 'dart:convert';

import 'package:africhange_test/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CurrencyProvider with ChangeNotifier {
  Future<String> getConvertedValue(currencyCode) async {
    var url = Uri.parse(
        'http://data.fixer.io/api/latest?access_key=$ACCES_KEY&symbols=$currencyCode');

    try {
      var post = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Check your internet and try again!');
      });

      var response = json.decode(post.body);
      print(response);

      if (post.statusCode != 200) {
        throw Exception("Something went wrong");
      } else {
        return response["rates"]["$currencyCode"].toString();
      }
    } on Exception catch (e) {
      throw e;
    }
  }
}
