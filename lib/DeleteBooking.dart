import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteBookingPage extends StatelessWidget {
  final String bookingId;

  DeleteBookingPage({required this.bookingId});

  Future<void> deleteBooking() async {
    final url = Uri.parse('https://pam.ppcdeveloper.com/api/booking_kelas/$bookingId/');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Booking deleted');
    } else {
      print('Failed to delete booking');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Booking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus booking ini?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                deleteBooking().then((_) {
                  Navigator.pop(context);
                }).catchError((error) {
                  print('Error deleting booking: $error');
                });
              },
              child: Text('Hapus'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
