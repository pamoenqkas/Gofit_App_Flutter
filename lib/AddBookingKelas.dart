
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

// import './widgets/heading.dart';
// import './widgets/drawer.dart';
// import './widgets/apptitle.dart';

class AddBookingKelas extends StatefulWidget {
  @override
  _postSSProvidersState createState() => _postSSProvidersState();
}

class _postSSProvidersState extends State<AddBookingKelas> {
  List<JadwalHarian> jadwalHarianList = [];
  String selectedJadwalHarianId = '';

  //Loader 
  late bool loading = false;

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
  fetchJadwalHarian().then((jadwalHarians) {
    setState(() {
      jadwalHarianList = jadwalHarians;
      selectedJadwalHarianId = jadwalHarianList.isNotEmpty ? jadwalHarianList[0].idJadwalHarian : '';
    });
  }).catchError((error) {
    // Tangani error jika terjadi
    print('Error: $error');
  });
}
 //Text Field Cotrollers To Enter Data
  TextEditingController idMemberController=new TextEditingController();
  TextEditingController idJadwalHarianController=new TextEditingController();
  TextEditingController idKelasController=new TextEditingController();
  // TextEditingController emailController=new TextEditingController();
  // TextEditingController phoneController=new TextEditingController();

//PostData Method to Send Data To API
    Future<void> postData() async {
      setState(() {
        loading = true;
      });

      // Assigning Variables to their Values
      String idMember = idMemberController.text;
      String idJadwalHarian = selectedJadwalHarianId;
      String idKelas = idKelasController.text;

      // Data To be Post
      var sendData = {
        'id_member': idMember,
        'id_jadwal_harian': idJadwalHarian,
        'id_kelas': idKelas,
      };

      String url = 'https://pam.ppcdeveloper.com/api/booking_kelas';

      // Post Data Request
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(sendData),
        headers: {'Content-Type': 'application/json'},
      );

      var message = jsonDecode(response.body);

      // Display The Response Message
      if (response.statusCode == 200) {
        showAlertDialog(context, message);
        setState(() {
          loading = false;
        });
      }
    }


//Alert Dialog Function
showAlertDialog(BuildContext context,var message)
{
  Widget okButton=ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Ok'));
  AlertDialog res=AlertDialog(title: Text('Response'),
  content: Text(message['message']),
  actions: [okButton],);
  showDialog(context: context, builder: (BuildContext context){
    return res;
  }
  );
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
      title: Text('Tambah Booking Kelas'),
      ),
      //If Loading is false Show The Widgets
      body:loading==false?
      Column(
        children:[
          Container(
          width:800,
          height:400,
          padding:new EdgeInsets.fromLTRB(10,20,10,0),

          //Card Widget
          child:Card(
            shape:RoundedRectangleBorder(
              borderRadius:BorderRadius.circular(15.0),
            ),
            elevation:20,
             color:Color.fromARGB(255, 81, 94, 209),
            shadowColor: Colors.blue,
            child:Padding(
              padding: EdgeInsets.fromLTRB(0,30,0,0),
            child:ListView(
            children:[Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                //First Name TEXTFIELD
                 Padding(
                   padding: EdgeInsets.fromLTRB(20,0,20,10), 
                   child:TextField(decoration: InputDecoration(
                    hintText: "Masukkan ID Member",
                    labelText: "ID Member",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.people,size: 30.0,),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.blue,width: 2)),
                      focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.blue,width: 2),)
                  ), 
                  controller: idMemberController,
                  )),

                 //Last Name TextField
                 
               Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "ID Jadwal Harian",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(color: Colors.blue, width: 2)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    value: selectedJadwalHarianId,
                    onChanged: (newValue) {
                      setState(() {
                        selectedJadwalHarianId = newValue.toString();
                      });
                    },
                items: jadwalHarianList
                .map((jadwalHarian) {
                  return DropdownMenuItem(
                    child: Text(jadwalHarian.idJadwalHarian),
                    value: jadwalHarian.idJadwalHarian,
                  );
                })
                .toList()
                  ..sort((a, b) => a.child.toString().compareTo(b.child.toString())),
                    
                    // Tambahkan kode berikut untuk menampilkan hanya id_jadwal_harian
                    // dalam dropdown.
                    selectedItemBuilder: (BuildContext context) {
                      return jadwalHarianList.map<Widget>((jadwalHarian) {
                        return Text(jadwalHarian.idJadwalHarian);
                      }).toList();
                    },
                  ),
                ),
                  //Gender Text Field
                  Padding(
                   padding: EdgeInsets.fromLTRB(20,0,20,20), 
                   child:TextField(decoration: InputDecoration(
                    hintText: "Masukkan ID Kelas",
                    labelText: "ID Kelas",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.assignment,size: 30.0,),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.blue,width: 2)),
                      focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.blue,width: 2),)
                  ),
                  controller: idKelasController,
                  )),

                  // //Email Text Field
                  //  Padding(
                  //  padding: EdgeInsets.fromLTRB(20,0,20,10), 
                  //  child:TextField(decoration: InputDecoration(
                  //   hintText: "Enter Your email",
                  //   labelText: "Email",
                  //   hintStyle: TextStyle(color: Colors.grey),
                  //   prefixIcon: Icon(Icons.email,size: 30.0,),
                  //   filled: true,
                  //   fillColor: Colors.white,
                  //   enabledBorder: OutlineInputBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  //     borderSide: BorderSide(color: Colors.blue,width: 2)),
                  //     focusedBorder:OutlineInputBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  //     borderSide: BorderSide(color: Colors.blue,width: 2),)
                  // ),
                  // controller: emailController,
                  // )),

                  //Phone No Text Field
                  //  Padding(
                  //  padding: EdgeInsets.fromLTRB(20,0,20,10), 
                  //  child:TextField(decoration: InputDecoration(
                  //   hintText: "Enter Your Phone Number",
                  //   labelText: "Phone Number",
                  //   hintStyle: TextStyle(color: Colors.grey),
                  //   prefixIcon: Icon(Icons.phone,size: 30.0,),
                  //   filled: true,
                  //   fillColor: Colors.white,
                  //   enabledBorder: OutlineInputBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  //     borderSide: BorderSide(color: Colors.blue,width: 2)),
                  //     focusedBorder:OutlineInputBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  //     borderSide: BorderSide(color: Colors.blue,width: 2),)
                  // ),
                  // controller: phoneController,
                  // )),

                  //Elevated Button Widget
                Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
                child: ElevatedButton(
                  onPressed: () async {
                    await postData();
                  },
                  child: Text(
                    'Submit Booking',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                ),
              )
               ])
              ]
            ))
          )
        )])
        //If Loading is True Show Progress Indicator
        : Center(child:CircularProgressIndicator())
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