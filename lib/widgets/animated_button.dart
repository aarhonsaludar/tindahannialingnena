import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final Widget? loadingWidget;
  final Duration animationDuration;

  const AnimatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.isLoading = false,
    this.loadingWidget,
    this.animationDuration = const Duration(milliseconds: 150),
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.value = 1.0; // Start at the default state
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isLoading) return;
    setState(() => _isPressed = true);
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isLoading) return;
    setState(() => _isPressed = false);
    _controller.forward();
    widget.onPressed();
  }

  void _onTapCancel() {
    if (widget.isLoading) return;
    setState(() => _isPressed = false);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Default color to theme's primary if not specified
    final buttonColor = widget.color ?? theme.colorScheme.primary;
    final buttonTextColor = widget.textColor ?? Colors.white;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedContainer(
              duration: widget.animationDuration,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: _isPressed
                    ? buttonColor.withOpacity(0.8)
                    : buttonColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
              ),
              child: Center(
                child: widget.isLoading
                    ? widget.loadingWidget ??
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor),
                          ),
                        )
                    : DefaultTextStyle(
                        style: TextStyle(
                          color: buttonTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        child: widget.child,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
