import '../models/models.dart';
import '../services/api_client.dart';

class ProductRepository {
  ProductRepository(this._client);
  final ApiClient _client;

  Future<List<Product>> getProducts() async {
    final data =
        await _client.request('GET', '/products') as Map<String, dynamic>;
    return (data['products'] as List<dynamic>? ?? [])
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
