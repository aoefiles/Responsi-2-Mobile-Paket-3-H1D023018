class Buku {
  final int? id;
  final String judul;
  final int harga;
  final int jumlah;
  final String tanggalMasuk;
  final int volume;
  final String penulis;
  final String penerbit;

  Buku({
    this.id,
    required this.judul,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
    required this.volume,
    required this.penulis,
    required this.penerbit,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: int.parse(json['id'].toString()),
      judul: json['judul'],
      harga: int.parse(json['harga'].toString()),
      jumlah: int.parse(json['jumlah'].toString()),
      tanggalMasuk: json['tanggal_masuk'],
      volume: int.parse(json['volume'].toString()),
      penulis: json['penulis'],
      penerbit: json['penerbit'],
    );
  }
}