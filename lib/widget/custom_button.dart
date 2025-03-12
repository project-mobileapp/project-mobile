import 'package:flutter/material.dart';

class AnimatedProgressButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final Future<void> Function() onPressed;

  const AnimatedProgressButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  _AnimatedProgressButtonState createState() => _AnimatedProgressButtonState();
}

class _AnimatedProgressButtonState extends State<AnimatedProgressButton> {
  bool _isLoading = false;
  bool _isHovered = false;

  void _handlePress() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await widget.onPressed();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handlePress,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered ? Colors.white : Colors.amber[700],
            foregroundColor: _isHovered ? Colors.amber[700] : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.amber), // เพิ่มเส้นขอบ
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.amber, strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: _isHovered ? Colors.amber[700] : Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isHovered ? Colors.amber[700] : Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
