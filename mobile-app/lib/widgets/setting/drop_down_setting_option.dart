import 'package:flutter/material.dart';

class DropDownSettingsOption<T> extends StatefulWidget {
  const DropDownSettingsOption({
    super.key,
    required this.name,
    required this.items,
    required this.onChange,
    this.initialValue,
    this.textFromItem,
  });

  final String name;
  final T? initialValue;
  final List<T> items;
  final Function(T selected) onChange;
  final String Function(T item)? textFromItem;

  @override
  State<DropDownSettingsOption<T>> createState() =>
      _DropDownSettingsOptionState<T>();
}

class _DropDownSettingsOptionState<T> extends State<DropDownSettingsOption<T>> {
  T? value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(
        widget.name,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: DropdownButton<T>(
        value: value,
        items: widget.items.map((T item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              widget.textFromItem != null
                  ? widget.textFromItem!.call(item)
                  : item.toString(),
            ),
          );
        }).toList(growable: false),
        onChanged: (T? selected) {
          if (selected == null) return;

          setState(() {
            value = selected;
          });
          widget.onChange.call(selected);
        },
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        underline: const SizedBox.shrink(),
        isDense: true,
      ),
    );
  }
}
