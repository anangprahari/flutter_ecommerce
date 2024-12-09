import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/Home/Widget/product_cart.dart';
import 'package:ecommerce_mobile_app/screens/Home/Widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../models/category.dart';
import 'Widget/home_app_bar.dart';
import 'Widget/image_slider.dart';

// Layar Utama Aplikasi E-Commerce
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variabel untuk mengontrol slider dan indeks kategori yang dipilih
  int currentSlider = 0;
  int selectedIndex = 0;

  // Pengontrol teks untuk fungsi pencarian
  TextEditingController searchController = TextEditingController();

  // Daftar produk yang difilter untuk ditampilkan
  List<Product> filteredProducts = all;

  // Pengontrol scroll untuk layar
  final ScrollController _scrollController = ScrollController();

  // Variabel untuk menyimpan filter yang dipilih pengguna
  String selectedCategory = "Semua";
  String selectedShipping = "Semua";
  List<String> selectedFeatures = [];
  int? minPrice;
  int? maxPrice;

  // Daftar kategori produk yang dapat dipilih
  List<List<Product>> selectcategories = [
    all, // Semua produk
    shoes, // Sepatu
    beauty, // Kecantikan
    womenFashion, // Pakaian Wanita
    jewelry, // Perhiasan
    menFashion, // Pakaian Pria
    eletronik // Elektronik
  ];

  // Metode untuk mencari produk berdasarkan query
  void _searchProduct(String query) {
    setState(() {
      // Filter produk berdasarkan judul atau deskripsi yang cocok
      filteredProducts = all
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Jika tidak ada produk ditemukan, coba cari berdasarkan kategori
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

  // Metode untuk menerapkan filter pada produk
  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      // Filter produk dengan kriteria yang kompleks
      filteredProducts = all.where((product) {
        // Pencocokan kategori yang komprehensif
        bool categoryMatch = filters['category'] == "Semua" ||
            product.category.toLowerCase() ==
                filters['category'].toLowerCase() ||
            (filters['category'] == "Pakaian Wanita" &&
                product.category.toLowerCase().contains("woman")) ||
            (filters['category'] == "Pakaian Pria" &&
                product.category.toLowerCase().contains("men")) ||
            (filters['category'] == "Elektronik" &&
                product.category.toLowerCase().contains("electronics"));

        // Filter pengiriman dengan opsi detail
        bool shippingMatch = filters['shipping'] == "Semua" ||
            (filters['shipping'] == "Gratis Ongkir" && product.freeShipping) ||
            (filters['shipping'] == "Pengembalian 30 Hari" &&
                product.returns30Days);

        // Filter fitur dengan logika yang disempurnakan
        bool featuresMatch = filters['features'] == null ||
            filters['features'].isEmpty ||
            filters['features'].every((feature) {
              switch (feature) {
                case 'Garansi':
                  return product.warranty;
                case 'Spesifikasi Tinggi':
                  return product.specifications.isNotEmpty;
                default:
                  return false;
              }
            });

        // Filter rentang harga dengan keamanan null
        bool priceMatch = (filters['minPrice'] == null ||
                product.price >= (filters['minPrice'] ?? 0)) &&
            (filters['maxPrice'] == null ||
                product.price <= (filters['maxPrice'] ?? double.infinity));

        return categoryMatch && shippingMatch && featuresMatch && priceMatch;
      }).toList();

      // Perbarui filter yang dipilih untuk antarmuka pengguna
      selectedCategory = filters['category'] ?? "Semua";
      selectedShipping = filters['shipping'] ?? "Semua";
      selectedFeatures = filters['features'] ?? [];
      minPrice = filters['minPrice'];
      maxPrice = filters['maxPrice'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna latar belakang ringan untuk tema aplikasi
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          // Fungsi refresh untuk menyegarkan halaman
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              // Kembalikan ke kondisi awal
              filteredProducts = all;
              selectedIndex = 0;
              selectedCategory = "Semua";
              selectedShipping = "Semua";
              selectedFeatures = [];
              minPrice = null;
              maxPrice = null;
            });
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Bagian atas layar dengan elemen-elemen statis
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppBar kustom
                      const CustomAppBar(),
                      const SizedBox(height: 20),
                      // Bilah pencarian dengan fitur filter
                      MySearchBAR(
                        onSearch: _searchProduct,
                        onApplyFilters: _applyFilters,
                        initialFilters: {
                          "category": selectedCategory,
                          "shipping": selectedShipping,
                          "features": selectedFeatures,
                          "minPrice": minPrice,
                          "maxPrice": maxPrice,
                        },
                      ),
                      const SizedBox(height: 20),
                      // Slider gambar promosi
                      ImageSlider(
                        currentSlide: currentSlider,
                        onChange: (value) {
                          setState(() {
                            currentSlider = value;
                          });
                        },
                      ),
                      const SizedBox(height: 25),
                      // Bagian kategori produk
                      _buildCategorySection(),
                      const SizedBox(height: 25),
                      // Header spesial untuk kategori utama
                      if (selectedIndex == 0) _buildSpecialHeader(),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              // Tampilan produk kosong jika tidak ada produk
              if (filteredProducts.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Tidak Ditemukan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Grid untuk menampilkan produk
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dua kolom
                      childAspectRatio: 0.54, // Rasio tinggi-lebar
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = filteredProducts[index];
                        // Format harga dalam mata uang Rupiah
                        final formattedPrice = NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp. ',
                          decimalDigits: 0,
                        ).format(product.price);

                        // Kartu produk untuk setiap item
                        return ProductCard(
                          product: product,
                          priceFormatted: formattedPrice,
                        );
                      },
                      childCount: filteredProducts.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk header spesial di bagian atas
  Widget _buildSpecialHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Judul bagian spesial
        const Text(
          "Spesial untukmu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        // Tombol untuk melihat semua produk
        TextButton(
          onPressed: () {
            // TODO: Implementasikan fungsi melihat semua produk
          },
          child: const Text(
            "Lihat Semua",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: kprimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan kategori produk
  Widget _buildCategorySection() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              // Aksi saat kategori dipilih
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  filteredProducts = selectcategories[selectedIndex];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // Desain container kategori dengan animasi
                  borderRadius: BorderRadius.circular(20),
                  color: selectedIndex == index
                      ? kprimaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  border: Border.all(
                    color: selectedIndex == index
                        ? kprimaryColor
                        : Colors.grey.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gambar ikon kategori
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(categoriesList[index].image),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Teks nama kategori
                    Text(
                      categoriesList[index].title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: selectedIndex == index
                            ? kprimaryColor
                            : Colors.black87,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
