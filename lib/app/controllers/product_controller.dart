import 'package:get/get.dart';
import '../data/models/models.dart';
import '../data/repositories/product_repository.dart';
import '../data/services/api_client.dart';

class ProductController extends GetxController {
  ProductController(this._repository);
  final ProductRepository _repository;
  final products = <Product>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      products.assignAll(await _repository.getProducts());
    } on ApiException catch (exception) {
      error.value = exception.message;
    } catch (_) {
      error.value = 'Unable to load products.';
    } finally {
      isLoading.value = false;
    }
  }
}
