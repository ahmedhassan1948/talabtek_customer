import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class OTPInputField extends StatefulWidget {
  final TextEditingController controller;
  final int length;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double boxSize;
  final double spacing;

  const OTPInputField({
    super.key,
    required this.controller,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.boxSize = 52,
    this.spacing = 8,
  });

  @override
  State<OTPInputField> createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    
    // Sync with main controller
    widget.controller.addListener(_syncFromMainController);
    _syncFromMainController();
  }

  void _syncFromMainController() {
    final text = widget.controller.text;
    for (int i = 0; i < widget.length; i++) {
      final char = i < text.length ? text[i] : '';
      if (_controllers[i].text != char) {
        _controllers[i].text = char;
      }
    }
  }

  void _updateMainController() {
    final text = _controllers.map((c) => c.text).join('');
    if (widget.controller.text != text) {
      widget.controller.text = text;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncFromMainController);
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = widget.fillColor ?? theme.colorScheme.surfaceContainerHighest;
    final borderColor = widget.borderColor ?? theme.colorScheme.outline;
    final focusedBorderColor = widget.focusedBorderColor ?? theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: widget.boxSize.w,
          height: widget.boxSize.w,
          margin: EdgeInsets.symmetric(horizontal: widget.spacing.w / 2),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            enabled: true,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: fillColor,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: focusedBorderColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < widget.length - 1) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                  _updateMainController();
                  if (widget.onCompleted != null) {
                    widget.onCompleted!(widget.controller.text);
                  }
                }
              }
              _updateMainController();
              if (widget.onChanged != null) {
                widget.onChanged!(widget.controller.text);
              }
            },
            onTap: () {
              // Select all text on tap for easy replacement
              _controllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controllers[index].text.length,
              );
            },
          ),
        );
      }),
    );
  }
}

class PinCodeField extends StatefulWidget {
  final int length;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double boxSize;
  final double spacing;
  final bool obscureText;
  final Widget? obscureWidget;

  const PinCodeField({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.onChanged,
    this.controller,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.boxSize = 60,
    this.spacing = 12,
    this.obscureText = false,
    this.obscureWidget,
  });

  @override
  State<PinCodeField> createState() => _PinCodeFieldState();
}

class _PinCodeFieldState extends State<PinCodeField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    
    if (widget.controller != null) {
      widget.controller!.addListener(_syncFromMainController);
      _syncFromMainController();
    }
  }

  void _syncFromMainController() {
    if (widget.controller == null) return;
    final text = widget.controller!.text;
    for (int i = 0; i < widget.length; i++) {
      final char = i < text.length ? text[i] : '';
      if (_controllers[i].text != char) {
        _controllers[i].text = char;
      }
    }
  }

  void _updateMainController() {
    if (widget.controller == null) return;
    final text = _controllers.map((c) => c.text).join('');
    if (widget.controller!.text != text) {
      widget.controller!.text = text;
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(_syncFromMainController);
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = widget.fillColor ?? theme.colorScheme.surfaceContainerHighest;
    final borderColor = widget.borderColor ?? theme.colorScheme.outline;
    final focusedBorderColor = widget.focusedBorderColor ?? theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: widget.boxSize.w,
          height: widget.boxSize.w,
          margin: EdgeInsets.symmetric(horizontal: widget.spacing.w / 2),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            obscureText: widget.obscureText,
            obscuringCharacter: widget.obscureWidget != null ? '' : '●',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: fillColor,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: focusedBorderColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < widget.length - 1) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                  _updateMainController();
                  if (widget.onCompleted != null) {
                    widget.onCompleted!(_controllers.map((c) => c.text).join(''));
                  }
                }
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
              _updateMainController();
              if (widget.onChanged != null) {
                widget.onChanged!(_controllers.map((c) => c.text).join(''));
              }
            },
            onTap: () {
              _controllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controllers[index].text.length,
              );
            },
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
          ),
        );
      }),
    );
  }
}