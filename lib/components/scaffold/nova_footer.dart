import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';

class NovaFooter extends StatelessWidget {
  final String? statusText;

  const NovaFooter({Key? key, this.statusText = "SYSTEM NOMINAL"})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;
    final now = DateTime.now();
    final formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return Container(
      height: 28,
      color: theme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: theme.accent),
          const SizedBox(width: 6),
          Text(
            statusText ?? "SYSTEM NOMINAL",
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 11,
              fontFamily: theme.getFontFamily(theme.secondaryFontFamily),
            ),
          ),
          const Spacer(),
          Text(
            formattedTime,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 11,
              fontFamily: theme.getFontFamily(theme.secondaryFontFamily),
            ),
          ),
        ],
      ),
    );
  }
}
