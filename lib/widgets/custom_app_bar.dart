import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double borderRadius;
  final double height;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title,
    this.borderRadius = 20.0,
    this.height = 112.0,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Gradient Background + Custom Painted Bottom Border
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
            child: CustomPaint(
              painter: _BottomBorderPainter(
                borderRadius: borderRadius,
                borderColor: AppColors.blackColor,
              ),
              child: Container(
                width: double.infinity,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gradientColor2, AppColors.gradientColor1],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),

          // Centered Title
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                title ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Action Buttons
          if (actions != null)
            Positioned(
              top: 50,
              right: 16,
              child: Row(children: actions!),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _BottomBorderPainter extends CustomPainter {
  final double borderRadius;
  final Color borderColor;

  _BottomBorderPainter({
    required this.borderRadius,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Bottom-left curve
    path.moveTo(0, size.height - borderRadius);
    path.quadraticBezierTo(
      0,
      size.height,
      borderRadius,
      size.height,
    );

    // Straight line
    path.lineTo(size.width - borderRadius, size.height);

    // Bottom-right curve
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - borderRadius,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BottomBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.borderRadius != borderRadius;
  }
}
