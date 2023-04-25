import 'package:flutter/material.dart';
import 'package:lisbon_travel/constants/colors.dart';

class SwitchSettingOption extends StatefulWidget {
  const SwitchSettingOption({
    super.key,
    required this.name,
    required this.initialValue,
    this.onChange,
  });

  final String name;
  final Function(bool value)? onChange;
  final bool initialValue;

  @override
  State<SwitchSettingOption> createState() => _SwitchSettingOptionState();
}

class _SwitchSettingOptionState extends State<SwitchSettingOption> {
  late bool value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      dense: true,
      visualDensity: VisualDensity.compact,
      activeColor: AppColors.primary,
      title: Text(
        widget.name,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      onChanged: (newValue) {
        setState(() {
          value = newValue;
        });
        widget.onChange?.call(newValue);
      },
    );
  }
}
