import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/animes.dart' as animesCache;
import 'package:unoffical_aod_app/widgets/animes/anime.dart';

class SearchResultWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchResultState();
}

class SearchResultState extends State<SearchResultWidget> {
  TextEditingController _controller = TextEditingController();
  List<Anime> searchResult = [];

  SearchResultState(){
    this._controller.addListener(onTextInput);
  }

  onTextInput(){
    print(this._controller.text);
    this.searchResult = animesCache.filterAnimes(this._controller.text);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    double elementWidth = (MediaQuery.of(context).size.width-40)*0.5-7;
    double elementHeight = elementWidth / 16 * 9;
    Radius radius = Radius.circular(5);
    int i = 0;
    return
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
        ),
        child: ListView(
          children: [
            TextField(
              controller: this._controller,
              cursorColor: Theme.of(context).accentColor,
              decoration: const InputDecoration(
                hintText: 'Suche',
                hintStyle: TextStyle(
                    color: Colors.white
                ),
              ),
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            Wrap(
              children: searchResult.map(
                      (Anime e) => AnimeSmallWidget(
                      e,
                      elementWidth,
                      elementHeight,
                      radius,
                      ++i
                  )
              ).toList(),
            )
          ],
        ),
      );
  }

}