import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lisbon_travel/constants/colors.dart';

class LocationSearchField extends StatefulWidget {
  const LocationSearchField({
    this.hint,
    this.actions = const [],
    this.isDestination = false,
    required this.leadingIcon,
    this.onQueryChanged,
    this.controller,
    this.focusNode,
    this.autoDisposeController = false,
    this.onClear,
    this.padding,
    super.key,
  });

  final List<Widget> actions;
  final Widget leadingIcon;
  final bool isDestination;
  final String? hint;
  final FocusNode? focusNode;
  final bool autoDisposeController;
  final Function(String query)? onQueryChanged;
  final Function()? onClear;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  bool isTextEmpty = true;

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _textController.addListener(textChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
      child: TextField(
        focusNode: widget.focusNode,
        controller: _textController,
        onChanged: (query) {
          EasyDebounce.debounce(
            'search',
            const Duration(milliseconds: 500),
            () => widget.onQueryChanged?.call(query),
          );
        },
        style: const TextStyle(
          color: Colors.black,
          fontSize: 19,
        ),
        maxLines: 1,
        decoration: InputDecoration(
          fillColor: AppColors.backgroundGray,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 13,
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(
            height: 1,
            fontSize: 18,
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.backgroundGray,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.primary,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          prefixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              // FloatingSearchBarAction.back(
              //   showIfClosed: false,
              //   color: Colors.pink,
              // ),
              const SizedBox(width: 10),
              widget.leadingIcon,
              const SizedBox(width: 3),
            ],
          ),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: !isTextEmpty
                    ? IconButton(
                        onPressed: () {
                          _textController.clear();
                          widget.onClear?.call();
                        },
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          FontAwesomeIcons.xmark,
                          color: Colors.black,
                        ),
                      )
                    : const SizedBox(),
              ),
              ...widget.actions,
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }

  void textChangedListener() {
    if (!isTextEmpty && _textController.text == '') {
      setState(() {
        isTextEmpty = true;
      });
      return;
    }

    if (isTextEmpty && _textController.text != '') {
      setState(() {
        isTextEmpty = false;
      });
      return;
    }
  }

  @override
  void dispose() {
    _textController.removeListener(textChangedListener);
    if (widget.autoDisposeController || widget.controller == null) {
      _textController.dispose();
    }
    super.dispose();
  }
}
