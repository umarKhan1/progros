import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/product/product_state.dart';
import 'package:progros/models/product_model.dart';


class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(const ProductsState());

  void init() {
    const products = [
      Product(id: '1',  title: 'Aashirvaad Shudh Aata',  image: 'https://images.bombaybasket.co.uk/cdn-cgi/image/format=auto/public/uploads/all/2023/05/202305051159571069751.jpeg', size: '10 kg', price: 12, compareAt: 14, isTrending: true,  isBestDeal: true),
      Product(id: '2',  title: 'Aashirwad Select Aata',  image: 'https://jalpurmillersonline.com/cdn/shop/products/aashirvaad-aashirvaad-whole-wheat-flour-sudh-chakki-atta-2kg-jalpur-millers-online_1000x.jpg?v=1665657205', size: '10 kg', price: 12, compareAt: 14, isTrending: true),
      Product(id: '3',  title: 'Fortune Fresh Atta',     image: 'https://jalpurmillersonline.com/cdn/shop/products/aashirvaad-aashirvaad-whole-wheat-flour-sudh-chakki-atta-2kg-jalpur-millers-online_1000x.jpg?v=1665657205', size: '5 kg',  price: 5,  compareAt: 8,  isBestDeal: true),
      Product(id: '4',  title: 'Mother Chakki Atta',     image: 'https://m.media-amazon.com/images/I/61EIj1hg6uL._UF1000,1000_QL80_.jpg', size: '10 kg', price: 8,  compareAt: 10),
      Product(id: '5',  title: 'Dhruvam Wheat Atta',     image: 'https://5.imimg.com/data5/SELLER/Default/2020/9/WG/FP/VK/99075044/atta-1000x1000.jpg', size: '5 kg',  price: 7,  compareAt: 10),
      Product(id: '6',  title: 'Fresh Ultimate Atta',    image: 'https://m.media-amazon.com/images/I/71b1A7MJYlL._UF1000,1000_QL80_.jpg', size: '5 kg',  price: 7,  compareAt: 10, isTrending: true),
      Product(id: '7',  title: 'Kisan Ghee',              image: 'https://greenvalley.pk/cdn/shop/files/kisan-desi-ghee-tin-16kg_5f3c1249-6632-454b-bab5-1f2483595b12.webp?v=1739455421',  size: '1 L',   price: 9.5),
      Product(id: '8',  title: 'Dettol Liquid',          image: 'http://images.apollo247.in/pub/media/catalog/product/d/e/det0004_1_1.jpg?tr=q-80,f-webp,w-400,dpr-3,c-at_max%201200w',size: '500 ml',price: 6.9),
      Product(id: '9',  title: 'Surf Excel Detergent',   image: 'https://bazaar5.com/image/cache/catalog/pro/product/apiData/b00u2due1a-surf-excel-quick-wash-detergent-powder-1-kg-washing-powder-with-lemon-bleach-to-remove-tough-stains-on-clothes-bucket-machine-wash-1-count-0-1000x1000.jpg',  size: '500 ml',price: 12, compareAt: 14),
      Product(id: '10', title: 'Fortune Arhar Dal',      image: 'https://nilagroceries.se/media/catalog/product/cache/4fd20ec0a0f667fe02ced0f72da734ae/f/o/fortune_toor_dal.png',   size: '1 kg',  price: 10, compareAt: 12, isBestDeal: true),
    ];
    emit(state.copyWith(all: products));
  }
}
