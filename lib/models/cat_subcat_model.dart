class SubCategory {
  const SubCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryId,
  });
  final String id;
  final String name;
  final String image;
  final String categoryId;
}

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.image,
    this.subs = const [],
  });
  final String id;
  final String name;
  final String image;
  final List<SubCategory> subs;
}

// Global category data with embedded subcategories
const categories = <Category>[
  Category(
    id: 'veg_fruits',
    name: 'Vegetables & Fruits',
    image: 'https://img.freepik.com/premium-vector/multiple-vegetables-set-realistic-vector-illustration-design_263274-278.jpg?semt=ais_hybrid&w=740&q=80',
    subs: [
      SubCategory(
        id: 'fresh_vegetables',
        name: 'Fresh Vegetables',
        image: 'https://img.freepik.com/premium-vector/multiple-vegetables-set-realistic-vector-illustration-design_263274-278.jpg?semt=ais_hybrid&w=740&q=80',
        categoryId: 'veg_fruits',
      ),
      SubCategory(
        id: 'fresh_fruits',
        name: 'Fresh Fruits',
        image: 'https://t4.ftcdn.net/jpg/00/53/14/41/360_F_53144147_Zx2dgnSeefxIjOQ5cjD4PBdZF4m8M7sm.jpg',
        categoryId: 'veg_fruits',
      ),
      SubCategory(
        id: 'seasonal',
        name: 'Seasonal',
        image: 'https://img.freepik.com/premium-photo/red-apple-fruit-with-green-leaf-isolated-white-with-clipping-path_252965-317.jpg',
        categoryId: 'veg_fruits',
      ),
      SubCategory(
        id: 'exotics',
        name: 'Exotics',
        image: 'https://thumbs.dreamstime.com/b/realistic-illustration-bunch-bananas-isolated-white-background-banana-icon-banana-image-vector-94314392.jpg',
        categoryId: 'veg_fruits',
      ),
      SubCategory(
        id: 'sprouts',
        name: 'Sprouts',
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXUbyi-U6-cW9Ek0kVUDHvRDgFxhIc0wtDw&s',
        categoryId: 'veg_fruits',
      ),
      SubCategory(
        id: 'leafies',
        name: 'Leafies & Herbs',
        image: 'https://previews.123rf.com/images/btk1977/btk19771206/btk1977120600004/13900514-fresh-strawberries-isolated-on-white-background.jpg',
        categoryId: 'veg_fruits',
      ),
    ],
  ),
  Category(
    id: 'atta_rice_dal',
    name: 'Atta, Rice & Dal',
    image: 'https://img.freepik.com/premium-photo/basmati-rice-with-dal-curry-white-background-generative-ai_21085-39382.jpg',
    subs: [
      SubCategory(
        id: 'atta',
        name: 'Atta',
        image: 'https://organicmandya.com/cdn/shop/files/Wheat_Chakki_Atta_4de093d4-3d5d-45a3-80cd-3c4448039e5b.jpg?v=1745404392&width=1000',
        categoryId: 'atta_rice_dal',
      ),
      SubCategory(
        id: 'rice',
        name: 'Rice',
        image: 'https://www.health.com/thmb/a8GxwWgmB5KpQW8SfW6VA7UFwaI=/722x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-1734160670-0157c2daf8e841d6a783b38aedc51aa8.jpg',
        categoryId: 'atta_rice_dal',
      ),
      SubCategory(id: 'dal', name: 'Dal', image: 'https://upload.wikimedia.org/wikipedia/commons/f/f5/3_types_of_lentil.png', categoryId: 'atta_rice_dal'),
    ],
  ),
  Category(
    id: 'dairy_breakfast',
    name: 'Dairy & Breakfast',
    image: 'https://domf5oio6qrcr.cloudfront.net/medialibrary/9685/iStock-544807136.jpg',
      subs: [
      SubCategory(
        id: 'milk',
        name: 'Milk',
        image: 'https://st2.depositphotos.com/16122460/42446/i/450/depositphotos_424463870-stock-photo-jug-glass-fresh-milk-white.jpg',
        categoryId: 'dairy_breakfast',
      ),
      SubCategory(
        id: 'butter',
        name: 'Butter',
        image: 'https://img.freepik.com/free-vector/yellow-stick-butter-cutting-board-margarine-spread-natural-dairy-product_1441-1686.jpg',
        categoryId: 'dairy_breakfast',
      ),
    ],
  ),
  Category(
    id: 'cold_drinks',
    name: 'Cold Drinks & Juices',
    image: 'https://toppng.com/uploads/preview/cold-drinks-2lt-cool-drinks-images-115628511849erk9ca1lw.png',
    subs: [
      SubCategory(
        id: 'soda',
        name: 'Soda',
        image: 'https://toppng.com/uploads/preview/cold-drinks-2lt-cool-drinks-images-115628511849erk9ca1lw.png',
        categoryId: 'cold_drinks',
      ),
      SubCategory(
        id: 'juice',
        name: 'Juice',
        image: 'https://media.istockphoto.com/id/158268808/photo/fresh-citrus-juices.jpg?s=612x612&w=0&k=20&c=vflsrO3KXXtWfpOOzNZdBVgeIpLy21-OSUl-QPSgPmU=',
        categoryId: 'cold_drinks',
      ),
    ],
  ),
  Category(
    id: 'instant_frozen',
    name: 'Instant & Frozen Food',
    image: 'https://media.istockphoto.com/id/507755834/photo/raw-turkey.jpg?s=612x612&w=0&k=20&c=nRFy7172rBp5QbFtC8qfYQBi0_Pt46sRXLXHcw_9Xa0=',
    subs: [
      SubCategory(
        id: 'frozen_veg',
        name: 'Frozen Veg',
        image: 'https://assets.digitalcontent.marksandspencer.app/image/upload/w_1920,q_auto,c_fill,f_auto/4409f214d5ea2c0e1b862fec5fd5d309.jpg',
        categoryId: 'instant_frozen',
      ),
      SubCategory(
        id: 'ready_meals',
        name: 'Ready Meals',
        image: 'https://i.dailymail.co.uk/i/pix/scaled/2015/03/03/264A46E100000578-0-image-a-9_1425424869502.jpg',
        categoryId: 'instant_frozen',
      ),
    ],
  ),
  Category(
    id: 'tea_coffee',
    name: 'Tea & Coffee',
    image: 'https://i.pinimg.com/736x/5c/1f/be/5c1fbed638d110acbdfdcfff0bb26d95.jpg',
    subs: [
      SubCategory(
        id: 'tea',
        name: 'Tea',
        image: 'https://img.freepik.com/premium-photo/cup-green-tea-with-leaves-white-background_787273-2374.jpg',
        categoryId: 'tea_coffee',
      ),
      SubCategory(
        id: 'coffee',
        name: 'Coffee',
        image: 'https://st.depositphotos.com/2363887/2571/i/450/depositphotos_25717699-stock-photo-cappuccino-mug-close-up-with.jpg',
        categoryId: 'tea_coffee',
      ),
    ],
  ),
  Category(
    id: 'masala_oil_dryfruits',
    name: 'Masala, Oil & Dry Fruits',
    image: 'https://nazarjanssupermarket.com/cdn/shop/files/kisan-super-cooking-oil-3ltr-nazar-jan-s-supermarket_large.png?v=1715264280g',
    subs: [

      SubCategory(
        id: 'oil',
        name: 'Oil',
        image: 'https://graficsea.com/wp-content/uploads/2022/01/Kisan-Sun-Flower-Cooking-Oil-Dabba.jpg',
        categoryId: 'masala_oil_dryfruits',
      ),
    
    ],
  ),
  Category(
    id: 'meat_fish',
    name: 'Chicken, Meat & Fish',
    image: 'https://5.imimg.com/data5/WI/ZZ/OL/ANDROID-81993397/product-jpeg-500x500.jpg',
    subs: [
      SubCategory(
        id: 'chicken',
        name: 'Chicken',
        image: 'https://5.imimg.com/data5/WI/ZZ/OL/ANDROID-81993397/product-jpeg-500x500.jpg',
        categoryId: 'meat_fish',
      ),
  
    ],
  ),
];
