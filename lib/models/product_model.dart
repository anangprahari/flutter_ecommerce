import 'package:flutter/material.dart';

class Review {
  final String username;
  final String content;
  final double rating;

  Review({
    required this.username,
    required this.content,
    required this.rating,
  });
}

class Product {
  final String title;
  final String description;
  final String image;
  final String review;
  final String seller;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final List<Color> colors;
  final List<String> sizes;
  final String category;
  final double rate;
  final int reviewCount;
  final bool freeShipping;
  final bool returns30Days;
  final bool warranty;
  int quantity;
  final List<String> specifications;
  final List<Review> reviews;

  Product({
    required this.title,
    required this.review,
    required this.description,
    required this.image,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.colors,
    required this.seller,
    required this.category,
    required this.rate,
    required this.quantity,
    this.sizes = const ["S", "M", "L", "XL"],
    this.reviewCount = 0,
    this.freeShipping = false,
    this.returns30Days = false,
    this.warranty = false,
    this.specifications = const [],
    this.reviews = const [],
  });
}

final List<Product> all = [
  Product(
    title: "Premium Wireless Headphones with Noise Cancellation",
    description:
        "Experience premium sound quality with our wireless headphones featuring advanced noise cancellation technology. Perfect for music enthusiasts and professionals alike. These headphones deliver crystal-clear audio and exceptional comfort for extended listening sessions.",
    image: "images/all/wireless.png",
    price: 199.99,
    originalPrice: 249.99,
    discountPercentage: 20,
    seller: "Skullcandy",
    colors: [Colors.black, Colors.blue, Colors.red],
    sizes: ["S", "M", "L", "XL"],
    category: "Electronics",
    review: "(20 reviews)",
    rate: 4.5,
    reviewCount: 2100,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Active Noise Cancellation",
      "40mm Dynamic Drivers",
      "Up to 30 Hours Battery Life",
      "Bluetooth 5.0 Connectivity",
      "Built-in Microphone",
      "Touch Controls",
      "Fast Charging Support",
      "Foldable Design",
    ],
    reviews: [
      Review(
          username: "John Doe",
          content:
              "Great headphones with amazing sound quality! The noise cancellation is impressive and battery life is excellent.",
          rating: 5.0),
      Review(
          username: "Alice Smith",
          content:
              "Very comfortable and effective noise cancellation. Perfect for long listening sessions.",
          rating: 4.5),
      Review(
          username: "Mike Johnson",
          content:
              "Good value for money. Sound quality is top-notch but the app could be better.",
          rating: 4.0),
    ],
  ),
  Product(
    title: "Woman Sweater",
    description: "Baju berkualitas tinggi dan nyaman untuk dipakai sehari-hari",
    image: "images/all/sweet.png",
    price: 70000,
    originalPrice: 100000,
    discountPercentage: 30,
    seller: "Joy Store",
    colors: [Colors.brown, Colors.deepPurple, Colors.pink],
    sizes: ["S", "M", "L", "XL"],
    category: "Woman Fashion",
    review: "(32 Reviews)",
    rate: 4.5,
    reviewCount: 32,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: High-quality cotton",
      "Available in multiple colors",
      "Suitable for casual wear",
      "Machine washable",
      "Lightweight and comfortable",
    ],
    reviews: [
      Review(
          username: "Lisa White",
          content: "Very comfortable and perfect for chilly weather.",
          rating: 4.5),
      Review(
          username: "Mary Johnson",
          content: "Soft material, fits well!",
          rating: 4.0),
    ],
  ),
  Product(
    title: "Smart Watch",
    description:
        "CATATAN: Tali silikon ini dapat dipasang pada Miband 3 dan Miband 4!! "
        "Sorotan: "
        "- Dirancang khusus untuk Xiaomi Mi band 3 / MI Band 4 Tracker "
        "- Panjang tali: 155MM-210MM "
        "- Bahan: silikon "
        "- Satu ukuran cocok untuk kebanyakan orang "
        "nyaman dipakai. Fleksibel dan dapat disesuaikan.",
    image: "images/all/miband.jpg",
    price: 120000,
    originalPrice: 150000,
    discountPercentage: 20,
    seller: "Dinghanda",
    colors: [Colors.black, Colors.amber, Colors.purple],
    sizes: ["S", "M", "L"],
    category: "Electronics",
    review: "(20 Reviews)",
    rate: 4.0,
    reviewCount: 20,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Silikon yang nyaman",
      "Kesesuaian sempurna untuk Xiaomi Mi Band 3 & 4",
      "Desain fleksibel dan dapat disesuaikan",
      "Tersedia dalam berbagai warna",
      "Kekuatan tali hingga 210mm panjang",
    ],
    reviews: [
      Review(
          username: "Ahmad",
          content: "Nyaman dan bagus untuk Mi Band saya.",
          rating: 4.5),
      Review(
          username: "Siti",
          content: "Cocok dengan deskripsi, kualitas bagus.",
          rating: 4.0),
    ],
  ),
  Product(
    title: "Mens Jacket",
    description:
        "TEBAL LEMBUT, BISA MEMBUAT HANGAT, TIDAK AKAN MEMBUAT ANDA GERAH...",
    image: "images/all/jacket.png",
    price: 125000,
    originalPrice: 175000,
    discountPercentage: 28,
    seller: "Style Jacket",
    colors: [Colors.blueAccent, Colors.orange, Colors.green],
    sizes: ["M", "L", "XL"],
    category: "Men Fashion",
    review: "(20 Reviews)",
    rate: 5.0,
    reviewCount: 20,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material tebal dan lembut",
      "Desain yang nyaman dipakai",
      "Ideal untuk cuaca dingin",
      "Tidak menimbulkan rasa gerah",
      "Tersedia dalam berbagai warna",
    ],
    reviews: [
      Review(
          username: "Budi",
          content: "Hangat dan nyaman dipakai sehari-hari.",
          rating: 5.0),
      Review(
          username: "Dewi",
          content: "Kualitas bagus, sesuai dengan deskripsi.",
          rating: 5.0),
    ],
  ),
  Product(
    title: "Watch",
    description: "Temukan keanggunan berani dari jam tangan Titan Regalia...",
    image: "images/men fashion/watch.png",
    price: 600000,
    originalPrice: 700000,
    discountPercentage: 17,
    seller: "Memento Titan",
    colors: [Colors.lightBlue, Colors.orange, Colors.purple],
    sizes: ["One Size"],
    category: "Men Fashion",
    review: "(100 Reviews)",
    rate: 5.0,
    reviewCount: 100,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Tampilan klasik dengan desain modern",
      "Strap kulit yang elegan",
      "Water-resistant",
      "Fitur penunjuk tanggal",
      "Mekanisme yang tahan lama",
    ],
    reviews: [
      Review(
          username: "Andi",
          content: "Jam tangannya sangat bagus dan mewah.",
          rating: 5.0),
      Review(
          username: "Sari",
          content: "Sangat puas dengan kualitasnya.",
          rating: 5.0),
    ],
  ),
  Product(
    title: "Air Jordan",
    description:
        "Kenyamanan adalah yang utama, tetapi bukan berarti Anda harus mengorbankan gaya...",
    image: "images/shoes/Air Jordan.png",
    price: 940000,
    originalPrice: 990000,
    discountPercentage: 10,
    seller: "Nike",
    colors: [Colors.grey, Colors.amber, Colors.purple],
    sizes: ["40", "42", "44"],
    category: "Shoes",
    review: "(55 Reviews)",
    rate: 5.0,
    reviewCount: 55,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Desain klasik dari AJ1 dan AJ5",
      "Bahan kulit dan tenunan untuk sirkulasi udara",
      "Bantalan Nike Air untuk kenyamanan",
      "Tersedia dalam berbagai ukuran",
      "Desain yang ikonik dan stylish",
    ],
    reviews: [
      Review(
          username: "Rafi",
          content: "Kualitas top, sangat nyaman.",
          rating: 5.0),
      Review(
          username: "Fajar",
          content: "Sangat puas, desain dan kenyamanan luar biasa.",
          rating: 5.0),
    ],
  ),
  Product(
    title: "Super Perfume",
    description:
        "Parfum ini menawarkan aroma blackcurrant dan nektar yang unggul...",
    image: "images/beauty/perfume.png",
    price: 155000,
    originalPrice: 180000,
    discountPercentage: 14,
    seller: "Love Seller",
    colors: [Colors.purpleAccent, Colors.pinkAccent, Colors.green],
    sizes: ["100ml"],
    category: "Beauty",
    review: "(99 Reviews)",
    rate: 4.7,
    reviewCount: 99,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Aroma blackcurrant yang tahan lama",
      "Desain botol elegan",
      "100ml ukuran yang pas untuk sehari-hari",
      "Nektar eksotis",
      "Bahan alami dan aman",
    ],
    reviews: [
      Review(
          username: "Lina",
          content: "Wangi yang elegan dan tahan lama.",
          rating: 5.0),
      Review(
          username: "Amira", content: "Cocok untuk sehari-hari.", rating: 4.5),
    ],
  ),
  Product(
    title: "Wedding Ring",
    description:
        "XUPING JEWELRY adalah Perhiasan Kualitas import berbahan dasar Cooper Alloy...",
    image: "images/jewelry/wedding ring.png",
    price: 522000,
    originalPrice: 600000,
    discountPercentage: 13,
    seller: "Jewelry Shop",
    colors: [Colors.brown, Colors.purpleAccent, Colors.blueGrey],
    sizes: ["S", "M", "L"],
    category: "Jewelry",
    review: "(80 Reviews)",
    rate: 4.5,
    reviewCount: 80,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material copper alloy kualitas tinggi",
      "Desain elegan untuk pernikahan",
      "Tersedia dalam beberapa ukuran",
      "Anti karat dan tahan lama",
      "Harga terjangkau dengan kualitas import",
    ],
    reviews: [
      Review(
          username: "Ika",
          content: "Cincin yang cantik dan elegan.",
          rating: 4.5),
      Review(
          username: "Reza", content: "Kualitasnya sangat bagus.", rating: 4.0),
    ],
  ),
  Product(
    title: "Pants",
    description: "Katun Polyester dengan serat Twill premium...",
    image: "images/women fashion/pants.png",
    price: 105000,
    originalPrice: 130000,
    discountPercentage: 19,
    seller: "PK Store",
    colors: [Colors.lightGreen, Colors.blueGrey, Colors.deepPurple],
    sizes: ["S", "M", "L", "XL"],
    category: "Women Fashion",
    review: "(55 Reviews)",
    rate: 5.0,
    reviewCount: 55,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material Katun dan Polyester",
      "Kualitas serat twill premium",
      "Nyaman untuk pemakaian sehari-hari",
      "Tersedia berbagai ukuran",
      "Desain stylish dan cocok untuk casual",
    ],
    reviews: [
      Review(
          username: "Tina", content: "Bahan sangat nyaman, suka!", rating: 5.0),
      Review(
          username: "Eka",
          content: "Celana ini bagus sekali dipakai.",
          rating: 4.5),
    ],
  ),
];

final List<Product> shoes = [
  Product(
    title: "Air Jordan",
    description:
        "Kenyamanan adalah yang utama, tetapi bukan berarti Anda harus mengorbankan gaya. Terinspirasi dari desain AJ1 dan AJ5, Stadium 90 siap dikenakan setiap hari. Bagian atasnya terbuat dari kulit dan tenunan yang lembut, sehingga Anda mendapatkan sirkulasi udara dan daya tahan, dan bantalan Nike Air di solnya menjaga setiap langkah Anda tetap ringan dan nyaman.",
    image: "images/shoes/Air Jordan.png",
    price: 940000,
    originalPrice: 990000,
    discountPercentage: 10,
    seller: "Nike",
    colors: [Colors.grey, Colors.amber, Colors.purple],
    sizes: ["S", "M", "L", "XL"],
    category: "Shoes",
    review: "(55 Reviews)",
    rate: 5.0,
    reviewCount: 55,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material kulit dan tenunan berkualitas",
      "Sirkulasi udara yang baik",
      "Daya tahan tinggi",
      "Bantalan Nike Air untuk kenyamanan optimal",
    ],
    reviews: [
      Review(
          username: "Rizky",
          content: "Sepatu yang sangat nyaman dipakai sehari-hari.",
          rating: 5.0),
      Review(
          username: "Aldo",
          content: "Gaya dan kualitas luar biasa.",
          rating: 5.0),
    ],
  ),
  Product(
    title: "Vans Old Skool",
    description:
        "Sepatu Vans memiliki desain yang simpel. Meskipun simpel, pemakai sepatu Vans malah terlihat keren dan sporty. Itulah sebabnya sepatu Vans banyak digemari. Sepatu ini selalu menjadi andalan untuk dipakai dalam berbagai kesempatan yang tentunya dapat membuat pemakainya tampak modis dan sporty.",
    image: "images/shoes/vans old skool.png",
    price: 500000,
    originalPrice: 600000,
    discountPercentage: 16,
    seller: "VANS",
    colors: [Colors.blueAccent, Colors.blueGrey, Colors.green],
    sizes: ["S", "M", "L", "XL"],
    category: "Shoes",
    review: "(200 Reviews)",
    rate: 5.0,
    reviewCount: 200,
    quantity: 1,
    freeShipping: false,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Desain klasik dan sederhana",
      "Kenyamanan dan daya tahan tinggi",
      "Cocok untuk berbagai gaya dan kesempatan",
    ],
    reviews: [
      Review(
          username: "Bagus",
          content: "Keren dan cocok untuk gaya kasual.",
          rating: 5.0),
      Review(
          username: "Tiara",
          content: "Sangat nyaman dan stylish.",
          rating: 5.0),
    ],
  ),
  Product(
    title: "Women-Shoes",
    description:
        "Sepatu Casual Flat slip on Wanita.. cocok untuk bergaya santai tapi tetap feminin barang berkualitas, ringan kuat dan tahan lama dengan bahan Sintetis pilihan",
    image: "images/shoes/women-shoes.png",
    price: 140000,
    originalPrice: 200000,
    discountPercentage: 30,
    seller: "G2.Store",
    colors: [Colors.red, Colors.orange, Colors.greenAccent],
    sizes: ["S", "M", "L", "XL"],
    category: "Shoes",
    review: "(10 Reviews)",
    rate: 4.8,
    reviewCount: 10,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material sintetis berkualitas",
      "Ringan dan tahan lama",
      "Cocok untuk gaya kasual dan feminin",
    ],
    reviews: [
      Review(
          username: "Vina", content: "Sangat ringan dan nyaman.", rating: 4.8),
      Review(
          username: "Bella", content: "Cocok untuk sehari-hari.", rating: 5.0),
    ],
  ),
  Product(
    title: "Sports Shoes",
    description:
        "Sneakers PAGE 1ST adalah persembahan Jackson untukmu yang mencintai hal-hal simpel namun berkelas. PAGE 1ST memiliki varian warna vibrant Navy, Red, dan Royal Blue dengan desain minimalis serta teknologi no-tie shoelaces yang membuatmu semakin leluasa dalam beraktivitas. Tips: seimbangkan dengan outfit berwarna muted/subtle!",
    image: "images/shoes/sports shoes.png",
    price: 325000,
    originalPrice: 400000,
    discountPercentage: 19,
    seller: "Jacksone Shoes",
    colors: [Colors.deepPurpleAccent, Colors.orange, Colors.green],
    sizes: ["S", "M", "L", "XL"],
    category: "Shoes",
    review: "(60 Reviews)",
    rate: 3.0,
    reviewCount: 60,
    quantity: 1,
    freeShipping: false,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Desain minimalis dan berkelas",
      "Teknologi no-tie shoelaces",
      "Material berkualitas tinggi",
    ],
    reviews: [
      Review(
          username: "Joko",
          content: "Desain simpel dan nyaman dipakai.",
          rating: 3.0),
      Review(
          username: "Lina",
          content: "Kualitas oke, tetapi agak berat.",
          rating: 3.5),
    ],
  ),
  Product(
    title: "White Sneaker",
    description:
        "Sepatu yang kami jual dijamin secara kualitas, ketahanan, dan elastisitasnya. Judul Produk yang tertera FREE BOX akan mendapatkan Dus/Box Sepatu secara gratis. Untuk produk yang tidak mendapatkan free box, toko kami juga menjual BOX Sepatu secara retail! Foto yang tertera merupakan foto real 100%.",
    image: "images/shoes/white sneaker.png",
    price: 120000,
    originalPrice: 150000,
    discountPercentage: 20,
    seller: "Jacket Store",
    colors: [Colors.blueAccent, Colors.orange, Colors.green],
    sizes: ["S", "M", "L", "XL"],
    category: "Shoes",
    review: "(0 Reviews)",
    rate: 0.0,
    reviewCount: 0,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material elastis dan tahan lama",
      "Dijual dengan box sepatu",
      "Kualitas dijamin",
    ],
    reviews: [],
  ),
];

final List<Product> beauty = [
  Product(
    title: "Face Care Product",
    description:
        "Toko kami menjual berbagai jenis skincare seperti sabun muka, sunscreen, Dll",
    image: "images/beauty/face care.png",
    price: 500000,
    originalPrice: 550000,
    discountPercentage: 9,
    seller: "Yojana Seller",
    colors: [Colors.pink, Colors.amber, Colors.deepOrangeAccent],
    sizes: ["S", "M", "L", "XL"],
    category: "Beauty",
    review: "(200 Reviews)",
    rate: 4.0,
    reviewCount: 200,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Berbagai produk skincare berkualitas",
      "Mengandung bahan alami",
      "Diformulasikan untuk berbagai jenis kulit",
    ],
    reviews: [
      Review(
          username: "Dewi",
          content: "Sangat efektif untuk kulit saya.",
          rating: 4.0),
      Review(
          username: "Anita",
          content: "Kulit lebih halus dan sehat.",
          rating: 4.2),
    ],
  ),
  Product(
    title: "Super Perfume",
    description:
        "Parfum ini menawarkan aroma blackcurrant dan nektar yang unggul...",
    image: "images/beauty/perfume.png",
    price: 155000,
    originalPrice: 180000,
    discountPercentage: 14,
    seller: "Love Seller",
    colors: [Colors.purpleAccent, Colors.pinkAccent, Colors.green],
    sizes: ["S", "M", "L", "XL"],
    category: "Beauty",
    review: "(99 Reviews)",
    rate: 4.7,
    reviewCount: 99,
    quantity: 1,
    freeShipping: false,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Aroma blackcurrant dan nektar",
      "Daya tahan aroma yang lama",
      "Desain botol elegan",
    ],
    reviews: [
      Review(
          username: "Rina",
          content: "Harumnya tahan lama dan segar.",
          rating: 4.5),
      Review(
          username: "Amir",
          content: "Sangat puas dengan produk ini.",
          rating: 4.7),
    ],
  ),
  Product(
    title: "Skin-Care Product",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
    image: "images/beauty/skin-care.png",
    price: 999,
    originalPrice: 1200,
    discountPercentage: 17,
    seller: "Mr Beast",
    colors: [Colors.black12, Colors.orange, Colors.white38],
    sizes: ["S", "M", "L", "XL"],
    category: "Beauty",
    review: "(20 Reviews)",
    rate: 4.2,
    reviewCount: 20,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Formulasi unggul untuk kulit sehat",
      "Mengandung vitamin dan mineral penting",
      "Aman untuk semua jenis kulit",
    ],
    reviews: [
      Review(
          username: "Putri", content: "Kulit terasa lebih sehat.", rating: 4.0),
      Review(
          username: "Cici",
          content: "Produk yang bagus dan efektif.",
          rating: 4.5),
    ],
  ),
];

final List<Product> womenFashion = [
  Product(
    title: "Women Kurta",
    description:
        "Gaun ini memiliki nuansa yang indah dan motif yang indah di sekeliling pakaian...",
    image: "images/women fashion/kurta.png",
    price: 199000,
    originalPrice: 250000,
    discountPercentage: 20,
    seller: "Sila Store",
    colors: [Colors.grey, Colors.black54, Colors.purple],
    sizes: ["S", "M", "L", "XL"],
    category: "WomenFashion",
    review: "(25 Reviews)",
    rate: 5.0,
    reviewCount: 25,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Bahan berkualitas tinggi",
      "Motif menarik di sekeliling",
      "Nyaman dipakai sepanjang hari",
    ],
    reviews: [
      Review(
          username: "Tari", content: "Sangat nyaman dan cantik.", rating: 5.0),
      Review(username: "Sari", content: "Motifnya sangat indah.", rating: 5.0),
    ],
  ),
  Product(
    title: "Dress",
    description: "Bahan produk sesuai keterangan di deskripsi pendek...",
    image: "images/women fashion/lehenga.png",
    price: 150000,
    originalPrice: 180000,
    discountPercentage: 17,
    seller: "My Store",
    colors: [
      Colors.black,
      Colors.orange,
      Colors.green,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "WomenFashion",
    review: "(100 Reviews)",
    rate: 4.0,
    reviewCount: 100,
    quantity: 1,
    freeShipping: false,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Bahan berkualitas tinggi",
      "Desain elegan dan nyaman",
      "Cocok untuk acara formal",
    ],
    reviews: [
      Review(
          username: "Dina",
          content: "Pas dipakai dan sesuai ekspektasi.",
          rating: 4.0),
      Review(
          username: "Nita", content: "Bahannya bagus dan lembut.", rating: 4.5),
    ],
  ),
  Product(
    title: "T-Shirt",
    description: "BAHAN TEBAL DAN TIDAK PANAS...",
    image: "images/women fashion/t-shert.png",
    price: 100000,
    originalPrice: 130000,
    discountPercentage: 23,
    seller: "Love Store",
    colors: [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.deepOrangeAccent,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "Electronics",
    review: "(20 Reviews)",
    rate: 5.0,
    reviewCount: 20,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material berkualitas tinggi, tidak mudah panas",
      "Nyaman dipakai seharian",
      "Desain kasual untuk sehari-hari",
    ],
    reviews: [
      Review(username: "Budi", content: "Sangat nyaman dan adem.", rating: 5.0),
      Review(
          username: "Agus",
          content: "Bagus untuk pemakaian harian.",
          rating: 4.8),
    ],
  ),
  Product(
    title: "Pants",
    description: "Katun Polyester dengan serat Twill premium...",
    image: "images/women fashion/pants.png",
    price: 105000,
    originalPrice: 150000,
    discountPercentage: 30,
    seller: "PK Store",
    colors: [
      Colors.orangeAccent,
      Colors.blueAccent,
      Colors.pinkAccent,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "WomenFashion",
    review: "(90 Reviews)",
    rate: 4.8,
    reviewCount: 90,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Katun polyester berkualitas tinggi",
      "Nyaman dan ringan",
      "Cocok untuk berbagai aktivitas",
    ],
    reviews: [
      Review(
          username: "Ira",
          content: "Nyaman dipakai sepanjang hari.",
          rating: 4.8),
      Review(
          username: "Rani",
          content: "Sangat puas dengan produk ini.",
          rating: 5.0),
    ],
  ),
];
final List<Product> jewelry = [
  Product(
    title: "Earrings",
    description:
        "Anting adalah salah satu aksesoris pemberikan dampak signifikan pada sebuah busana. GLAMIRA menawarkan macam gaya anting mulai dari anting klasik hingga studs, hoops, drops, threads, mutiara, dan lainnya",
    image: "images/jewelry/earrings.png",
    price: 850000,
    originalPrice: 900000,
    discountPercentage: 20,
    seller: "Glamira",
    colors: [
      Colors.amber,
      Colors.deepPurple,
      Colors.pink,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "Jewelry",
    review: "(32 Reviews)",
    rate: 4.5,
    reviewCount: 32,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: Gold plated",
      "Type: Drop Earrings",
      "Weight: 15 grams"
    ],
    reviews: [
      Review(
          username: "Siti",
          content: "Produk berkualitas, sangat indah dipakai.",
          rating: 4.5),
      Review(
          username: "Nina",
          content: "Warna dan desainnya sangat menarik.",
          rating: 4.7),
      Review(
          username: "Ani",
          content: "Pengiriman cepat, kualitas sesuai dengan harga.",
          rating: 4.8),
    ],
  ),
  Product(
    title: "Jewelry-Box",
    description:
        "Kotak perhiasan Heartbeat, tempat menyimpan berbagai macam aksesorismu seperti cincin, gelang, dan kalung agar terhindar dari debu sehingga tersimpan awet tanpa takut rusak dan lecet. Dengan beragam pilihan warna untuk mewarnai hari-harimu",
    image: "images/jewelry/jewelry-box.png",
    price: 210000,
    originalPrice: 250000,
    discountPercentage: 16,
    seller: "Panlandwoo Shop",
    colors: [
      Colors.pink,
      Colors.orange,
      Colors.redAccent,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "Jewelry",
    review: "(100 Reviews)",
    rate: 5.0,
    reviewCount: 100,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: Wood and velvet",
      "Color: Pink, Orange, Red",
      "Capacity: Holds up to 50 pieces of jewelry"
    ],
    reviews: [
      Review(
          username: "Alya",
          content:
              "Sangat membantu untuk menyimpan perhiasan saya dengan aman.",
          rating: 5.0),
      Review(
          username: "Nadia",
          content: "Bahan dan kualitas finishingnya bagus sekali.",
          rating: 4.9),
      Review(
          username: "Rina",
          content: "Warna-warnanya cerah dan cantik.",
          rating: 4.8),
    ],
  ),
  Product(
    title: "Wedding Ring",
    description:
        "Perhiasan Diamond & Co berasal dari Eropa dan dirancang dengan desain terbaik yang akan membuat kamu lebih berkilau dan percaya diri. Menggunakan natural diamond (berlian asli), bukan synthetic diamond yang berkualitas near colorless dan VS clarity.",
    image: "images/jewelry/wedding ring.png",
    price: 450000,
    originalPrice: 500000,
    discountPercentage: 10,
    seller: "Diamond & Co Shop",
    colors: [
      Colors.brown,
      Colors.purpleAccent,
      Colors.blueGrey,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "Jewelry",
    review: "(80 Reviews)",
    rate: 4.5,
    reviewCount: 80,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: 18K Gold",
      "Stone: Natural Diamond",
      "Clarity: VS",
      "Color Grade: Near Colorless"
    ],
    reviews: [
      Review(
          username: "Arman",
          content: "Sangat berkelas dan elegan.",
          rating: 4.5),
      Review(
          username: "Lina",
          content: "Diamondnya terlihat sangat bersinar, kualitas bagus.",
          rating: 4.7),
      Review(
          username: "Budi",
          content: "Desainnya modern dan simple.",
          rating: 4.6),
    ],
  ),
  Product(
    title: "Necklace-Jewellery",
    description:
        "Kalung ini berkilau dengan desain bunga yang menawan, yang menampilkan batu merah muda berbentuk semanggi yang berputar, dan tampak mengambang di dalam tempatnya serta dilengkapi dengan rantai berlapis emas mawar 18K.",
    image: "images/jewelry/necklace-jewellery.png",
    price: 740000,
    originalPrice: 820000,
    discountPercentage: 21,
    seller: "Celest official Shop",
    colors: [
      Colors.blueAccent,
      Colors.orange,
      Colors.green,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "Jewelry",
    review: "(22 Reviews)",
    rate: 3.5,
    reviewCount: 22,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: Rose Gold 18K",
      "Gemstone: Pink Clover-shaped",
      "Length: 45 cm"
    ],
    reviews: [
      Review(
          username: "Fina",
          content: "Desainnya unik dan cocok untuk acara formal.",
          rating: 3.5),
      Review(
          username: "Dina",
          content: "Pewarnaannya sangat cantik.",
          rating: 3.6),
      Review(
          username: "Lia",
          content: "Harganya sebanding dengan kualitasnya.",
          rating: 3.4),
    ],
  ),
];
final List<Product> menFashion = [
  Product(
    title: "Man Jacket",
    description:
        "Darren Denim Jacket is not just an ordinary jacket, it's the essence of effortless cool and modern style...",
    image: "images/men fashion/man jacket.png",
    price: 150000,
    originalPrice: 180000,
    discountPercentage: 17,
    seller: "Cutoff Store",
    colors: [
      Colors.brown,
      Colors.orange,
      Colors.blueGrey,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "MenFashion",
    review: "(90 Reviews)",
    rate: 5.0,
    reviewCount: 90,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: Denim",
      "Fit: Regular",
      "Care Instructions: Machine wash"
    ],
    reviews: [
      Review(
          username: "Aditya",
          content: "Jaket ini sangat nyaman dipakai.",
          rating: 5.0),
      Review(
          username: "Rizky",
          content: "Desainnya stylish dan modern.",
          rating: 4.9),
      Review(
          username: "Fajar",
          content: "Kualitas jahitan sangat baik.",
          rating: 5.0),
    ],
  ),
  Product(
    title: "Men Pants",
    description:
        "Jeans ini bisa kamu pasangin sama kemeja berlengan panjang buat bergaya semi-formal...",
    image: "images/men fashion/pants.png",
    price: 150000,
    originalPrice: 200000,
    discountPercentage: 25,
    seller: "Fairgood Shop",
    colors: [
      Colors.black54,
      Colors.orange,
      Colors.green,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "MenFashion",
    review: "(50 Reviews)",
    rate: 4.5,
    reviewCount: 50,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: Cotton blend",
      "Fit: Slim",
      "Care Instructions: Hand wash recommended"
    ],
    reviews: [
      Review(
          username: "Dewi",
          content: "Pants ini sangat nyaman dan stylish.",
          rating: 4.5),
      Review(
          username: "Rini",
          content: "Cocok untuk acara formal maupun kasual.",
          rating: 4.6),
      Review(
          username: "Bobby",
          content: "Bahan berkualitas, tidak mudah pudar.",
          rating: 4.7),
    ],
  ),
  Product(
    title: "Men Shirt",
    description:
        "Kemeja relax lengan panjang dari Hooligans dengan material rayon yang lembut...",
    image: "images/men fashion/shert.png",
    price: 180000,
    originalPrice: 230000,
    discountPercentage: 22,
    seller: "Hooligans Store",
    colors: [
      Colors.pink,
      Colors.amber,
      Colors.green,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "MenFashion",
    review: "(200 Reviews)",
    rate: 3.0,
    reviewCount: 200,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: Rayon",
      "Fit: Relaxed",
      "Care Instructions: Dry clean only"
    ],
    reviews: [
      Review(
          username: "Bayu",
          content: "Sangat nyaman dipakai sehari-hari.",
          rating: 3.0),
      Review(
          username: "Indra",
          content: "Motif yang stylish dan kekinian.",
          rating: 3.5),
      Review(
          username: "Rina",
          content: "Ukuran sesuai dengan deskripsi.",
          rating: 3.2),
    ],
  ),
  Product(
    title: "T-Shirt",
    description:
        "Hammer menjadi salah satu produk Lokal dengan kualitas terbaik...",
    image: "images/men fashion/t-shirt.png",
    price: 150000,
    originalPrice: 180000,
    discountPercentage: 17,
    seller: "Hammer",
    colors: [
      Colors.brown,
      Colors.orange,
      Colors.blue,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "MenFashion",
    review: "(1k Reviews)",
    rate: 5.0,
    reviewCount: 1000,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: 100% Cotton",
      "Fit: Regular",
      "Care Instructions: Machine wash"
    ],
    reviews: [
      Review(
          username: "Yoga",
          content: "T-Shirt ini sangat nyaman dan lembut.",
          rating: 5.0),
      Review(
          username: "Ari",
          content: "Warna yang beragam dan cerah.",
          rating: 5.0),
      Review(
          username: "Lina",
          content: "Kualitas terbaik untuk harga yang ditawarkan.",
          rating: 4.9),
    ],
  ),
  Product(
    title: "Watch",
    description: "Temukan keanggunan berani dari jam tangan Titan Regalia...",
    image: "images/men fashion/watch.png",
    price: 600000,
    originalPrice: 700000,
    discountPercentage: 23,
    seller: "Titan",
    colors: [
      Colors.lightBlue,
      Colors.orange,
      Colors.purple,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "MenFashion",
    review: "(100 Reviews)",
    rate: 5.0,
    reviewCount: 100,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: Stainless Steel",
      "Water Resistance: 50 meters",
      "Warranty: 2 years"
    ],
    reviews: [
      Review(
          username: "Dimas",
          content: "Jam tangan ini sangat elegan.",
          rating: 5.0),
      Review(
          username: "Angga",
          content: "Kualitas luar biasa, sangat tahan lama.",
          rating: 4.9),
      Review(
          username: "Citra",
          content: "Cocok untuk berbagai acara formal.",
          rating: 5.0),
    ],
  ),
];
final List<Product> eletronik = [
  Product(
    title: "Headphone Nirkabel",
    description:
        "Skullcandy headphone TWS aktif, earbud luar ruangan pengurangan kebisingan...",
    image: "images/all/wireless.png",
    price: 140000,
    originalPrice: 240000,
    discountPercentage: 18,
    seller: "Skullcandy",
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "Electronics",
    review: "(20 Reviews)",
    rate: 4.8,
    reviewCount: 20,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Type: TWS Earbuds",
      "Battery Life: Up to 24 hours",
      "Noise Cancellation: Active"
    ],
    reviews: [
      Review(
          username: "Hana",
          content: "Kualitas suara sangat memuaskan.",
          rating: 4.8),
      Review(
          username: "Gilang",
          content: "Desainnya nyaman di telinga.",
          rating: 4.7),
      Review(
          username: "Fina",
          content: "Pengurangan suara latar belakang yang efektif.",
          rating: 4.9),
    ],
  ),
  Product(
    title: "Smart Watch",
    description:
        "CATATAN: Tali silikon ini dapat dipasang pada Miband 3 dan Miband 4...",
    image: "images/all/miband.jpg",
    price: 120000,
    originalPrice: 150000,
    discountPercentage: 20,
    seller: "Dinghanda",
    colors: [
      Colors.black,
      Colors.amber,
      Colors.purple,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "Electronics",
    review: "(20 Reviews)",
    rate: 4.0,
    reviewCount: 20,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Display: 1.1 inch AMOLED",
      "Battery Life: 20 days",
      "Water Resistance: IP68"
    ],
    reviews: [
      Review(
          username: "Adit",
          content: "Fitur-fiturnya sangat membantu untuk kesehatan.",
          rating: 4.0),
      Review(
          username: "Rika",
          content: "Baterai awet, bisa tahan lama.",
          rating: 4.1),
      Review(
          username: "Sari",
          content: "Tampilan layarnya jernih dan tajam.",
          rating: 4.2),
    ],
  ),
];
