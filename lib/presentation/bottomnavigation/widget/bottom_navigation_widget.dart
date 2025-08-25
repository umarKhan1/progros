import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const double baseHeight = 64;
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Material(
      color: Colors.white,
      elevation: 8,
      child: SizedBox(
        height: baseHeight + bottomInset,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x11000000))),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavItem(
                      selected: currentIndex == 0,
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      onTap: () => onTap(0),
                    ),
                    _NavItem(
                      selected: currentIndex == 1,
                      icon: Icons.favorite_border,
                      selectedIcon: Icons.favorite,
                      onTap: () => onTap(1),
                    ),
                    _NavItem(
                      selected: currentIndex == 2,
                      icon: Icons.shopping_bag_outlined,
                      selectedIcon: Icons.shopping_bag,
                      onTap: () => onTap(2),
                    ),
                    _NavItem(
                      selected: currentIndex == 3,
                      icon: Icons.person_outline,
                      selectedIcon: Icons.person,
                      onTap: () => onTap(3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.selected,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final IconData selectedIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF22C55E);
    const gray = Color(0xFF9CA3AF);

    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: SizedBox(
        width: 72,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (selected)
              const Positioned(
                top: 3, // arrow just above the icon, inside the bar
                child: _DownArrow(),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              transform: Matrix4.translationValues(
                0,
                selected ? 10 : 0,
                0,
              ), // move icon down if selected
              child: Icon(
                selected ? selectedIcon : icon,
                size: selected ? 28 : 26,
                color: selected ? green : gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownArrow extends StatelessWidget {
  const _DownArrow();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 16, // smaller arrow
      height: 12,
      child: CustomPaint(painter: _DownArrowPainter()),
    );
  }
}

class _DownArrowPainter extends CustomPainter {
  const _DownArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // triangle pointing DOWN
    final Path path = Path()
      ..moveTo(size.width / 2, size.height) // tip at bottom center
      ..lineTo(size.width, 0) // top right
      ..lineTo(0, 0) // top left
      ..close();

    final Paint glow = Paint()
      ..color = const Color(0x8822C55E)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(path, glow);

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint body = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF34D399), Color(0xFF22C55E)],
      ).createShader(rect);
    canvas.drawPath(path, body);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
