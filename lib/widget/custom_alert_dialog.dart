import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String message;
  final String type; // 'success' atau 'error'
  final VoidCallback? onOkPressed;

  const CustomAlertDialog({
    super.key,
    required this.message,
    required this.type,
    this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan warna dan ikon berdasarkan tipe
    final bool isSuccess = type == 'success';
    final Color mainColor = isSuccess ? const Color(0xFF6D4C41) : Colors.red.shade400; // Coklat vs Merah
    final IconData icon = isSuccess ? Icons.check_circle_outline : Icons.error_outline;
    final String title = isSuccess ? "Berhasil" : "Gagal";

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: mainColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  if (onOkPressed != null) onOkPressed!(); // Jalankan aksi tambahan jika ada
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Fungsi helper untuk memanggil dialog dengan mudah dari mana saja
void showCustomDialog(BuildContext context, {required String message, required String type, VoidCallback? onOk}) {
  showDialog(
    context: context,
    barrierDismissible: false, // User harus klik OK
    builder: (context) => CustomAlertDialog(message: message, type: type, onOkPressed: onOk),
  );
}