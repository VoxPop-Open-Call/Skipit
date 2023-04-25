import 'package:flutter/material.dart';

class ClassicSettingsOption extends StatelessWidget {
  const ClassicSettingsOption({
    super.key,
    required this.name,
    this.onTap,
    this.trailingText,
  });

  final String name;
  final String? trailingText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null) ...{
              Center(
                child: Text(
                  trailingText!,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
            },
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
