import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileMember extends StatefulWidget {
  final String idMember; // Tambahkan properti idMember

  ProfileMember({required this.idMember});

  @override
  _ProfileMemberState createState() => _ProfileMemberState();
}

class _ProfileMemberState extends State<ProfileMember> {
  Member? member; // Tambahkan variabel member untuk menyimpan data member

  Future<Member> fetchMember() async {
    final url = Uri.parse('https://pam.ppcdeveloper.com/api/member?id_member=${widget.idMember}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataMember = responseData['data'] as List<dynamic>;

      Member member = Member.fromJson(dataMember.first);
      return member;
    } else {
      throw Exception('Failed to load member');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMember().then((value) {
      setState(() {
        member = value;
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: member != null
          ? Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/4094114901.jpg'),
                ),
                Text(
                  '${member!.nama_member ?? ""}',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(
                    '${member!.email_member ?? ""}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('${member!.no_telp_member ?? ""}'),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('${member!.tanggal_lahir ?? ""}'),
                ),
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text('${member!.masa_membership ?? ""}'),
                ),
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text('Rp. ${member!.deposit ?? ""},00'),
                ),
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text(': ${member!.deposit_kelas ?? ""} Sesi '),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class Member {
  final String? id_member;
  final String? nama_member;
  final String? email_member;
  final String? no_telp_member;
  final String? masa_membership;
  final String? deposit;
  final String? tanggal_lahir;
  final String? deposit_kelas;
  final String? image;

  Member({
    required this.id_member,
    required this.nama_member,
    required this.email_member,
    required this.no_telp_member,
    required this.masa_membership,
    required this.deposit,
    required this.deposit_kelas,
    required this.tanggal_lahir,
    required this.image,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id_member: json['id_member'],
      nama_member: json['nama_member'],
      email_member: json['email_member'],
      no_telp_member: json['no_telp_member'],
      masa_membership: json['masa_membership'],
      deposit: json['deposit'],
      deposit_kelas: json['deposit_kelas'],
      tanggal_lahir: json['tanggal_lahir'],
      image: json['image'],
    );
  }
}
