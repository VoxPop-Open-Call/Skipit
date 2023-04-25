import 'package:flutter/material.dart';

class ItemPickerPage<T> extends StatelessWidget {
  const ItemPickerPage({
    super.key,
    required this.items,
    this.itemToText,
    this.pageTitle,
    this.onItemSelected,
  });

  final List<T> items;
  final String Function(T)? itemToText;
  final String? pageTitle;
  final Function(T)? onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                itemToText != null
                    ? itemToText!.call(items[index])
                    : items[index].toString(),
                style: const TextStyle(color: Colors.black),
                maxLines: 1,
              ),
              onTap: () {
                Navigator.of(context).pop();
                onItemSelected?.call(items[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
