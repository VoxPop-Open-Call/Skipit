import 'package:flutter/material.dart';
import 'package:lisbon_travel/constants/colors.dart';

class ExpandableButton extends StatefulWidget {
  final List<ExpandableButton>? subButtons;
  final bool isSecondary;
  final VoidCallback? onTap;
  final String? text;
  final Duration duration;
  final bool show;
  final IconData icon;
  final double size;
  final double baseSize;
  final int index;

  const ExpandableButton({
    required this.icon,
    required this.index,
    this.text,
    this.duration = const Duration(milliseconds: 300),
    this.show = false,
    this.size = 60,
    this.baseSize = 60,
    this.isSecondary = false,
    this.subButtons,
    this.onTap,
    super.key,
  });

  @override
  State<ExpandableButton> createState() => _ExpandableButtonState();
}

class _ExpandableButtonState extends State<ExpandableButton> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    double right;
    double bottom;

    if (!widget.isSecondary) {
      right = (widget.baseSize / 2) - (widget.size / 2);
      bottom = widget.show ? widget.size * (1 + 0.3) * widget.index : 0;
    } else {
      right = widget.show ? widget.size * (1 + 0.15) * widget.index : 0;
      bottom = (widget.baseSize / 2) - (widget.size / 2);
    }
    return AnimatedPositioned(
      duration: widget.duration,
      right: right,
      bottom: bottom,
      child: widget.subButtons != null ? _getMultiChild() : _getSingleChild(),
    );
  }

  Widget _getMultiChild() {
    if (!widget.show) {
      isTapped = false;
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        SizedBox(
          width: widget.baseSize * (widget.subButtons!.length + 1) +
              (widget.baseSize * 0.15 * widget.subButtons!.length),
          height: widget.baseSize,
        ),
        ...?widget.subButtons,
        _getSingleChild(isFromMulti: true),
      ],
    );
  }

  Widget _getSingleChild({bool isFromMulti = false}) {
    return AnimatedOpacity(
      duration: widget.duration,
      opacity: widget.show ? 1 : 0,
      child: Row(
        children: [
          if ((!isFromMulti && !widget.isSecondary) ||
              (isFromMulti && !widget.isSecondary && !isTapped))
            _buildSideText(),
          GestureDetector(
            onTap: () {
              if (isFromMulti) {
                setState(() {
                  isTapped = !isTapped;
                });
              }
              widget.onTap?.call();
            },
            child: Material(
              elevation: 1,
              color: isFromMulti && isTapped
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.white,
              borderRadius: BorderRadius.circular(5),
              child: AnimatedContainer(
                duration: widget.duration,
                height: widget.size,
                width: widget.size,
                child: Icon(
                  widget.icon,
                  color: AppColors.primaryButton,
                  size: widget.size * 0.9 / 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideText() {
    if (widget.text == null || widget.text == '') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        borderRadius: BorderRadius.circular(4),
        elevation: 1,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            widget.text!,
            style: const TextStyle(
              color: AppColors.primaryButton,
            ),
          ),
        ),
      ),
    );
  }
}
