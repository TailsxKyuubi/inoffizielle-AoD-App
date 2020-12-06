import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/widgets/animes/anime.dart';
import '../caches/animes.dart' as animes;

class AnimesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnimesWidgetState();
}

class _AnimesWidgetState extends State<AnimesWidget> {
  TextEditingController _controller = TextEditingController();
  List<Anime> searchResult = animes.animes;

  _AnimesWidgetState(){
    this._controller.addListener(onTextInput);
  }

  onTextInput(){
    if(this._controller.text.length >= 3){
      this.searchResult = animes.filterAnimes(this._controller.text);
    }else if(this._controller.text.isEmpty){
      this.searchResult = animes.animes;
    }else{
      this.searchResult = [];
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);*/
    int i = 0;
    double elementWidth = (MediaQuery.of(context).size.width-40)*0.5-7;
    double elementHeight = elementWidth / 16 * 9;
    Radius radius = Radius.circular(2);
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
        ),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(5)
                  ),

                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey
                    ),
                    child: TextField(
                      controller: this._controller,
                      cursorColor: Theme.of(context).accentColor,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: -14),
                        hintText: 'Suche',
                        hintStyle: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: this.searchResult.map<Widget>(
                        (Anime anime) =>
                        AnimeSmallWidget(
                            anime,
                            elementWidth,
                            elementHeight,
                            radius,
                            ++i
                        )
                ).toList(),
              )
            ]
        )
    );
  }
}
