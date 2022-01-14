import 'package:flutter/cupertino.dart';
import 'package:spawos_shopx/model/product_model.dart';
import 'package:http/http.dart' as http;

class HomeProvider with ChangeNotifier{
late bool _error;
late String _message;
bool _isLoading=true;
late List<ProductModel> _productModel;

//getters
  bool get error=>_error;
  String get message=>_message;
  bool get isLoading=>_isLoading;
  List<ProductModel> get productModel=>_productModel;


  Future<void> getProductData()async{
    String url='https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline';
    try{
      var response=await http.get(Uri.parse(url));
      if(response.statusCode==200) {
        print(response.body);
        _isLoading = false;
        _error = false;
        _productModel = productModelFromJson(response.body);
      }
        else{
       _isLoading=false;
       _error=true;
       _message=response.reasonPhrase!;
       _productModel=[];
      }
    }catch(e){
      _error=true;
      _isLoading=false;
      _message=e.toString();
    }
    notifyListeners();
  }
}