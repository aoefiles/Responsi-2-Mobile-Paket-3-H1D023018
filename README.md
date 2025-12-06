# Aplikasi Inventaris Buku

Proyek ini dibuat untuk memenuhi tugas Responsi 2 Mata Kuliah Pemrograman Mobile.

## Informasi Mahasiswa

| Keterangan | Detail |
| :--- | :--- |
| **Nama** | Firyal Aufa Fahrudin |
| **NIM** | H1D023018 |
| **Shift Baru** | F |
| **Shift Asal** | B |

---

## Video Demo Aplikasi

Video demo aplikasi dapat dilihat pada file yang tersimpan di direktori proyek:

![Demo Aplikasi](DemoAplikasi.mp4)


---
## Spesifikasi API yang Digunakan

Aplikasi ini berinteraksi dengan REST API yang dibangun menggunakan CodeIgniter 4. Berikut adalah detail endpoint yang digunakan:

**Base URL:** `http://localhost:8080`

### A. Otentikasi (AuthController)

#### 1. Registrasi Akun
* **Endpoint:** `/registrasi`
* **Metode:** `POST`
* **Deskripsi:** Mendaftarkan pengguna baru ke dalam sistem.
* **Parameter Body (x-www-form-urlencoded):**
    * `nama` (string): Nama lengkap pengguna.
    * `email` (string): Alamat email pengguna.
    * `password` (string): Kata sandi pengguna.
* **Respons Sukses (201 Created):**
    ```json
    {
      "status": true,
      "message": "Registrasi Berhasil"
    }
    ```

#### 2. Login
* **Endpoint:** `/login`
* **Metode:** `POST`
* **Deskripsi:** Melakukan otentikasi pengguna untuk mendapatkan akses.
* **Parameter Body (x-www-form-urlencoded):**
    * `email` (string): Email terdaftar.
    * `password` (string): Kata sandi.
* **Respons Sukses (200 OK):**
    ```json
    {
      "status": true,
      "data": {
        "token": "a1b2c3d4...", 
        "user": {
          "id": "1",
          "email": "user@example.com",
          "password": "$2y$10$..."
        }
      }
    }
    ```
* **Respons Gagal (404/400):**
    ```json
    {
      "status": 404,
      "error": 404,
      "messages": {
        "error": "Email tidak ditemukan" // atau "Password salah"
      }
    }
    ```

### B. Manajemen Buku (BukuController)

#### 1. Lihat Semua Buku
* **Endpoint:** `/buku`
* **Metode:** `GET`
* **Deskripsi:** Mengambil seluruh data buku yang tersedia.
* **Respons Sukses (200 OK):**
    ```json
    {
      "status": true,
      "data": [
        {
          "id": "1",
          "judul": "Pemrograman Mobile",
          "harga": "150000",
          "jumlah": "10",
          "tanggal_masuk": "2023-12-01",
          "volume": "1",
          "penulis": "Budi",
          "penerbit": "Informatika"
        }
      ]
    }
    ```

#### 2. Lihat Detail Buku
* **Endpoint:** `/buku/{id}`
* **Metode:** `GET`
* **Deskripsi:** Mengambil data spesifik satu buku berdasarkan ID.
* **Respons Sukses (200 OK):**
    ```json
    {
      "status": true,
      "data": {
        "id": "1",
        "judul": "Pemrograman Mobile",
        ...
      }
    }
    ```

#### 3. Tambah Buku
* **Endpoint:** `/buku`
* **Metode:** `POST`
* **Deskripsi:** Menambahkan data buku baru ke database.
* **Parameter Body (x-www-form-urlencoded):**
    * `judul` (string)
    * `harga` (string/int)
    * `jumlah` (string/int)
    * `tanggal_masuk` (string)
    * `volume` (string/int)
    * `penulis` (string)
    * `penerbit` (string)
* **Respons Sukses (201 Created):**
    ```json
    {
      "status": true,
      "message": "Buku berhasil ditambahkan"
    }
    ```

#### 4. Ubah Data Buku
* **Endpoint:** `/buku/{id}`
* **Metode:** `PUT`
* **Deskripsi:** Memperbarui data buku yang sudah ada.
* **Parameter Body (Raw JSON / x-www-form-urlencoded):** Sama dengan endpoint Tambah Buku.
* **Respons Sukses (200 OK):**
    ```json
    {
      "status": true,
      "message": "Data berhasil diupdate"
    }
    ```

#### 5. Hapus Buku
* **Endpoint:** `/buku/{id}`
* **Metode:** `DELETE`
* **Deskripsi:** Menghapus data buku berdasarkan ID.
* **Respons Sukses (200 OK):**
    ```json
    {
      "status": true,
      "message": "Data berhasil dihapus"
    }
    ```

## Penjelasan Kode

Bagian ini menangani proses pendaftaran dan masuknya pengguna menggunakan `ApiClient` untuk berkomunikasi dengan backend.

### 1. Registrasi (`lib/ui/registrasi_page.dart`)

Fungsi `_registrasi()` mengambil input pengguna dan mengirimkannya ke endpoint `/registrasi`. Fungsi ini menggunakan blok `try-catch` untuk menangani permintaan HTTP: jika sukses, dialog konfirmasi muncul; jika gagal, pesan kesalahan ditampilkan.

```dart
void _registrasi() async {
  setState(() => _isLoading = true);
  try {
    await _api.post('registrasi', {
      'nama': _namaController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    });
    
    if (!mounted) return;
    showCustomDialog(context, message: "Registrasi Berhasil!", type: 'success', 
      onOk: () => Navigator.pop(context)); // Kembali ke Login
  } catch (e) {
    showCustomDialog(context, message: "Registrasi Gagal: $e", type: 'error');
  } finally {
    setState(() => _isLoading = false);
  }
}
```

### 2. Login (lib/ui/login_page.dart)
Fungsi _login() memverifikasi email dan password melalui endpoint /login. Jika API mengembalikan status: true, pengguna diarahkan ke halaman utama (ListBukuPage). Jika false, pesan error dari server ditampilkan.

```dart
void _login() async {
  setState(() => _isLoading = true);
  try {
    final response = await _api.post('login', {
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    if (response['status'] == true) {
      if (!mounted) return;
      showCustomDialog(context, message: "Login Berhasil!", type: 'success',
        onOk: () => Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context) => const ListBukuPage())));
    } else {
      _showError(response['messages']['error'] ?? 'Login Gagal');
    }
  } catch (e) {
    _showError('Terjadi kesalahan koneksi');
  } finally {
    setState(() => _isLoading = false);
  }
}
```

### 3. Menampilkan Daftar Buku (`lib/ui/list_buku_page.dart`)

Fungsi `_fetchBuku()` dijalankan secara otomatis saat halaman dimuat (`initState`). Fungsi ini mengambil seluruh data buku dari endpoint `/buku`. Hasil respon JSON diparsing menjadi list objek `Buku` dan disimpan ke dalam state untuk ditampilkan pada `ListView`.

```dart
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
```

### 4. Tambah Buku (`lib/ui/form_buku_page.dart`)

Fitur ini menggunakan halaman form yang sama dengan fitur ubah data. Fungsi `_simpan()` bertugas mengumpulkan input dari pengguna dan mengirimkannya ke server.

**Logika Alur:**
1.  Melakukan validasi form (memastikan semua input terisi).
2.  Mengumpulkan data dari controller ke dalam sebuah `Map`.
3.  Mengecek apakah `widget.buku` bernilai `null` (kosong).
4.  Jika `null`, aplikasi mengirim request `POST` ke endpoint `/buku` untuk menyimpan data baru.

```dart
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
    // Logika Tambah Buku (POST)
    if (widget.buku == null) {
      await _api.post('buku', data);
    } 
    // ... logika update (else) ...
    
    if (!mounted) return;
    Navigator.pop(context); // Kembali ke list buku
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal Menyimpan Data"))
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
```

### 5. Ubah Data Buku (`lib/ui/form_buku_page.dart`)

Fitur ubah data berbagi halaman UI yang sama dengan tambah data. Jika halaman dibuka dengan membawa data buku (`widget.buku != null`), formulir akan terisi otomatis. Fungsi `_simpan()` akan mendeteksi keberadaan data tersebut untuk menentukan metode pengiriman yang digunakan.

**Logika Alur:**
1.  Saat tombol SIMPAN ditekan, aplikasi mengecek `widget.buku`.
2.  Jika `widget.buku` memiliki nilai, aplikasi menganggap ini sebagai operasi **Update**.
3.  Aplikasi mengirim request `PUT` ke endpoint `/buku/{id}` dengan data yang telah diedit.

```dart
// Potongan logika di dalam fungsi _simpan()
try {
  if (widget.buku == null) {
    await _api.post('buku', data); // Tambah Baru
  } else {
    // Logika Ubah Data (PUT)
    await _api.put('buku/${widget.buku!.id}', data);
  }
  
  if (!mounted) return;
  Navigator.pop(context);
} catch (e) {
  // Error handling...
}
```


### 6. Hapus Buku (`lib/ui/list_buku_page.dart`)

Fungsi `_deleteBuku()` dipicu ketika pengguna menekan ikon hapus pada salah satu item di daftar buku. Fungsi ini menerima parameter `id` buku dan mengirimkan permintaan penghapusan ke server.

**Logika Alur:**
1.  Menerima `id` buku yang dipilih.
2.  Mengirim request `DELETE` ke endpoint `/buku/{id}`.
3.  Setelah proses penghapusan selesai, fungsi `_fetchBuku()` dipanggil kembali untuk menyegarkan tampilan daftar buku agar data yang dihapus menghilang dari layar.

```dart
void _deleteBuku(int id) async {
  await _api.delete('buku/$id');
  _fetchBuku(); // Refresh data setelah hapus
}
```
