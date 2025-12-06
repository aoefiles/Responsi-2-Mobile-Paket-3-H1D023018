import 'package:flutter/material.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/helpers/api_client.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/widget/custom_alert_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiClient _api = ApiClient();
  bool _isLoading = false;

  void _registrasi() async {
    setState(() => _isLoading = true);
    try {
      await _api.post('registrasi', {
        'nama': _namaController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });
      if (!mounted) return;
      
      // MODIFIKASI: Menggunakan Dialog Custom Coklat untuk Sukses
      showCustomDialog(
        context,
        message: "Registrasi Berhasil! Silakan Login.",
        type: 'success',
        onOk: () {
          Navigator.pop(context); // Kembali ke halaman Login setelah user klik OK
        },
      );
        } catch (e) {
      print("ERROR REGISTRASI: $e"); // Tambahkan baris ini
      showCustomDialog(
        context,
        message: "Registrasi Gagal: $e", // Tampilkan error di layar biar jelas
        type: 'error',
      );
    }finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _namaController, 
              decoration: const InputDecoration(labelText: "Nama Lengkap")
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController, 
              decoration: const InputDecoration(labelText: "Email")
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController, 
              obscureText: true, 
              decoration: const InputDecoration(labelText: "Password")
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registrasi, 
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("DAFTAR")
              ),
            ),
          ],
        ),
      ),
    );
  }
}