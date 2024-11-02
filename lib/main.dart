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


void main() {
  runApp(
    MaterialApp(
      title: "Tab Bar",
      initialRoute: '/login',   
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Home(),
      },
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
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apps, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'Empat Mobile Apps',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Colors.white, Colors.blue.shade200],
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_rounded),
          onPressed: () {},
        ).animate().fadeIn(delay: 300.ms),
      ],
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
        ),
      ),
      child: Stack(
        children: [
          // Animated background elements
          Positioned(
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
           .moveX(duration: 6.seconds, curve: Curves.easeInOut),

          // Main content
          TabBarView(
            controller: controller,
            children: <Widget>[
              _buildAnimatedPage(komputer.Home()),
              _buildAnimatedPage(headset.Info()),
              _buildAnimatedPage(radio.AgendaScreen()),
              _buildAnimatedPage(hp.Gallery()),
            ],
          ),
        ],
      ),
    );
  }

    Widget _buildAnimatedPage(Widget page) {
    return Container(
      margin: EdgeInsets.all(16),
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
        final color = isActive ? Colors.blue.shade200 : Colors.white60;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconList[index],
              size: 24,
              color: color,
            ),
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
      },
      backgroundColor: Colors.black.withOpacity(0.5),
      activeIndex: _selectedIndex,
      splashColor: Colors.blue,
      notchSmoothness: NotchSmoothness.softEdge,
      gapLocation: GapLocation.center,
      leftCornerRadius: 20,
      rightCornerRadius: 20,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          controller.animateTo(index);
        });
      },
    );
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
          // Add your action here
        },
      ),
    ).animate()
     .scale(duration: 200.ms, curve: Curves.easeOut);
  }
}