import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyImageSlider extends StatefulWidget {
  final Function(int) onChange;
  final String image;
  const MyImageSlider({
    Key? key,
    required this.image,
    required this.onChange,
  }) : super(key: key);

  @override
  _MyImageSliderState createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              widget.onChange(index);
            },
            itemCount: 5, // Assuming you have multiple images
            itemBuilder: (context, index) {
              return Hero(
                tag: widget.image,
                child: Image.asset(widget.image),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5, // Replace with the actual number of images
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.black
                    : Colors
                        .grey[400], // Current slide is black, others are gray
              ),
            ),
          ),
        ),
      ],
    );
  }
}
