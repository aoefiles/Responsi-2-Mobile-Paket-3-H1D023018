import 'package:flutter/material.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/helpers/api_client.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/ui/list_buku_page.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/ui/registrasi_page.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/widget/custom_alert_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiClient _api = ApiClient();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      final response = await _api.post('login', {
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      if (response['status'] == true) {
        if (!mounted) return;
        
        // MODIFIKASI: Menggunakan showCustomDialog untuk Sukses
        showCustomDialog(
          context,
          message: "Login Berhasil! Selamat datang di Firyalmart.",
          type: 'success',
          onOk: () {
            // Pindah halaman hanya setelah user klik OK
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ListBukuPage()));
          },
        );
      } else {
        _showError(response['messages']['error'] ?? 'Login Gagal');
      }
    } catch (e) {
      _showError('Terjadi kesalahan koneksi');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    // MODIFIKASI: Mengganti SnackBar dengan Dialog Error Custom
    showCustomDialog(context, message: msg, type: 'error');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon Kopi/Buku (Hiasan)
              const Icon(Icons.menu_book_rounded, size: 80, color: Color(0xFF6D4C41)),
              const SizedBox(height: 20),
              const Text(
                "Firyalmart Books",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
              ),
              const SizedBox(height: 10),
              const Text("Silakan masuk untuk mengelola inventaris", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock_outline)),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN"),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrasiPage())),
                child: const Text("Belum punya akun? Registrasi", style: TextStyle(color: Color(0xFF6D4C41))),
              )
            ],
          ),
        ),
      ),
    );
  }
}