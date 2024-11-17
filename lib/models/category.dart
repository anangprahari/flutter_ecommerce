class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });
}

final List<Category> categoriesList = [
  Category(
    title: "Semua",
    image: "images/all.png",
  ),
  Category(
    title: "Sepatu",
    image: "images/shoes.png",
  ),
  Category(
    title: "Kecantikan",
    image: "images/beauty.png",
  ),
  Category(
    title: "Pakaian Wanita",
    image: "images/image1.png",
  ),
  Category(
    title: "Perhiasan",
    image: "images/jewelry.png",
  ),
  Category(
    title: "Pakaian Pria",
    image: "images/men.png",
  ),
  Category(
    title: "Eletronik",
    image: "images/eletronik.png",
  ),
];
