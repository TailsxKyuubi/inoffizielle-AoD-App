import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/watchlist.dart';

class WatchlistPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width - 40;
    double imageWidth = width / 3;
    int elementCounter = -1;
    EdgeInsets sidePadding = EdgeInsets.only(right: 20, left: 20, bottom: 10);
    return Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
        ),
        body: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
            ),
            height: mediaQuery.size.height,
            child: ListView(
              children: watchListCache.getAll().map((Anime anime) {
                String description = anime.description;
                elementCounter++;

                if (description.length > 48) {
                  int index = description.indexOf(' ', 48);
                  description = description.substring(0, index) + ' ...';
                }
                return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/anime',
                        arguments: anime,
                      );
                    },
                    child: Container(
                        padding: elementCounter > 0 ? sidePadding : EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                                width: imageWidth,
                                child: Image(
                                    image: MemoryImage(anime.image)
                                )
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                width: width - imageWidth,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          anime.name,
                                          textAlign: TextAlign.start,
                                          maxLines: 3,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        )
                                    ),
                                    Container(
                                        child: Text(
                                          description,
                                          style: TextStyle(
                                              color: Colors.white
                                          ),
                                        )
                                    )
                                  ],
                                )
                            )
                          ],
                        )
                    )
                );
              }).toList(),
            )
        )
    );
  }
}