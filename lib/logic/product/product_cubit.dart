import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/product/product_state.dart';
import 'package:progros/models/product_model.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(const ProductsState());

  void init() {
    const products = [
      // Atta, Rice & Dal
      Product(
        id: 'atta1',
        title: 'Aashirvaad Shudh Aata',
        image:
            'https://images.bombaybasket.co.uk/cdn-cgi/image/format=auto/public/uploads/all/2023/05/202305051159571069751.jpeg',
        size: '10 kg',
        price: 12,
        compareAt: 14,
        isTrending: true,
        isBestDeal: true,
        categoryId: 'atta_rice_dal',
        subCategoryId: 'atta',
      ),
      Product(
        id: 'dal1',
        title: 'Fortune Arhar Dal',
        image:
            'https://nilagroceries.se/media/catalog/product/cache/4fd20ec0a0f667fe02ced0f72da734ae/f/o/fortune_toor_dal.png',
        size: '1 kg',
        price: 10,
        compareAt: 12,
        isBestDeal: true,
        categoryId: 'atta_rice_dal',
        subCategoryId: 'dal',
      ),
      Product(
        id: 'rice1',
        title: 'India Gate Basmati Rice',
        image:
            'https://www.bigbasket.com/media/uploads/p/l/40075597_2-india-gate-basmati-rice-mogra.jpg',
        size: '5 kg',
        price: 15,
        categoryId: 'atta_rice_dal',
        subCategoryId: 'rice',
      ),
      // Vegetables & Fruits
      Product(
        id: 'veg1',
        title: 'Fresh Tomatoes',
        image:
            'https://images.pexels.com/photos/53588/tomatoes-vegetables-food-frisch-53588.jpeg',
        size: '1 kg',
        price: 2.5,
        categoryId: 'veg_fruits',
        subCategoryId: 'fresh_vegetables',
      ),
      Product(
        id: 'fruit1',
        title: 'Fresh Apples',
        image:
            'https://previews.123rf.com/images/btk1977/btk19771206/btk1977120600004/13900514-fresh-strawberries-isolated-on-white-background.jpg',
        size: '1 kg',
        price: 3.5,
        categoryId: 'veg_fruits',
        subCategoryId: 'fresh_fruits',
      ),
      // Dairy & Breakfast
      Product(
        id: 'dairy1',
        title: 'Amul Butter',
        image:
            'https://www.jiomart.com/images/product/original/490000074/amuls-butter-500-g-carton-product-images-o490000074-p490000074-0-202203170234.jpg',
        size: '500 g',
        price: 4.5,
        categoryId: 'dairy_breakfast',
        subCategoryId: '',
      ),
      // Cold Drinks & Juices
      Product(
        id: 'drink1',
        title: 'Coca Cola',
        image:
            'https://www.coca-cola.com/content/dam/onexp/gb/en/brands/coca-cola/coca-cola-original-taste-330ml-can.png',
        size: '330 ml',
        price: 1.2,
        categoryId: 'cold_drinks',
        subCategoryId: '',
      ),
      // Instant & Frozen Food
      Product(
        id: 'frozen1',
        title: 'Frozen Peas',
        image:
            'https://www.bigbasket.com/media/uploads/p/l/40075597_2-india-gate-basmati-rice-mogra.jpg',
        size: '500 g',
        price: 2,
        categoryId: 'instant_frozen',
        subCategoryId: '',
      ),
      // Masala, Oil & Dry Fruits
      Product(
        id: 'oil1',
        title: 'Kisan Ghee',
        image:
            'https://greenvalley.pk/cdn/shop/files/kisan-desi-ghee-tin-16kg_5f3c1249-6632-454b-bab5-1f2483595b12.webp?v=1739455421',
        size: '1 L',
        price: 9.5,
        categoryId: 'masala_oil_dryfruits',
        subCategoryId: 'oil_ghee',
      ),
      // Chicken, Meat & Fish
      Product(
        id: 'meat1',
        title: 'Fresh Chicken',
        image:
            'https://5.imimg.com/data5/WI/ZZ/OL/ANDROID-81993397/product-jpeg-500x500.jpg',
        size: '1 kg',
        price: 7.5,
        categoryId: 'meat_fish',
        subCategoryId: '',
      ),
    ];
    emit(state.copyWith(all: products));
  }
  List<Product> byCategory(String categoryId) =>
      state.all.where((p) => p.categoryId == categoryId).toList();
  List<Product> bySubCategory(String subCategoryId) =>
      state.all.where((p) => p.subCategoryId == subCategoryId).toList();
}
