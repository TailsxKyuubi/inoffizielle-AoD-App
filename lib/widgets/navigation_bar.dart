import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    int index = this.getRouteIndex(context);
    return BottomNavigationBar(
        currentIndex: index,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).primaryColor,
        onTap: (int i){
          String routeName;
          switch(i){
            case 0:
              routeName = '/home';
              break;
            case 1:
              routeName = '/animes';
              break;
            case 2:
              routeName = '/settings';
              break;
            default:
              routeName = '/home';
              break;
          }
          Navigator.pushReplacementNamed(context, routeName);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Startseite'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: 'Anime'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Einstellungen'
          ),
        ]
    );
  }

  int getRouteIndex(context){
    ModalRoute route = ModalRoute.of(context);
    String routeName = '';
    int index;
    if(route != null){
      routeName = route.settings.name;
    }

    switch(routeName){
      case '/home':
      case '/':
        index = 0;
        break;
      case '/animes':
        index = 1;
        break;
      case '/settings':
        index = 2;
        break;
      default:
        index = 0;
    }
    return index;
  }
}