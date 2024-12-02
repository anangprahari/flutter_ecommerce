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
    title:
        "Aitu Q36 Open Ear Bone Conduction Wireless Bluetooth 5.3 Earphone head",
    description:
        "Produk harus disimpan di ruangan yang kering dan berventilasi untuk menghindari kontak dengan zat korosif dan jauh dari api dan sumber panas. Produk perlu diisi dayanya setiap 3 bulan selama penyimpanan. Operasional: 0~40℃, penyimpanan: -10~45℃, kelembaban saat bekerja : kurang dari 70%",
    image: "images/all/wireless.png",
    price: 83000,
    originalPrice: 300000,
    discountPercentage: 70,
    seller: "Skullcandy",
    colors: [Colors.black, Colors.orange, Colors.white],
    category: "Electronics",
    review: "(5 reviews)",
    rate: 4.5,
    reviewCount: 2100,
    quantity: 1,
    freeShipping: false,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Jenis Produk: WWS Speaker Bluetooth"
          "Sistem Trek: Stereo"
          "Mode Kontrol: Tombol Sentuh"
          "Aktif Pasif: Aktif"
          "Solusi Bluetooth: 6983D2"
          "Versi Bluetooth: V5.3"
          "Jarak Bluetooth: ≥10 m"
          "Jarak Terbaik < 10 m"
          "Daya Maksimum Headset: 5mW"
          "Jenis Speaker: ∮16mm, 21Ω speaker film komposit magnetik besar"
          "Baterai: Baterai Headphone 3,7V/ 501020 70mAh, Baterai Kompartemen Pengisian 3,7V/ 602040 350mAh"
          "Waktu Putar Musik: Sekitar 6-8 jam (volume 80%)"
          "Input Pengisian: Type-c, DC5V-300mA"
          "Waktu Pengisian: Sekitar 1,5 jam"
    ],
    reviews: [
      Review(
          username: "Rizky",
          content:
              "mantab, walau masih merk yg kurang dikenal, kualitas bagus dan berfungsi dengan baik, suara balance dan cukup, gak over, pengiriman cepat...moga2 awet dan gak ada masalah nanti",
          rating: 5.0),
      Review(
          username: "Samid",
          content: "Packing aman, barang berfungsi normal, pengiriman cepat",
          rating: 4.5),
      Review(
          username: "rahmat dwi",
          content: "Sesuai sama di foto prodak dan barang sangat istimewa",
          rating: 4.0),
      Review(
          username: "isan",
          content:
              "Barang berfungsi dg baik kualitas barang sesuai dengan harga",
          rating: 4.5),
      Review(
          username: "Anang",
          content:
              "sesuai lah guys dengan harga segitu, tpi sngat cool dan nyaman di kuping",
          rating: 3.0),
    ],
  ),
  Product(
    title: "Blouse asimetrisdez",
    description: "Baju berkualitas tinggi dan nyaman untuk dipakai sehari-hari",
    image: "images/all/sweet.png",
    price: 180000,
    originalPrice: 190000,
    discountPercentage: 10,
    seller: "Ozaniesgallery",
    colors: [Colors.black, Colors.brown, Colors.white],
    sizes: ["S", "M", "L", "XL"],
    category: "Woman Fashion",
    review: "(4 Reviews)",
    rate: 4.8,
    reviewCount: 32,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Bahan: polister",
      "ukuran: 58*54cm",
      "Transisi: 1cm = 10mm = 0.39inci",
    ],
    reviews: [
      Review(
          username: "Lisa",
          content: "Bagus, nyaman kainnya dingin.",
          rating: 5.0),
      Review(
          username: "Syahla",
          content: "Bagus banget cuma salah ngambil ukurannya, hihi😒",
          rating: 4.0),
      Review(
          username: "Salma",
          content: "Bagus banget lupa fotoin soalnya udah langsung dicuci😂🤣",
          rating: 4.5),
      Review(
          username: "isana saraswati",
          content: "Bagus banget Masyaallah😍",
          rating: 5.0),
    ],
  ),
  Product(
    title: "Mi Smart band 5",
    description: "Fitur-Fiturnya:"
        "Pengambilan foto jarak jauh, pemutaran musik, cari ponsel, mengheningkan ponsel, membuka kunci ponsel, notifikasi panggilan masuk, jangan ganggu, notifikasi WhatsApp, peringatan pesan aplikasi, pengingat kalender, pengingat acara, ramalan cuaca, timer, stopwatch, alarm, siaran Bluetooth, panggilan online, panggilan khusus, panggilan cepat, penguncian layar, tampilan proses pengisian daya, pilihan metode pemakaian, pembaruan via OTA.",
    image: "images/all/miband.jpg",
    price: 550000,
    originalPrice: 650000,
    discountPercentage: 10,
    seller: "Gadgetilicious",
    colors: [Colors.black, Colors.brown, Colors.green],
    sizes: ["S", "M", "L"],
    category: "Electronics",
    review: "(6 Reviews)",
    rate: 5.0,
    reviewCount: 20,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Layar : AMOLED 1.1",
      "Resolusi layar 126*294",
      "Kedalaman warna layar：16 bit",
      "Lampu latar layar：Kecerahan maksimum ≥ 450 nits, dapat disetel",
      "Tampilan tombol：Satu tombol sentuh (membangunkan layar, kembali)",
      "Sensor：Akselerometer 3 sumbu dan giroskop 3 sumbu konsumsi daya rendah, Sensor detak jantung PPG",
      "Metode pengisian daya：Pengisian daya magnetis",
      "Durasi pengisian daya：< 2 jam",
      "Masa baterai：≥ 14 hari",
    ],
    reviews: [
      Review(
          username: "Ahmad",
          content: "Nyaman dan bagus sekali Mi Smart Band 5 nya.",
          rating: 4.5),
      Review(
          username: "Siti janah",
          content:
              "Sayang Banget salah ngambil warna padahal bagus banget😢😢.",
          rating: 4.0),
      Review(
          username: "silvia",
          content: "Suka banget lucu juga bentuknya😍.",
          rating: 5.0),
      Review(username: "Melyna", content: "Sellernya good👌.", rating: 4.5),
      Review(
          username: "Putriana",
          content:
              "Kondisi produk sangat baik dan pembungkus yang diberikan pengamannya sangat baik juga.",
          rating: 5.0),
      Review(
          username: "Murtika antana",
          content: "Ga nyangka sampenya cepet banget.",
          rating: 4.5),
    ],
  ),
  Product(
    title: "Jaket Jeans Pria Trucker Sherpa Bulu jaket tebal",
    description:
        "Jaket jeans bulu pria, Jaket jeans Denim Sakura 14 Ozz, Bahan jeans tebal dan lembut",
    image: "images/all/jacket.png",
    price: 150000,
    originalPrice: 300000,
    discountPercentage: 50,
    seller: "clay_collection",
    colors: [Colors.blueAccent, Colors.black, Colors.blue],
    sizes: ["M", "L", "XL"],
    category: "Men Fashion",
    review: "(4 Reviews)",
    rate: 5.0,
    reviewCount: 20,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "-Kancing ori",
      "-Hanteg full",
      "-Laken Merk Tembus",
      "-Ada saku di dalam nya Bisa pakai nyimpan HP",
      "Detail Ukuran",
      "M: Bahu 43 cm, Lebar dada 50 Cm, Tinggi badan 61 Cm, Panjang Lengan 60 Cm",
      "L: Bahu 45 Cm, Lebar dada 53 Cm, Tinggi badan 63 Cm, panjang lengan 62 Cm",
      "Xl: Bahu 47 Cm, Lebar dada 56 Cm, Tinggi badan 65 Cm, Panjang lengan 64 Cm",
    ],
    reviews: [
      Review(
          username: "Budi",
          content: "Hangat dan nyaman dipakai sehari-hari.",
          rating: 5.0),
      Review(
          username: "baldy putra",
          content: "Kualitas bagus, sesuai dengan deskripsi.",
          rating: 4.0),
      Review(
          username: "Abdi muhammad",
          content: "Pengirimannya cepat, bahannya tebal banget.",
          rating: 4.5),
      Review(
          username: "Rizky",
          content: "Bagus Bahannya tebal sayangnnya salah pilih warna😢.",
          rating: 4.0),
    ],
  ),
  Product(
    title: "Titan Bandhan Green Dial Multi Stainless Steel Strap Watch",
    description:
        "Titan telah berkembang pesat sejak tahun 1984 ketika kami memulai dengan satu kategori produk. Saat ini, dengan lebih dari 8.000 karyawan dan sekitar 38.000 orang di seluruh ekosistem Titan, 16 merek, dan lebih dari 2.000 toko ritel, kami berkomitmen untuk memberikan pertumbuhan yang menguntungkan dan bertanggung jawab.",
    image: "images/men fashion/watch.png",
    price: 800000,
    originalPrice: 900000,
    discountPercentage: 10,
    seller: "Memento Titan",
    colors: [Colors.brown, Colors.green, Colors.black],
    sizes: ["One Size"],
    category: "Men Fashion",
    review: "(4 Reviews)",
    rate: 5.0,
    reviewCount: 100,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
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
          username: "Antoko",
          content: "bagus dan mewah sesuai sama harganya😂.",
          rating: 4.5),
      Review(
          username: "Brian antaka",
          content: "Pengiriman cepat dan bagus banget modelnya.",
          rating: 5.0),
      Review(
          username: "andreansyah",
          content: "Lumayanlah untuk harga segini.",
          rating: 4.5),
      Review(
          username: "Ferdi nando",
          content: "Salah beli warnanya yang dibeli kurang cocok😢.",
          rating: 4.0),
    ],
  ),
  Product(
    title: "Air Jordan",
    description:
        "Kenyamanan adalah yang utama, tetapi bukan berarti Anda harus mengorbankan gaya...",
    image: "images/shoes/Air Jordan.png",
    price: 850000,
    originalPrice: 900000,
    discountPercentage: 5,
    seller: "Nike",
    colors: [Colors.grey, Colors.brown, Colors.white],
    sizes: ["40", "42", "44"],
    category: "Shoes",
    review: "(6 Reviews)",
    rate: 5.0,
    reviewCount: 55,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
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
          content: "Kualitas mantap, sangat nyaman.",
          rating: 5.0),
      Review(
          username: "Fajar",
          content: "Sangat puas, desain dan kenyamanan luar biasa.",
          rating: 4.0),
      Review(
          username: "budi utomo",
          content: "Desain simpel jadi kalo dipake pede😍.",
          rating: 5.0),
      Review(
          username: "M rizky",
          content: "Nyaman dipake buat joging😁",
          rating: 4.5),
      Review(
          username: "Andra",
          content: "Worth it buat harga segini sih",
          rating: 4.0),
      Review(username: "agung ugo", content: "Mantap abiezzzzz.", rating: 5.0),
    ],
  ),
  Product(
    title: "Parfum Secret garden Eau de Parfum",
    description:
        "Produk mudah terbakar, jauhkan dari api dan di tempat teduh, jangan kontak dengan mata, jauhkan dari jangkauan anak-anak",
    image: "images/beauty/perfume.png",
    price: 130000,
    originalPrice: 160000,
    discountPercentage: 30,
    seller: "Love Seller",
    colors: [Colors.purpleAccent],
    sizes: ["100ml"],
    category: "Beauty",
    review: "(4 Reviews)",
    rate: 4.7,
    reviewCount: 99,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Aroma yang sangat sensual",
      "Desain botol elegan",
      "100ml ukuran yang pas untuk sehari-hari",
      "tahan 6-8 jam",
    ],
    reviews: [
      Review(
          username: "Cindy",
          content:
              "Pas banget liat di mall pulangnya cek disini ada stocknya. Wangi enak banget. Diawal mirip wangi grapefruit, pas sudah lamaan manis dan bunga lembut juga musk yg muncul",
          rating: 5.0),
      Review(
          username: "Binti",
          content:
              "Udah Beli tapi Trus Dapet Kado sama Kalau Ada Yang Mau Gantiin Bisa Chat Ke Akun shopee q ya 125K aja nih Masih Baru bgt, Wanginya Enakkk Bgt Gak Bikin Pusing segerrrr dan tahan lamaaaaa.",
          rating: 4.5),
      Review(
          username: "Kanaya",
          content:
              "biasanya pake yang British Pear EDP limited edition karena udah nyantol banget sama yang satu itu tapi pengen sekali-kali coba yang lain. setelah kucoba ternyata ku tetap suka yang british pear 😂 tapiiii ini enak juga, wanginya sesuai namanya, Secret Garden 🌿 fresh and flowery 🌺 botolnya juga cantik sekaliiii.",
          rating: 4.5),
      Review(
          username: "nindia",
          content:
              "Cocok sama wanginya. Harganya juga masuk akal banget, jadi ditinggal di kantor gak masalah",
          rating: 4.5),
    ],
  ),
  Product(
    title: "Cincin solitaire rosegold",
    description:
        "UNTUK MENJAGA WARNA PERHIASAN AGAR TETAP AWET DISARANKAN TIDAK TERKENA ALKOHOL, AIR ASIN, KERINGAT YANG BERLEBIHAN DAN BAHAN KIMIA LAINNYA.",
    image: "images/jewelry/wedding ring.png",
    price: 2500000,
    originalPrice: 3000000,
    discountPercentage: 5,
    seller: "Jewelry Shop",
    colors: [Colors.brown, Colors.purpleAccent, Colors.blueGrey],
    sizes: ["S", "M", "L"],
    category: "Jewelry",
    review: "(5 Reviews)",
    rate: 4.5,
    reviewCount: 80,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Cincin solitaire pmt",
      "Berat : 1,80 gram",
      "Size : 15",
      "Kadar: 750 17K",
    ],
    reviews: [
      Review(
          username: "Ika", content: "Cincin nya cantik banget.", rating: 4.5),
      Review(
          username: "Reza",
          content: "bagus, ngadoin buat doi hehe😁.",
          rating: 4.5),
      Review(
          username: "Cantika",
          content: "lucu bangettt harganya juga ga mahal.",
          rating: 5.0),
      Review(
          username: "Nabila",
          content: "Worth it buat harga segini lucu banget hihi.",
          rating: 4.5),
    ],
  ),
  Product(
    title: "Oro pants",
    description:
        "Celana kerja Oro Pant/Loose Pant wanita adalah produk yang tersedia untuk Anda yang membutuhkan celana kerja yang nyaman dan fleksibel. Celana ini terbuat dari bahan knit premium yang memberikan kenyamanan saat digunakan dan tahan lama.",
    image: "images/women fashion/pants.png",
    price: 50000,
    originalPrice: 80000,
    discountPercentage: 30,
    seller: "PK Store",
    colors: [Colors.brown, Colors.black, Colors.white],
    sizes: ["S", "M", "L", "XL"],
    category: "Women Fashion",
    review: "(5 Reviews)",
    rate: 4.5,
    reviewCount: 55,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "S/M: Pinggang : 66 - 88 cm, Paha : 60 cm, Panjang : 100 cm, BB : 40 - 55 kg",
      "L: Pinggang : 72 - 94 cm, Paha : 64 cm, Panjang : 100 cm, BB : 55 - 65 kg",
      "XL: Pinggang : 78 - 100 cm, Paha : 68 cm, Panjang : 100 cm, BB : 65-75 kg",
    ],
    reviews: [
      Review(
          username: "Tina",
          content:
              "Celana nya pas banget di aku,warna nya cocok juga,sangat nyaman dipake nya,desain sangat menarik,sangat bagus dan juga memuaskan next aku bakal order lagi,seller sangat ramah pengiriman cepat",
          rating: 5.0),
      Review(
          username: "Eka kasini",
          content:
              "sudah sampe, celananya emang sebagus ini, langsung ta pake dan Yap bener pas, bahannya bagus dengan harga segini, udah worth it sekali ini beb, pokoknya overall bagus puas sama produk dan sellernya",
          rating: 4.5),
      Review(
          username: "Charli pratama",
          content:
              "Baguss banget celana nya , cocok buat di pake nongky , ootd , sukaaa sekali .. warna sesuai bahan nya juga bagus nyaman banget di pake , next bakal order lagi warna lainnya..",
          rating: 5.0),
      Review(
          username: "Yuni winata",
          content:
              "Bagus banget recommended deh belanja disini amanah banget, seller nya juga amanah dan gercep banget buat ngirim barang nya Puas banget belanja disini Thnks ya kak",
          rating: 4.5),
      Review(
          username: "Cindi",
          content:
              "Alhamdulillah akhirnya mendarat dgn slmt , bahannya super lembut, halus , tebal , nyaman dipakai, pas banget dibadan, pengiriman cepat, paking aman , seller ramah dan amanah",
          rating: 4.0),
    ],
  ),
];

final List<Product> shoes = [
  Product(
    title: "Air Jordan",
    description:
        "100% Original Authentic. Kenyamanan adalah yang utama, tetapi bukan berarti Anda harus mengorbankan gaya. Terinspirasi dari desain AJ1 dan AJ5, Stadium 90 siap dikenakan setiap hari. Bagian atasnya terbuat dari kulit dan tenunan yang lembut, sehingga Anda mendapatkan sirkulasi udara dan daya tahan, dan bantalan Nike Air di solnya menjaga setiap langkah Anda tetap ringan dan nyaman.",
    image: "images/shoes/Air Jordan.png",
    price: 2199000,
    originalPrice: 2299000,
    discountPercentage: 10,
    seller: "Nike",
    colors: [Colors.grey],
    sizes: ["40", "41", "42", "43", "44"],
    category: "Shoes",
    review: "(55 Reviews)",
    rate: 5.0,
    reviewCount: 55,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
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
      Review(
          username: "sintia",
          content: "produk ori, barang sampai dengan cepat.",
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
    colors: [
      Colors.black,
    ],
    sizes: ["36", "36.5", "37", "38"],
    category: "Shoes",
    review: "(200 Reviews)",
    rate: 4.9,
    reviewCount: 200,
    quantity: 1,
    freeShipping: false,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Merek: vans",
      "Tipe pengikat: Tali",
      "Kenyamanan dan daya tahan tinggi",
      "Cocok untuk berbagai gaya dan kesempatan",
    ],
    reviews: [
      Review(
          username: "deni",
          content:
              "Barang original, packing rapih dan aman dan pengiriman cepat.",
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
    price: 690318,
    originalPrice: 660318,
    discountPercentage: 30,
    seller: "G2.Store",
    colors: [Colors.brown, Colors.black, Colors.blue],
    sizes: [
      "23",
      "24",
      "25",
      "26" "27",
      "28",
      "29",
    ],
    category: "Shoes",
    review: "(50 Reviews)",
    rate: 4.8,
    reviewCount: 10,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
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
    colors: [Colors.deepPurpleAccent, Colors.orange, Colors.blue],
    sizes: ["39", "40", "41", "42"],
    category: "Shoes",
    review: "(60 Reviews)",
    rate: 3.0,
    reviewCount: 60,
    quantity: 1,
    freeShipping: false,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Desain minimalis dan berkelas",
      "Teknologi no-tie shoelaces",
      "Material berkualitas tinggi",
    ],
    reviews: [
      Review(
          username: "Joko",
          content: "Desain simpel dan nyaman dipakai 😍😍.",
          rating: 3.0),
      Review(
          username: "Lina",
          content: "Kualitas oke, tetapi agak berat 👍.",
          rating: 3.5),
    ],
  ),
  Product(
    title: "White Sneaker",
    description:
        "Sepatu yang kami jual dijamin secara kualitas, ketahanan, dan elastisitasnya. Judul Produk yang tertera FREE BOX akan mendapatkan Dus/Box Sepatu secara gratis.",
    image: "images/shoes/white sneaker.png",
    price: 125000,
    originalPrice: 130000,
    discountPercentage: 20,
    seller: "PVN",
    colors: [Colors.white, Colors.black],
    sizes: ["37", "38", "39", "40", "41", "42", "43"],
    category: "Shoes",
    review: "(116 Reviews)",
    rate: 4.9,
    reviewCount: 116,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Tinggi sol : 3.5 cm",
      "Material : High quality kualitas sintesis",
      "Material sole : karet non slip",
    ],
    reviews: [
      Review(
          username: "silvia",
          content:
              "keren banget, bagusss sekali, produknya original, harga nya terjangkau dan gak mahal, ga bakal nyesel belinya sih🫶.",
          rating: 5.5),
      Review(
          username: "kanaya",
          content:
              "Bagus & awet bangettt, dua kali beli disini tidak pernah kecewa karena sebagus itu dan harganya juga terjangkau huhu sukses terus admin!!!.",
          rating: 5.5),
    ],
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
        "segarkan lemari pakaian anda dengan kurta sederhana namun elegan. kurta ini adalah pasangan yang sempurna untuk dikenakan di kantor atau sebagai pakaian sehari-hari yang kasual dan terasa nyaman sepanjang hari",
    image: "images/women fashion/kurta.png",
    price: 199000,
    originalPrice: 250000,
    discountPercentage: 20,
    seller: "Sila Store",
    colors: [Colors.grey, Colors.green, Colors.purple],
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
      "pola : Bergaris",
      "Jenis : Lurus",
      "kain : campuran katun",
    ],
    reviews: [
      Review(
          username: "dea",
          content: "Sangat nyaman untuk di pakai sehari hari deh 👍.",
          rating: 5.0),
      Review(
          username: "rani",
          content: "Motifnya sangat simplen dan elegan.",
          rating: 5.0),
    ],
  ),
  Product(
    title: "Dress",
    description:
        "Bahan brukat furing belakang pinggan karet bungkus tali pita saten nempel bisa ikat LD90cm PJ85cm",
    image: "images/women fashion/lehenga.png",
    price: 150000,
    originalPrice: 180000,
    discountPercentage: 17,
    seller: "bungdedeshop",
    colors: [
      Colors.black,
      Colors.orange,
      Colors.green,
    ],
    sizes: [
      "S",
      "M",
    ],
    category: "WomenFashion",
    review: "(0 Reviews)",
    rate: 3.0,
    reviewCount: 0,
    quantity: 1,
    freeShipping: false,
    returns30Days: true,
    warranty: true,
    specifications: [
      "MOdel Dress : Fit &  flare/skater",
      "Panjang dress : Mini",
      "Cocok untuk acara formal",
    ],
    reviews: [],
  ),
  Product(
    title: "T-Shirt",
    description: "BAHAN TEBAL DAN TIDAK PANAS...",
    image: "images/women fashion/t-shert.png",
    price: 50000,
    originalPrice: 30000,
    discountPercentage: 23,
    seller: "Love Store",
    colors: [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.deepOrangeAccent,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "womenFashion",
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
    ],
    reviews: [
      Review(
          username: "salma",
          content: "Sangat nyaman dan adem banget.",
          rating: 5.0),
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
    price: 150000,
    originalPrice: 170000,
    discountPercentage: 30,
    seller: "yeona",
    colors: [
      Colors.black,
      Colors.brown,
      Colors.grey,
      Colors.white,
    ],
    sizes: ["L", "XL", "XXL"],
    category: "WomenFashion",
    review: "(132 Reviews)",
    rate: 5.0,
    reviewCount: 132,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Tinggi Pinggang : High waist",
      "Model Celana : Kulot",
      "Bahan : semi wall",
    ],
    reviews: [
      Review(
          username: "afisyah ",
          content:
              "kualitas dan warna nya bagus,  baru kali ini pesan dan semoga bisa jadi langganan saya hehe .",
          rating: 4.9),
      Review(
          username: "salma",
          content:
              "worth it banget sihh, nyaman di pakai adem bahanya. buat Tb 165 BB 46 ukuran s pas banget, pengiriman nya cepat juga.",
          rating: 5.0),
    ],
  ),
];
final List<Product> jewelry = [
  Product(
    title: "Evaline Earrings",
    description:
        "Anting adalah salah satu aksesoris yang memerikan dampak signifikan pada sebuah penampilan. GAZALI menawarkan macam gaya anting mulai dari anting klasik hingga studs, hoops, drops, threads, mutiara, dan lainnya",
    image: "images/jewelry/earrings.png",
    price: 850000,
    originalPrice: 900000,
    discountPercentage: 20,
    seller: "Gazali",
    colors: [
      const Color.fromRGBO(255, 193, 7, 1),
      Colors.grey,
      Colors.pink,
    ],
    sizes: ["8mm", "10mm", "12mm", "14mm"],
    category: "Jewelry",
    review: "(25 Reviews)",
    rate: 4.8,
    reviewCount: 32,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Bahan: Gold plated",
      "Tipe: Drop Earrings",
      "Berat: 15 grams"
    ],
    reviews: [
      Review(
          username: "Sintya",
          content: "Produk berkualitas, sesuai dengan foto produknya .",
          rating: 4.7),
      Review(
          username: "lala",
          content: "Warnanya banyak pilihan dan desainnya sangat elegan.",
          rating: 4.8),
      Review(
          username: "nita",
          content: "Pengiriman cepat, kualitas sesuai dengan harga.",
          rating: 4.8),
      Review(
          username: "ani",
          content:
              "desain yang kekinian membuat penampilan semakin menarik, serta kualitas sesuai dengan harga.",
          rating: 4.6),
      Review(
          username: "anisa",
          content:
              "sesuai dengan yang sayang ekspetasiin. bakal mau order lagi sih",
          rating: 4.7),
    ],
  ),
  Product(
    title: "Box Perhiasan Heartbeat Bludru",
    description:
        "Kotak perhiasan berbentuk Heartbeat, tempat menyimpan berbagai macam aksesorismu seperti cincin, gelang, dan kalung agar terhindar dari debu sehingga tersimpan awet tanpa takut rusak dan lecet. Dengan beragam pilihan warna untuk mewarnai hari-harimu",
    image: "images/jewelry/jewelry-box.png",
    price: 15000,
    originalPrice: 250000,
    discountPercentage: 16,
    seller: "Tigadisplay",
    colors: [
      Colors.red,
      Colors.black,
      Colors.blue,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "Jewelry",
    review: "(100 Reviews)",
    rate: 5.0,
    reviewCount: 100,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Bahan: Bludru halus dan Kulit sintetis",
      "Warna: Merah, Hitam, Biru",
      "Kapasitas: Menampung beberapa perhiasan sesuai dengan ukuran yang anda ambil. perkiraan 5-30 perhiasan"
    ],
    reviews: [
      Review(
          username: "Alya",
          content:
              "Sangat membantu untuk menyimpan perhiasan saya dengan rapih dan aman💕👍.",
          rating: 5.0),
      Review(
          username: "Nadia",
          content:
              "Bahan yang berkualitas sehingga nyaman digunakan untuk menyimpan perhiasan saya😍😍.",
          rating: 4.9),
      Review(
          username: "Rina",
          content: "Bagus,Cantik,Rapih pas untuk kalung,cincin dan gelang.",
          rating: 4.8),
      Review(
          username: "Tania",
          content: "Harganya murah kualitas lumayan oke.",
          rating: 4.7),
      Review(
          username: "Rina",
          content:
              "Mantep banget harga murah tapi kualitas bener bener oke👍👍.",
          rating: 4.8),
    ],
  ),
  Product(
    title: "Lanmi Jewelry",
    description:
        "Cincin Titanium Steel Zircon Untuk Lapis Emas Anti Karat Dan Anti Luntur. Wanita Aksessoris Fashion",
    image: "images/jewelry/wedding ring.png",
    price: 50000,
    originalPrice: 65000,
    discountPercentage: 10,
    seller: "LANMI JEWELRY Official Shop",
    colors: [
      Colors.yellow,
      Colors.black,
      Colors.grey,
    ],
    sizes: [
      "6",
      "7",
      "8",
      "9",
    ],
    category: "Jewelry",
    review: "(80 Reviews)",
    rate: 4.7,
    reviewCount: 80,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: false,
    specifications: [
      "Material: Cooper Alloy",
      "Kategori Model : Fashion Style",
      "Detail Items : Ada Zircon dan Permata"
          "Premium Quality & Tahan Lama",
    ],
    reviews: [
      Review(
          username: "tina",
          content:
              "Sangat anggun saat dipakai pas acara formal atau non formal.",
          rating: 4.7),
      Review(username: "Ina", content: "Desainnya Elegan.", rating: 4.7),
      Review(
          username: "Kina",
          content: "Desainnya modern dan simple.",
          rating: 4.8),
      Review(
          username: "viona",
          content: "Harga terjangkau, Kualitasnya oke tidak cepat berkarat.",
          rating: 4.7),
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
      Colors.yellow,
      Colors.orange,
      Colors.grey,
    ],
    sizes: ["45cm", "50cm", "55cm", "60cm"],
    category: "Jewelry",
    review: "(22 Reviews)",
    rate: 3.7,
    reviewCount: 22,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Material: Rose Gold 18K",
      "Gemstone: Pink Clover-shaped",
      "Length: 45 cm, 50cm, 55cm, 60cm"
    ],
    reviews: [
      Review(
          username: "Fina",
          content: "Desainnya unik dan cocok untuk acara formal.",
          rating: 3.7),
      Review(
          username: "Dina",
          content: "Pewarnaannya sangat cantik.",
          rating: 3.7),
      Review(
          username: "Lia",
          content: "Harganya sebanding dengan kualitasnya.",
          rating: 3.8),
    ],
  ),
];
final List<Product> menFashion = [
  Product(
    title: "Jaket Pria Katun Drill Impor",
    description:
        "Jaket Pria Katun Keren Terbaru Katun Drill Impor Kualitas Terbaik",
    image: "images/men fashion/man jacket.png",
    price: 135000,
    originalPrice: 160000,
    discountPercentage: 17,
    seller: "Cutoff Store",
    colors: [
      Colors.brown,
      Colors.black,
    ],
    sizes: ["M", "L", "XL", "XXL"],
    category: "MenFashion",
    review: "(50 Reviews)",
    rate: 4.9,
    reviewCount: 90,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: false,
    specifications: [
      "Material Luar:Katun Drill Impor ",
      "Material dalam : Dormil Kotak Kontak"
          "Memiliki 3 Kantong saku, 2 bagian luar dan 1 bagian dalam sebelah kiri",
      "Menggunakan resleting dan aksesoris kualitas premium",
      "Jahitan setiap sisi kuat dan rapih"
    ],
    reviews: [
      Review(
          username: "Aditya",
          content: "Jaket ini sangat nyaman dipakai.👍",
          rating: 4.9),
      Review(
          username: "Rizky",
          content:
              "Desainnya stylish dan modern. cocok di acara formal ataupun nonformal😊",
          rating: 4.9),
      Review(
          username: "Fajar",
          content: "Kualitas jahitan sangat baik dan rapih👍👍👍",
          rating: 4.9),
      Review(
          username: "Fajar",
          content: "bahannya adem, kualitas oke dengan harga terjangkau❤",
          rating: 4.9),
    ],
  ),
  Product(
    title: "Celana Pria Chino",
    description:
        "Celana ini Slim fit Panjang Kerja Kantor Santai Liburan Cowok Gentle Boy ",
    image: "images/men fashion/pants.png",
    price: 50000,
    originalPrice: 70000,
    discountPercentage: 25,
    seller: "Fairgood Shop",
    colors: [
      Colors.black54,
      Colors.brown,
      Colors.white,
      Colors.grey,
    ],
    sizes: ["S", "M", "L", "XL"],
    category: "MenFashion",
    review: "(100 Reviews)",
    rate: 4.8,
    reviewCount: 50,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Material: Katun twill Strech",
      "Fit: Slim",
      "Motif: Polos"
    ],
    reviews: [
      Review(
          username: "Baldy",
          content: "Pants ini sangat nyaman dan stylish.",
          rating: 4.8),
      Review(
          username: "Dani",
          content: "Cocok untuk acara formal maupun dibuat untuk kerja.",
          rating: 4.8),
      Review(
          username: "Bobby",
          content: "Bahan berkualitas, tidak mudah pudar.",
          rating: 4.8),
      Review(
          username: "Bobby",
          content: "Sangat pas untuk di pakai pergi pergi.",
          rating: 4.8),
    ],
  ),
  Product(
    title: "Kemeja Harley Man Tangan Panjang",
    description:
        "Kemeja relax lengan panjang dari Hooligans dengan material rayon yang lembut",
    image: "images/men fashion/shert.png",
    price: 130000,
    originalPrice: 150000,
    discountPercentage: 22,
    seller: "Harell Official Shop",
    colors: [
      Colors.red,
      Colors.brown,
      Colors.black,
    ],
    sizes: ["M", "L", "XL"],
    category: "MenFashion",
    review: "(516 Reviews)",
    rate: 3.5,
    reviewCount: 200,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Material: Rayon",
      "Fit: Relaxed",
      "Care Instructions: Dry clean only"
    ],
    reviews: [
      Review(
          username: "Bayu",
          content: "Sangat nyaman dipakai kuliah.",
          rating: 3.5),
      Review(
          username: "Indra",
          content: "Motif Polos yang stylish dan kekinian.",
          rating: 3.5),
      Review(
          username: "Rina",
          content: "Ukuran sesuai dengan deskripsi sangan fit dibadan.",
          rating: 3.5),
    ],
  ),
  Product(
    title: "KALE Jovan",
    description: "Kaos Pria Basic Polos Cotton/Lengan Pendek",
    image: "images/men fashion/t-shirt.png",
    price: 150000,
    originalPrice: 180000,
    discountPercentage: 17,
    seller: "KALE CLOTHING Official Store",
    colors: [
      Colors.brown,
      Colors.pink,
      Colors.black,
      Colors.purple,
      Colors.grey,
    ],
    sizes: ["S", "M", "L", "XL", "XXL"],
    category: "MenFashion",
    review: "(1k Reviews)",
    rate: 5.0,
    reviewCount: 1000,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
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
    title: "Titan Bandhan Green Dial Multi Stainless Steel Strap Watch",
    description:
        "Titan telah berkembang pesat sejak tahun 1984 ketika kami memulai dengan satu kategori produk. Saat ini, dengan lebih dari 8.000 karyawan dan sekitar 38.000 orang di seluruh ekosistem Titan, 16 merek, dan lebih dari 2.000 toko ritel, kami berkomitmen untuk memberikan pertumbuhan yang menguntungkan dan bertanggung jawab.",
    image: "images/men fashion/watch.png",
    price: 800000,
    originalPrice: 900000,
    discountPercentage: 10,
    seller: "Memento Titan",
    colors: [
      Colors.brown,
      Colors.green,
      Colors.black,
    ],
    sizes: ["One Size"],
    category: "Men Fashion",
    review: "(4 Reviews)",
    rate: 5.0,
    reviewCount: 100,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
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
          username: "Antoko",
          content: "bagus dan mewah sesuai sama harganya😂.",
          rating: 4.5),
      Review(
          username: "Brian antaka",
          content: "Pengiriman cepat dan bagus banget modelnya.",
          rating: 5.0),
      Review(
          username: "andreansyah",
          content: "Lumayanlah untuk harga segini.",
          rating: 4.5),
      Review(
          username: "Ferdi nando",
          content: "Salah beli warnanya yang dibeli kurang cocok😢.",
          rating: 4.0),
    ],
  ),
];
final List<Product> eletronik = [
  Product(
    title: "Earphone",
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
    title: "Headphone",
    description:
        "Headphone dengan bentuk simple dan ringan, mudah di sesuaikan dengan ukuran kepala masing-masing, Terdapat tombol pada headphone dengan banyak kegunaanya. suara bagus dan jelas, bisa untuk telepon, penyesuaian volume, mendengarkan musik jeda/putar, mendengarkan menggunakan kabel, tombol  untuk play/musik selanjutnya atau sebelumnya",
    image: "images/eletronik/headphone.png",
    price: 94000,
    originalPrice: 165000,
    discountPercentage: 20,
    seller: "AVVIC",
    colors: [
      const Color.fromARGB(255, 255, 205, 187),
      Colors.white,
      Colors.pink,
    ],
    category: "Electronics",
    review: "(500 Reviews)",
    rate: 4.8,
    reviewCount: 500,
    quantity: 1,
    freeShipping: true,
    returns30Days: true,
    warranty: true,
    specifications: [
      "Tipe koneksi : wireless",
      "Tipe Headphone : On ear",
      "kesesuaian Audio : Handphone, komputer & laptop",
      "Maksimum Frekuensi : 20000Hz",
      "Minimum Frekuensi : 45Hz",
      "peringkat sensitivitas : 90dB",
      "Masa garansi : 1 Bulan",
      "Jenis garansi : garansi supplier,"
    ],
    reviews: [
      Review(
          username: "Baldy",
          content:
              "Untuk harga segitu sih worth it yaa, suaranya ga bikin telinga sakit, ukurannya juga udah bisa diatur sendiri, WORTH TO BUY🙌.",
          rating: 5.0),
      Review(
          username: "febri",
          content:
              "Barang sangat bagus dan packingnya juga rapi, bagian connecting juga cepat dan mudah digunakan.",
          rating: 4.9),
      Review(
          username: "Kanaya",
          content:
              "Mashaallah bagus sekali headphonenya, warnanya bagus dan spon ditelinga juga empuk. jadi kalo dengar music kelamaan ga asakit telinga kita. pesannya ppas flash sale jadinya lebih murahh.",
          rating: 4.2),
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
  Product(
    title: "Apple iphone 15 128GB, Pink",
    description:
        "Iphone 15 menghadirkan Dynamic Island, kamera utama 48 MP, dan USB-C - semuanya dalam desain aluminium dan kaca berwarna yang tangguh.",
    image: "images/eletronik/hp.png",
    price: 13999000,
    originalPrice: 16499000,
    discountPercentage: 18,
    seller: "iBox Official Shop",
    colors: [
      Colors.pink,
    ],
    category: "Electronics",
    review: "(1000Reviews)",
    rate: 4.9,
    reviewCount: 1000,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Merk : Apple ",
      "kapasitas penyimpanan : 128GB",
      "Masa garansi : 12 bulan",
      "Jenis garansi : Garansi Resmi",
      "Ukuran layar : 6.1 inches",
    ],
    reviews: [
      Review(
          username: "Agung",
          content:
              "Packaging aman, barang sampai dengan tepat waktu di hari pertama pre order. iphone juga dalam kondisi yang baik tidak ada cacat sedikitpun.",
          rating: 5.0),
      Review(
          username: "recca",
          content:
              "Bagusss banget warna suka bangetttt Mate jadi ga bikin sidik jari nempel, kameranya berasa jauh banget dari 14🥺🫶.",
          rating: 4.9),
      Review(
          username: "Praf",
          content:
              "Awalnya ragu beli online tapi serius pembelian online pertama ini gak bikim kecewa, dan dapat juga kwintasi pembeliannya.",
          rating: 4.9),
    ],
  ),
  Product(
    title: "Laptop ASUS TUF",
    description:
        "ASUS TUF A15 FA506NCR RYZEN 7 7435HS RTX3050 4GB/ 16/GB 512GB W11+OHS 15.6FHD 144HZ IPS RGB BLK-R735B6-O",
    image: "images/eletronik/laptop.png",
    price: 11348000,
    originalPrice: 18000000,
    discountPercentage: 18,
    seller: "AMD official Store",
    colors: [
      Colors.black,
    ],
    category: "Electronics",
    review: "(128 Reviews)",
    rate: 4.9,
    reviewCount: 128,
    quantity: 1,
    freeShipping: true,
    returns30Days: false,
    warranty: true,
    specifications: [
      "Merk : ASUS ",
      "Ukuran layar Laptop  : > 15inci",
      "Tipe Laptop : Gaming",
      "Masa Garansi : 24 Bulan",
    ],
    reviews: [
      Review(
          username: "antila",
          content: "mantap sekali, sudah dapat tas nya juga🔥🔥🔥.",
          rating: 5.0),
      Review(
          username: "Saputra",
          content:
              "Laptop gaming terbaik, pengemasan baik barang diterima dengan baik ada bonus juga.",
          rating: 4.9),
      Review(
          username: "Yogi",
          content:
              "Overall good, barang ori, sesuai dengan spek yang tertera di deskripsi, cuma sayang di pengiriman dari pihak kurir di cancel padahal paling instant.",
          rating: 4.9),
    ],
  ),
];
