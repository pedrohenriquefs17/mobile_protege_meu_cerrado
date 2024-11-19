import 'package:flutter/material.dart';

class CustomBottomNavBar  extends StatelessWidget{
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        
        BottomNavigationBarItem(
          icon: Icon(Icons.report),
          label: 'Ocorrências',
        ),
        
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Blog',
        ),
        
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configurações',
        ),
      ],
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
    );
  }
}