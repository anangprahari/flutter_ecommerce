import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/Home/Widget/product_cart.dart';
import 'package:ecommerce_mobile_app/screens/Home/Widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan intl untuk format harga

import '../../models/category.dart'; // Untuk mengambil kategori
import 'Widget/home_app_bar.dart';
import 'Widget/image_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlider = 0;
  int selectedIndex = 0;
  TextEditingController searchController = TextEditingController();
  List<Product> filteredProducts = all; // Awalnya menampilkan semua produk

  // Definisi selectcategories, sesuai dengan kategori produk
  List<List<Product>> selectcategories = [
    all, // Semua produk
    shoes, // Produk kategori sepatu
    beauty, // Produk kategori kecantikan
    womenFashion, // Produk kategori busana wanita
    jewelry, // Produk kategori perhiasan
    menFashion, // Produk kategori busana pria
    eletronik // Produk kategori perhiasan
  ];

  // Fungsi pencarian produk dan kategori
  void _searchProduct(String query) {
    setState(() {
      // Filter produk berdasarkan nama
      filteredProducts = all
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Filter kategori jika pencarian produk tidak menemukan hasil
      if (filteredProducts.isEmpty) {
        for (int i = 0; i < categoriesList.length; i++) {
          if (categoriesList[i]
              .title
              .toLowerCase()
              .contains(query.toLowerCase())) {
            selectedIndex = i;
            filteredProducts = selectcategories[selectedIndex];
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              // for custom appbar
              const CustomAppBar(),
              const SizedBox(height: 20),
              // for search bar
              MySearchBAR(
                  onSearch:
                      _searchProduct), // Modifikasi Search Bar agar bisa menerima input pencarian
              const SizedBox(height: 20),
              ImageSlider(
                currentSlide: currentSlider,
                onChange: (value) {
                  setState(() {
                    currentSlider = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // for category selection
              categoryItems(),

              const SizedBox(height: 20),
              if (selectedIndex == 0)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Spesial untukmu",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),

              // Menampilkan pesan jika tidak ada hasil pencarian
              if (filteredProducts.isEmpty)
                const Center(
                  child: Text(
                    "Tidak ditemukan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                )
              else
                // Gridview produk akan menggunakan 'filteredProducts'
                GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        0.54, // Mengurangi ratio child untuk menghindari overflow
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount:
                      filteredProducts.length, // Tampilkan produk yang difilter
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    // Format harga menggunakan NumberFormat
                    final formattedPrice = NumberFormat.currency(
                      locale: 'id',
                      symbol: 'Rp. ',
                      decimalDigits: 0,
                    ).format(product.price);

                    return ProductCard(
                      product: product,
                      priceFormatted:
                          formattedPrice, // Mengirim harga terformat ke ProductCard
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox categoryItems() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                filteredProducts = selectcategories[
                    selectedIndex]; // Update produk berdasarkan kategori
              });
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: selectedIndex == index
                    ? Colors.blue[200]
                    : Colors.transparent,
              ),
              child: Column(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(categoriesList[index].image),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    categoriesList[index].title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
