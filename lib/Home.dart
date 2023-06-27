import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeMember extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeMember> {
    // TextEditingController id_member_controller = TextEditingController();
    // TextEditingController id_kelas_controller = TextEditingController();
    // TextEditingController id_jadwal_harian_controller = TextEditingController();

    List<JadwalHarian> jadwal_harians= [];

   //Berhasil
    // Future<List<JadwalHarian>> fetchJadwalHarian() async {
    //   final url = Uri.parse('http://192.168.0.146:8000/api/jadwal_harian');
    //   final response = await http.get(url);

    //   if (response.statusCode == 200) {
    //     var responseData = json.decode(response.body) as Map<String, dynamic>;
    //     var dataJadwalHarian = responseData['data'] as List<dynamic>;

    //     List<JadwalHarian> jadwal_harians = dataJadwalHarian.map<JadwalHarian>((jadwalHarianData) => JadwalHarian.fromJson(jadwalHarianData)).toList();
    //     return jadwal_harians;
    //   } else {
    //     throw Exception('Failed to load Jadwal Harians');
    //   }
    // }

    //coba-coba
   Future<List<JadwalHarian>> fetchJadwalHarian() async {
    final url = Uri.parse('https://pam.ppcdeveloper.com/api/jadwal_harian');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataJadwalHarian = responseData['data'] as List<dynamic>;

      List<String> idKelasList = dataJadwalHarian.map<String>((jadwalHarianData) => jadwalHarianData['id_kelas']).toList();
      List<String> namaKelasList = await Future.wait(idKelasList.map((idKelas) => fetchNamaKelas(idKelas)));

      List<String> idInstrukturList = dataJadwalHarian.map<String>((jadwalHarianData) => jadwalHarianData['id_instruktur']).toList();
      List<String> namaInstrukturList = await Future.wait(idInstrukturList.map((idKelas) => fetchNamaInstruktur(idKelas)));

      List<JadwalHarian> jadwal_harians = dataJadwalHarian.asMap().entries.map<JadwalHarian>((entry) {
        var jadwalHarianData = entry.value;
        var namaKelas = namaKelasList[entry.key];
        var namaInstruktur = namaInstrukturList[entry.key];
        return JadwalHarian.fromJson(jadwalHarianData, namaKelas: namaKelas, namaInstruktur: namaInstruktur);
      }).toList();

      return jadwal_harians;
    } else {
      throw Exception('Failed to load Jadwal Harians');
    }
  }

    //Untuk kelas
    Future<String> fetchNamaKelas(String id_kelas) async {
      final url = Uri.parse('https://pam.ppcdeveloper.com/api/kelas/$id_kelas');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        var namaKelas = responseData['nama_kelas'] as String;

        return namaKelas;
      } else {
        throw Exception('Failed to load Nama Kelas');
      }
    }

     Future<String> fetchNamaInstruktur(String id_instruktur) async {
      final url = Uri.parse('https://pam.ppcdeveloper.com/api/instruktur/$id_instruktur');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        var namaInstruktur = responseData['nama_instruktur'] as String;

        return namaInstruktur;
      } else {
        throw Exception('Failed to load Nama Instruktur');
      }
    }


  @override
  void initState() {
    super.initState();
    fetchJadwalHarian().then((value) {
      setState(() {
        jadwal_harians = value;
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }
  
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Jadwal Harian'),
        ),
        body: ListView.builder(
          itemCount: jadwal_harians.length,
          itemBuilder: (context, index) {
            final jadwal_harian = jadwal_harians[index];
            return Card(
              child: ListTile(
                title: Text('${jadwal_harian.namaKelas} - ${jadwal_harian.namaInstruktur}'),
                leading: Icon(Icons.sports_gymnastics),
                subtitle: Text('${jadwal_harian.tanggal} - ${jadwal_harian.keterangan}'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Aksi saat card ditekan
                  // Misalnya, tampilkan detail Jadwal Harian
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Detail Jadwal Harian'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID Jadwal Harian: ${jadwal_harian.idJadwalHarian}'),
                              Text('ID Kelas: ${jadwal_harian.idKelas}'),
                              Text('ID Instruktur: ${jadwal_harian.idInstruktur}'),
                              Text('Hari: ${jadwal_harian.hari}'),
                              Text('Jam: ${jadwal_harian.jamMulai} - ${jadwal_harian.jamSelesai}'),
                              Text('Tanggal : ${jadwal_harian.tanggal}'),
                              Text('Keterangan: ${jadwal_harian.keterangan}'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Tutup'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      );
    }
}

class JadwalHarian {
  final String idJadwalHarian;
  final String idKelas;
  final String idInstruktur;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String tanggal;
  final String keterangan;
  final String namaKelas;
  final String namaInstruktur;

  JadwalHarian({
    required this.idJadwalHarian,
    required this.idKelas,
    required this.idInstruktur,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.tanggal,
    required this.keterangan,
    required this.namaKelas,
    required this.namaInstruktur,
  });

  factory JadwalHarian.fromJson(Map<String, dynamic> json, {String? namaKelas, String? namaInstruktur}) {
  return JadwalHarian(
    idJadwalHarian: json['id_jadwal_harian'] ?? '', // Tambahkan pengecekan null dan berikan nilai default
    idKelas: json['id_kelas'] ?? '',
    idInstruktur: json['id_instruktur'] ?? '',
    hari: json['hari'] ?? '',
    jamMulai: json['jam_mulai'] ?? '',
    jamSelesai: json['jam_selesai'] ?? '',
    tanggal: json['tanggal'] ?? '',
    keterangan: json['keterangan'] ?? '',
    namaKelas: namaKelas ?? '',
    namaInstruktur: namaInstruktur ?? '',
  );
}
}