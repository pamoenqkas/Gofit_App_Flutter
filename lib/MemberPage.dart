import 'package:flutter/material.dart';
import 'package:gofit_app/BookingKelas.dart';
import 'package:gofit_app/Home.dart';
import 'package:gofit_app/ProfileMember.dart';

class MemberPage extends StatefulWidget {
  final String idMember;

  MemberPage({required this.idMember});

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
    late List<Widget> _children; // Buat sebagai late variable
    int _currentIndex = 0;
    @override
      void didChangeDependencies() {
        super.didChangeDependencies();
        _children = [
          HomeMember(),
          BookingPage(),
          ProfileMember(idMember: widget.idMember),
        ];
      }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(''),
      // ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Booking Kelas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Booking Kelas',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      //tampilan text
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
