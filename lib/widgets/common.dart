import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peach_cars/utilites/theme.dart';

// ── Peach text field ──────────────────────────────────────────────────────
class PeachTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final int? maxLines;
  final Color? fillColor;
  final bool enabled;

  const PeachTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.readOnly = false,
    this.maxLines = 1,
    this.fillColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: PeachColors.grey, size: 20)
            : null,
        suffixIcon: suffix,
        fillColor: fillColor ??
            (isDark ? PeachColors.darkCard : PeachColors.lightGrey),
        filled: true,
      ),
    );
  }
}

// ── Peach dropdown ────────────────────────────────────────────────────────
class PeachDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final IconData? prefixIcon;

  const PeachDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<T>(
      value: value,
      validator: validator,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: PeachColors.grey, size: 20)
            : null,
        fillColor: isDark ? PeachColors.darkCard : PeachColors.lightGrey,
        filled: true,
      ),
      dropdownColor: isDark ? PeachColors.darkCard : Colors.white,
      isExpanded: true,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            ),
          )
          .toList(),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

// ── Step progress indicator (for sell car / viewing forms) ────────────────
class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final List<String> labels;
  final List<String> subLabels;

  const StepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.labels,
    required this.subLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isActive = i <= currentStep;
        final isCurrent = i == currentStep;
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isActive
                          ? PeachColors.primary
                          : Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: isActive && !isCurrent
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                color: isActive ? Colors.white : PeachColors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? PeachColors.primary : PeachColors.grey,
                    ),
                  ),
                  Text(
                    subLabels[i],
                    style: const TextStyle(
                        fontSize: 10, color: PeachColors.grey),
                  ),
                ],
              ),
              if (i < totalSteps - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 28),
                    color: i < currentStep
                        ? PeachColors.primary
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Peach primary button (full width) ─────────────────────────────────────
class PeachButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final IconData? icon;
  final Color? color;

  const PeachButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
                strokeWidth: 2.5, color: Colors.white),
          )
        : icon != null
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(label),
              ])
            : Text(label);

    if (outlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? PeachColors.primary,
          side: BorderSide(color: color ?? PeachColors.primary, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
        ),
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? PeachColors.primary,
        minimumSize: const Size(double.infinity, 52),
      ),
      child: child,
    );
  }
}

// ── Empty state widget ────────────────────────────────────────────────────
class PeachEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButton;

  const PeachEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: PeachColors.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonLabel != null) ...[
              const SizedBox(height: 24),
              PeachButton(label: buttonLabel!, onPressed: onButton),
            ],
          ],
        ),
      ),
    );
  }
}
