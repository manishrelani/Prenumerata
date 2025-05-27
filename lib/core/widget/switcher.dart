import 'package:flutter/material.dart';

class SlideSwitcher extends StatefulWidget {
  final List<SwitcherItem> items;
  final int initialIndex;
  final Function(int) onChanged;
  final Duration animationDuration;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final double height;
  final double borderRadius;

  const SlideSwitcher({
    super.key,
    required this.items,
    this.initialIndex = 0,
    required this.onChanged,
    this.animationDuration = const Duration(milliseconds: 300),
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.selectedColor = const Color(0xFF007AFF),
    this.unselectedColor = Colors.white70,
    this.height = 40,
    this.borderRadius = 20,
  });

  @override
  State<SlideSwitcher> createState() => _SlideSwitcherState();
}

class _SlideSwitcherState extends State<SlideSwitcher> with SingleTickerProviderStateMixin {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTap(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      widget.onChanged(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,

      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          List<double> tabWidths = List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            final isSelected = index == _selectedIndex;
            double iconWidth = 22.0;
            double textWidth = 0.0;
            if (isSelected && item.title.isNotEmpty) {
              final textPainter = TextPainter(
                text: TextSpan(
                  text: item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              )..layout();
              textWidth = textPainter.width + 8.0; // 8 for spacing
            }
            // Add horizontal padding
            return iconWidth + textWidth + 20.0;
          });

          // Calculate left offset for the slider
          double sliderLeft = 0;
          for (int i = 0; i < _selectedIndex; i++) {
            sliderLeft += tabWidths[i];
          }
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              AnimatedPositioned(
                duration: widget.animationDuration,
                curve: Curves.ease,
                left: sliderLeft,
                child: Container(
                  width: tabWidths[_selectedIndex],
                  height: widget.height + 3,
                  decoration: BoxDecoration(
                    color: widget.selectedColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                ),
              ),

              // Items row to establish the layout
              Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.items.asMap().entries.map((entry) {
                  int index = entry.key;
                  SwitcherItem item = entry.value;
                  bool isSelected = index == _selectedIndex;

                  return AnimatedContainer(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    width: tabWidths[index],
                    height: widget.height,
                    child: GestureDetector(
                      onTap: () => _onTap(index),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius,
                          ),
                        ),
                        child: isSelected
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item.selectedIcon,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),

                                  Flexible(
                                    child: Text(
                                      item.title,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              )
                            : Icon(
                                item.unselectedIcon,
                                size: 16,
                                color: widget.unselectedColor,
                              ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Sliding background indicator - positioned absolutely
            ],
          );
        },
      ),
    );
  }
}

class SwitcherItem {
  final String title;
  final IconData selectedIcon;
  final IconData unselectedIcon;

  const SwitcherItem({
    required this.title,
    required this.selectedIcon,
    required this.unselectedIcon,
  });
}
