import 'package:astroguide_flutter/constants/constants.dart';
import 'package:astroguide_flutter/models/category_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryController extends GetxController {
  Rx<List<CategoryModel>> categories = Rx<List<CategoryModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  static var category;

  @override
  void onInit() {
    getAllCategories();
    super.onInit();
  }

  Future<void> getAllCategories() async {
    try {
      categories.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${url}category'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        print(response.body);
        isLoading.value = false;
        final content = json.decode(response.body)['category'];
        for (var item in content) {
          categories.value.add(CategoryModel.fromJson(item));
        }
        print('Total de categorías buscadas: ${categories.value.length}');
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}
