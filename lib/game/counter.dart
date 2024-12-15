import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final int minValue;
  final Function(int) onChanged;

  const CounterButton({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.minValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: 56,
          width: 160,
          decoration: BoxDecoration(
            color: const Color(0xFF6B4EFF),
            borderRadius: BorderRadius.circular(28),
            // image: DecorationImage(
            //   image: AssetImage(Assets.imagesBalanceBg),
            //   fit: BoxFit.fill,
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.15),
                offset: const Offset(0, -1),
                blurRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                icon: Icons.remove,
                onPressed: value > minValue
                    ? () => onChanged(value - (label == 'Bet size' ? 10 : 1))
                    : null,
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildButton(
                icon: Icons.add,
                onPressed: value < maxValue
                    ? () => onChanged(value + (label == 'Bet size' ? 10 : 1))
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onPressed == null
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.2),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  final VoidCallback onPressed;

  const PlayButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool isTemporarilyDisabled = false;

  void _handlePress() async {
    widget.onPressed();

    setState(() {
      isTemporarilyDisabled = true;
    });

    await Future.delayed(const Duration(milliseconds: 4200));

    if (mounted) {
      setState(() {
        isTemporarilyDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isTemporarilyDisabled ? null : _handlePress,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isTemporarilyDisabled
              ? const Color(0xFFFFD700).withValues(alpha: 0.5)
              : const Color(0xFFFFD700),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.2),
              offset: const Offset(0, -1),
              blurRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            isTemporarilyDisabled ? 'Playing...' : 'Play',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
