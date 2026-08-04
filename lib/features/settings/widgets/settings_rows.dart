import 'package:flutter/material.dart';

/// Shared iOS-style building blocks for the settings screens: grouped cards,
/// label/value rows, switches and nav chevrons.
///
/// Extracted from settings_view.dart, which had grown past 1900 lines holding
/// every settings screen plus these primitives. They're library-private to the
/// settings feature, hence the `settings_` prefix rather than `_`.

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 22, trailing == null ? 20 : 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A row that shows a label, an optional current value, and a chevron; drills
/// into a sub-page on tap. Mirrors iOS Settings rows.
class SettingsNavRow extends StatelessWidget {
  const SettingsNavRow({super.key, required this.label,
    this.onTap,
    this.leading,
    this.destructive = false,
    this.accent = false,});

  final String label;
  final VoidCallback? onTap;
  final IconData? leading;
  final bool destructive;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = destructive
        ? Colors.red
        : accent
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface;
    return ListTile(
      leading: leading == null
          ? null
          : Icon(leading, color: labelColor, size: 22),
      title: Text(label, style: TextStyle(color: labelColor)),
      trailing: destructive
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 6),
                Icon(Icons.chevron_right,
                    size: 20, color: theme.colorScheme.outline),
              ],
            ),
      onTap: onTap,
    );
  }
}

/// A row inside a grouped settings card: icon + label + current value +
/// chevron. (Destructive variant: red, no value/chevron.)
class SettingsRow extends StatelessWidget {
  const SettingsRow({super.key, required this.icon,
    required this.tint,
    required this.label,
    this.value,
    this.onTap,
    this.destructive = false,});

  final IconData icon;
  final Color tint;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: SettingsIconBox(icon: icon, tint: destructive ? Colors.red : tint),
      title: Text(label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: destructive ? Colors.red : theme.colorScheme.onSurface)),
      trailing: destructive
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value != null)
                  Flexible(
                    child: Text(value!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            color: theme.colorScheme.onSurfaceVariant)),
                  ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right,
                    size: 20, color: theme.colorScheme.outline),
              ],
            ),
    );
  }
}

/// A row inside a grouped settings card with a trailing switch.
class SettingsRowSwitch extends StatelessWidget {
  const SettingsRowSwitch({super.key, required this.icon,
    required this.tint,
    required this.label,
    required this.value,
    required this.onChanged,});

  final IconData icon;
  final Color tint;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () => onChanged(!value),
      leading: SettingsIconBox(icon: icon, tint: tint),
      title: Text(label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface)),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

/// Rounded icon chip used on the left of a settings row.
class SettingsIconBox extends StatelessWidget {
  const SettingsIconBox({super.key, required this.icon, required this.tint});
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 19, color: tint),
    );
  }
}

/// Inline label + right-aligned editable value row (for forms).
class SettingsTextFieldRow extends StatelessWidget {
  const SettingsTextFieldRow({super.key, required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,});

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(width: 92, child: Text(label)),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              autocorrect: false,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 1px inset divider between grouped rows.
class SettingsRowDivider extends StatelessWidget {
  const SettingsRowDivider({super.key});
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 16, endIndent: 0);
}

/// A rounded elevated card holding sub-page rows (white on grey, subtle shadow).
class SettingsGrouped extends StatelessWidget {
  const SettingsGrouped({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.0 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: theme.brightness == Brightness.dark
            ? Border.all(color: theme.dividerColor)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

/// Page background for the settings screens (iOS grouped-table grey).
Color settingsBg(BuildContext context) {
  final b = Theme.of(context).brightness;
  return b == Brightness.dark ? const Color(0xFF0D0D0F) : const Color(0xFFF2F2F7);
}
