import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart' as komputer;
import 'agenda.dart' as radio;
import './info.dart' as headset;
import 'galeri.dart' as hp;
import './login_screen.dart'; // Import the login screen
import 'dart:ui';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'admin.dart'; // Import the admin file
import 'package:provider/provider.dart';
import 'providers/data_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        title: "Empat Mobile Apps",
        debugShowCheckedModeBanner: false, // Menghilangkan banner debug
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        initialRoute: '/login',   
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const Home(),
          '/admin': (context) => const AdminPanel(),
          '/agenda': (context) => const radio.AgendaScreen(),
          '/info': (context) => const headset.Info(),
          '/gallery': (context) => const hp.Gallery(),
        },
      ),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController controller;
  int _selectedIndex = 0;

  final iconList = <IconData>[
    Icons.home_rounded,
    Icons.info_rounded,
    Icons.event_rounded,
    Icons.photo_library_rounded,
  ];

  final titleList = ['Home', 'Info', 'Agenda', 'Gallery'];

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    controller = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E),
            Color(0xFF0D47A1),
            Color(0xFF01579B),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          _buildAnimatedBackground(),
          _buildTabBarView(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Colors.blue.withOpacity(0.2), Colors.transparent],
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .moveY(duration: 5.seconds, curve: Curves.easeInOut)
     .moveX(duration: 6.seconds, curve: Curves.easeInOut);
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: controller,
      children: <Widget>[
        _buildAnimatedPage(komputer.Home()),
        _buildAnimatedPage(headset.Info()),
        _buildAnimatedPage(radio.AgendaScreen()),
        _buildAnimatedPage(hp.Gallery()),
      ],
    );
  }

  Widget _buildAnimatedPage(Widget page) {
    return Container(
      margin: EdgeInsets.only(
        top: 24,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: page,
        ),
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .scale(
        duration: 500.ms,
        begin: Offset(0.8, 0.8),
        end: Offset(1.0, 1.0),
      );
  }

  Widget _buildBottomNav() {
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        return _buildNavItem(index, isActive);
      },
      backgroundColor: Colors.black.withOpacity(0.5),
      activeIndex: _selectedIndex,
      splashColor: Colors.blue,
      notchSmoothness: NotchSmoothness.softEdge,
      gapLocation: GapLocation.center,
      leftCornerRadius: 20,
      rightCornerRadius: 20,
      onTap: (index) => _onNavItemTapped(index),
    );
  }

  Widget _buildNavItem(int index, bool isActive) {
    final color = isActive ? Colors.blue.shade200 : Colors.white60;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconList[index], size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          titleList[index],
          style: TextStyle(color: color, fontSize: 12),
        )
      ],
    ).animate().scale(
      duration: 200.ms,
      begin: Offset(isActive ? 0.8 : 1.0, isActive ? 0.8 : 1.0),
      end: Offset(isActive ? 1.0 : 1.0, isActive ? 1.0 : 1.0),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      controller.animateTo(index);
    });
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Icon(Icons.add)
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2.seconds),
        onPressed: () {
          Navigator.pushNamed(context, '/admin');
        },
      ),
    ).animate()
     .scale(duration: 200.ms, curve: Curves.easeOut);
  }
}