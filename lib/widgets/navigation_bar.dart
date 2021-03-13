import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';

class NavigationBar extends StatefulWidget{

  NavigationBar();
  @override
  State<StatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {

  int getRouteIndex(){
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

  @override
  Widget build(BuildContext context) {
    int index = this.getRouteIndex();
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event){
          print('focus is on the menu');
        },
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
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
                  animeFocusNodesIndex = -1;
                  break;
                case 2:
                  routeName = '/settings';
                  break;
                default:
                  routeName = '/home';
                  break;
              }
              Navigator.pushReplacementNamed(context, routeName);
              //widget.firstFocusNode.requestFocus();
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
        )
    );
  }
}