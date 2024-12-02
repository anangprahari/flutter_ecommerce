import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../constants.dart';

class MySearchBAR extends StatefulWidget {
  final Function(String) onSearch;
  final Function(Map<String, dynamic>) onApplyFilters;
  final Map<String, dynamic>? initialFilters;

  const MySearchBAR({
    super.key,
    required this.onSearch,
    required this.onApplyFilters,
    this.initialFilters,
  });

  @override
  State<MySearchBAR> createState() => _MySearchBARState();
}

class _MySearchBARState extends State<MySearchBAR>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showClearButton = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  // Filter state
  late String selectedCategory;
  late String selectedShipping;
  late List<String> selectedFeatures;
  int? minPrice;
  int? maxPrice;

  @override
  void initState() {
    super.initState();

    // Initialize filter state from initial filters
    selectedCategory = widget.initialFilters?['category'] ?? "Semua";
    selectedShipping = widget.initialFilters?['shipping'] ?? "Semua";
    selectedFeatures =
        List<String>.from(widget.initialFilters?['features'] ?? []);
    minPrice = widget.initialFilters?['minPrice'];
    maxPrice = widget.initialFilters?['maxPrice'];

    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
    });

    // Tambahkan kembali AnimationController untuk pulse effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });

    _animationController.forward();
  }

  void _applyFilters() {
    final filters = {
      "category": selectedCategory,
      "shipping": selectedShipping,
      "features": selectedFeatures,
      "minPrice": minPrice,
      "maxPrice": maxPrice,
    };
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Pencarian",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 0.5),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildFilterSection(
                        "Kategori",
                        [
                          "Semua",
                          "Electronics",
                          "Pakaian Wanita",
                          "Pakaian Pria"
                        ],
                        (value) => setModalState(() {
                          selectedCategory = value;
                        }),
                        selectedCategory,
                      ),
                      const SizedBox(height: 32),
                      _buildFilterSection(
                        "Pengiriman",
                        ["Semua", "Gratis Ongkir", "Pengembalian 30 Hari"],
                        (value) => setModalState(() {
                          selectedShipping = value;
                        }),
                        selectedShipping,
                      ),
                      const SizedBox(height: 32),
                      _buildMultiSelectFilterSection(
                        "Fitur Produk",
                        ["Garansi", "Spesifikasi Tinggi"],
                        (selected) => setModalState(() {
                          if (selectedFeatures.contains(selected)) {
                            selectedFeatures.remove(selected);
                          } else {
                            selectedFeatures.add(selected);
                          }
                        }),
                        selectedFeatures,
                      ),
                      const SizedBox(height: 32),
                      _buildPriceRangeFilter(setModalState),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                      shadowColor: kprimaryColor.withOpacity(0.4),
                    ),
                    child: Text(
                      "Terapkan Filter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options,
      ValueChanged<String> onChanged, String selectedOption) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: selectedOption == option,
              onSelected: (_) => onChanged(option),
              backgroundColor: Colors.grey[100],
              selectedColor: kprimaryColor.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              labelStyle: TextStyle(
                color:
                    selectedOption == option ? kprimaryColor : Colors.grey[800],
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selectedOption == option
                      ? kprimaryColor.withOpacity(0.5)
                      : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMultiSelectFilterSection(String title, List<String> options,
      ValueChanged<String> onSelected, List<String> selectedOptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: selectedOptions.contains(option),
              onSelected: (_) => onSelected(option),
              backgroundColor: Colors.grey[100],
              selectedColor: kprimaryColor.withOpacity(0.2),
              checkmarkColor: kprimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              labelStyle: TextStyle(
                color: selectedOptions.contains(option)
                    ? kprimaryColor
                    : Colors.grey[800],
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selectedOptions.contains(option)
                      ? kprimaryColor.withOpacity(0.5)
                      : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rentang Harga",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Min",
                  prefixText: "Rp ",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) =>
                    setModalState(() => minPrice = int.tryParse(value)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "-",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Maks",
                  prefixText: "Rp ",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) =>
                    setState(() => maxPrice = int.tryParse(value)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _searchController.text.isEmpty ? _pulseAnimation.value : 1.0,
          child: Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Icon(
                    Icons.search,
                    color: kprimaryColor.withOpacity(0.7),
                    size: 24,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Cari Produk Favoritmu...",
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: widget.onSearch,
                  ),
                ),
                if (_showClearButton)
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                    },
                  ),
                IconButton(
                  onPressed: _showFilterBottomSheet,
                  icon: Icon(
                    Icons.tune,
                    color: kprimaryColor,
                    size: 24,
                  ),
                  tooltip: "Filter",
                ),
              ],
            ),
          ),
        );
      },
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
        );
  }

  @override
  void dispose() {
   _animationController.dispose();
  _searchController.dispose();
  _searchFocusNode.dispose();
  super.dispose();
  }
}
