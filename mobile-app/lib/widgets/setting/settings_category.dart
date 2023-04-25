import 'package:flutter/material.dart';
import 'package:lisbon_travel/constants/colors.dart';

class SettingsCategory extends StatelessWidget {
  const SettingsCategory({
    super.key,
    required this.name,
    this.options,
  });

  final List<Widget>? options;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            name,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 20,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Divider(height: 10),
        ),
        ...?options,
        const SizedBox(height: 20),
      ],
    );
  }
}
