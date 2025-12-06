import 'package:flutter/material.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/helpers/api_client.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/model/buku.dart';

class FormBukuPage extends StatefulWidget {
  final Buku? buku;
  const FormBukuPage({super.key, this.buku});

  @override
  State<FormBukuPage> createState() => _FormBukuPageState();
}

class _FormBukuPageState extends State<FormBukuPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();
  final _jumlahCtrl = TextEditingController();
  final _penulisCtrl = TextEditingController();
  final _penerbitCtrl = TextEditingController();
  final _volumeCtrl = TextEditingController();
  final _tanggalCtrl = TextEditingController();
  final ApiClient _api = ApiClient();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.buku != null) {
      _judulCtrl.text = widget.buku!.judul;
      _hargaCtrl.text = widget.buku!.harga.toString();
      _jumlahCtrl.text = widget.buku!.jumlah.toString();
      _penulisCtrl.text = widget.buku!.penulis;
      _penerbitCtrl.text = widget.buku!.penerbit;
      _volumeCtrl.text = widget.buku!.volume.toString();
      _tanggalCtrl.text = widget.buku!.tanggalMasuk;
    }
  }

  void _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    Map<String, dynamic> data = {
      'judul': _judulCtrl.text,
      'harga': _hargaCtrl.text,
      'jumlah': _jumlahCtrl.text,
      'penulis': _penulisCtrl.text,
      'penerbit': _penerbitCtrl.text,
      'volume': _volumeCtrl.text,
      'tanggal_masuk': _tanggalCtrl.text,
    };

    try {
      if (widget.buku == null) {
        await _api.post('buku', data);
      } else {
        await _api.put('buku/${widget.buku!.id}', data); // Perhatikan method ini di ApiClient kamu nanti mungkin perlu update
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal Menyimpan Data")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.buku == null ? "Tambah Inventaris Firyalmart" : "Ubah Data Buku")), // Sesuai Instruksi
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField("Judul Buku", _judulCtrl),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _buildField("Harga", _hargaCtrl, isNumber: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildField("Jumlah", _jumlahCtrl, isNumber: true)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _buildField("Volume", _volumeCtrl, isNumber: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildField("Tanggal Masuk (YYYY-MM-DD)", _tanggalCtrl)),
              ]),
              const SizedBox(height: 10),
              _buildField("Penulis", _penulisCtrl),
              const SizedBox(height: 10),
              _buildField("Penerbit", _penerbitCtrl),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _simpan,
                  child: Text(widget.buku == null ? "SIMPAN" : "UBAH"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {bool isNumber = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      validator: (val) => val!.isEmpty ? "Harus diisi" : null,
    );
  }
}