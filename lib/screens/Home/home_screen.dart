import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/Home/Widget/product_cart.dart';
import 'package:ecommerce_mobile_app/screens/Home/Widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan intl untuk format harga
import '../../../constants.dart';
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
  List<Product> filteredProducts = all;
  final ScrollController _scrollController = ScrollController();

  List<List<Product>> selectcategories = [
    all,
    shoes,
    beauty,
    womenFashion,
    jewelry,
    menFashion,
    eletronik
  ];

  void _searchProduct(String query) {
    setState(() {
      filteredProducts = all
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Implement refresh logic here
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              filteredProducts = all;
              selectedIndex = 0;
            });
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAppBar(),
                      const SizedBox(height: 20),
                      MySearchBAR(onSearch: _searchProduct),
                      const SizedBox(height: 20),
                      ImageSlider(
                        currentSlide: currentSlider,
                        onChange: (value) {
                          setState(() {
                            currentSlider = value;
                          });
                        },
                      ),
                      const SizedBox(height: 25),
                      _buildCategorySection(),
                      const SizedBox(height: 25),
                      if (selectedIndex == 0) _buildSpecialHeader(),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
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
                          "Tidak ditemukan",
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
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.54,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = filteredProducts[index];
                        final formattedPrice = NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp. ',
                          decimalDigits: 0,
                        ).format(product.price);

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

  Widget _buildSpecialHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Spesial untukmu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          onPressed: () {
            // Implement see all functionality
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
