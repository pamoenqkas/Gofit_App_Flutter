import 'package:flutter/material.dart';
import 'package:gofit_app/AddBookingKelas.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Booking> bookings = [];
  bool isLoading = true;
  String error = '';

  Future<List<Booking>> fetchBookings() async {
    final url = Uri.parse('https://pam.ppcdeveloper.com/api/booking_kelas/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataBooking = responseData['data'] as List<dynamic>;

      List<Booking> bookings = dataBooking.map<Booking>((bookingData) => Booking.fromJson(bookingData)).toList();
      return bookings;
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    final url = Uri.parse('https://pam.ppcdeveloper.com/api/booking_kelas/$bookingId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Booking berhasil dihapus
      // Tambahkan logika atau tindakan apa pun setelah penghapusan booking berhasil
      print('Booking deleted');
    } else {
      // Gagal menghapus booking
      // Tambahkan logika atau tindakan apa pun untuk menangani kesalahan penghapusan booking
      print('Failed to delete booking');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookings().then((value) {
      setState(() {
        bookings = value;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
        error = 'Error: $error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Kelas'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? Center(child: Text('Tidak ada data bookings'))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      child: ListTile(
                        title: Text('ID Booking Kelas: ${booking.id_booking_kelas}'),
                        subtitle: Text('Tanggal Booking Kelas: ${booking.tanggal_booking_kelas}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Konfirmasi Hapus'),
                                      content: Text('Apakah Anda yakin ingin menghapus booking ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteBooking(booking.id_booking_kelas).then((_) {
                                              // Booking berhasil dihapus
                                              // Tambahkan logika atau tindakan apa pun setelah penghapusan booking berhasil
                                              setState(() {
                                                // Hapus booking dari daftar bookings
                                                bookings.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                            }).catchError((error) {
                                              // Gagal menghapus booking
                                              // Tambahkan logika atau tindakan apa pun untuk menangani kesalahan penghapusan booking
                                              print('Failed to delete booking: $error');
                                            });
                                          },
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Detail Booking'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('ID Booking Kelas: ${booking.id_booking_kelas}'),
                                      Text('ID Member: ${booking.id_member}'),
                                      Text('ID Jadwal Harian: ${booking.id_jadwal_harian}'),
                                      Text('ID Kelas: ${booking.id_kelas}'),
                                      Text('Tanggal Booking Kelas: ${booking.tanggal_booking_kelas}'),
                                      Text('Metode Pembayaran: ${booking.metode_pembayaran}'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBookingKelas()));
        },
        tooltip: 'Tambah Booking Kelas',
        backgroundColor: Colors.amber,
        child: const Icon(Icons.post_add_outlined),
      ),
    );
  }
}

class Booking {
  final String id_booking_kelas;
  final String id_member;
  final String id_jadwal_harian;
  final String id_kelas;
  final String tanggal_booking_kelas;
  final String metode_pembayaran;

  Booking({
    required this.id_booking_kelas,
    required this.id_member,
    required this.id_jadwal_harian,
    required this.id_kelas,
    required this.tanggal_booking_kelas,
    required this.metode_pembayaran,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id_booking_kelas: json['id_booking_kelas'],
      id_member: json['id_member'],
      id_jadwal_harian: json['id_jadwal_harian'],
      id_kelas: json['id_kelas'],
      tanggal_booking_kelas: json['tanggal_booking_kelas'],
      metode_pembayaran: json['metode_pembayaran'],
    );
  }
}
