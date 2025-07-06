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
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
        child: Container(
          color: AppColors.primaryColor,
          child: Stack(
            children: [
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
              // Action buttons (Add icon), slightly lifted
              if (actions != null)
                Positioned(
                  top: 50, // <- move slightly upward
                  right: 16,
                  child: Row(children: actions!),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
