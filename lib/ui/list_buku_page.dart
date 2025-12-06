import 'package:flutter/material.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/helpers/api_client.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/model/buku.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/ui/form_buku_page.dart';
import 'package:responsi_2_mobile_paket_3_h1d023018/ui/login_page.dart';

class ListBukuPage extends StatefulWidget {
  const ListBukuPage({super.key});

  @override
  State<ListBukuPage> createState() => _ListBukuPageState();
}

class _ListBukuPageState extends State<ListBukuPage> {
  final ApiClient _api = ApiClient();
  List<Buku> _listBuku = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBuku();
  }

  void _fetchBuku() async {
    try {
      final response = await _api.get('buku');
      if (response['status'] == true) {
        List data = response['data'];
        setState(() {
          _listBuku = data.map((e) => Buku.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _deleteBuku(int id) async {
    await _api.delete('buku/$id');
    _fetchBuku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventaris Buku Firyalmart"), // Sesuai Instruksi
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6D4C41),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const FormBukuPage()));
          _fetchBuku();
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _listBuku.length,
              itemBuilder: (context, index) {
                final buku = _listBuku[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white, // Agar kontras dengan background krem
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                buku.judul,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD7CCC8), // Coklat Muda banget
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Vol ${buku.volume}",
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text("Penulis: ${buku.penulis} | Penerbit: ${buku.penerbit}", style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rp ${buku.harga} (Stok: ${buku.jumlah})",
                              style: const TextStyle(fontSize: 16, color: Color(0xFFA1887F), fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    await Navigator.push(context, MaterialPageRoute(builder: (context) => FormBukuPage(buku: buku)));
                                    _fetchBuku();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteBuku(buku.id!),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}