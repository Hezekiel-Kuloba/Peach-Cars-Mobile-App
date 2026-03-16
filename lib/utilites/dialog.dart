import 'package:flutter/material.dart';
import 'package:peach_cars/utilites/theme.dart';

class PeachDialogs {
  // ── Success dialog ────────────────────────────────────────────────────
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: PeachColors.success.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: PeachColors.success, size: 36),
            ),
            const SizedBox(height: 16),
            if (title.isNotEmpty)
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
            if (title.isNotEmpty) const SizedBox(height: 8),
            Text(message,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  onPressed?.call();
                },
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error dialog ──────────────────────────────────────────────────────
  static void showError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: PeachColors.error.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_rounded,
                  color: PeachColors.error, size: 36),
            ),
            const SizedBox(height: 16),
            if (title.isNotEmpty)
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
            if (title.isNotEmpty) const SizedBox(height: 8),
            Text(message,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: PeachColors.error),
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressed?.call();
                },
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Confirm dialog ────────────────────────────────────────────────────
  static Future<bool> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.warning_rounded,
              color: destructive ? PeachColors.error : PeachColors.warning,
              size: 24),
          const SizedBox(width: 8),
          Text(title),
        ]),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: destructive
                ? ElevatedButton.styleFrom(
                    backgroundColor: PeachColors.error,
                    minimumSize: const Size(0, 44),
                  )
                : ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ── Info snackbar ─────────────────────────────────────────────────────
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? PeachColors.error : PeachColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        action: action,
      ),
    );
  }
}
