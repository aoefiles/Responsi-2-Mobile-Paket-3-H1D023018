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

**[Demo Aplikasi: DemoAplikasi.gif]**

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
