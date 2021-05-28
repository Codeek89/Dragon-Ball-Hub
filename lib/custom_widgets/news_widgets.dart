import 'package:carousel_slider/carousel_slider.dart';
import 'package:dragonballhub/models/news_model.dart';
import 'package:dragonballhub/providers/all_news_providers.dart';
import 'package:dragonballhub/providers/top_level_provider.dart';
import 'package:dragonballhub/screens/webview_news_screen.dart';
import 'package:dragonballhub/states/recent_news.dart';
import 'package:dragonballhub/utils/layout_responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeBackWidget extends StatelessWidget {
  final double height;

  WelcomeBackWidget({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Text(
              "Welcome back, ${context.read(userCloudProvider).userDataModel.nome}",
              style: GoogleFonts.nunito(
                letterSpacing: 0,
                fontSize: SizeConfig.textMultiplier * 3.5,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2),
          Flexible(
            flex: 2,
            child: Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}

class NewsBox extends StatelessWidget {
  final String image;
  final String title;
  final String urlPage;
  final String description;
  final String date;

  NewsBox({
    required this.title,
    required this.image,
    required this.urlPage,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DisplayNewsScreen(urlPage: urlPage))
        );
      },
      child: Container(
        height: SizeConfig.heightMultiplier * 20,
        width: SizeConfig.widthMultiplier * 85,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(2, 5))
            ]),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: SizeConfig.aspectRatio! * 1.2,
                child: Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(image, fit: BoxFit.cover))),
              ),
            ),
            Flexible(
              flex: 5,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5.0),
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.textMultiplier * 2,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 1.8, top: 20),
                      child: Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.textMultiplier * 1.6,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: SizeConfig.heightMultiplier * 1,
                    right: SizeConfig.widthMultiplier * 1.8,
                    child: Text(
                      date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.textMultiplier * 1.2,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePictureAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: IconButton(
        iconSize: SizeConfig.imageSizeMultiplier * 9,
        icon: CircleAvatar(
          radius: SizeConfig.imageSizeMultiplier * 5.5,
          backgroundImage: AssetImage("res/vegeth.jpg"),
        ),
        onPressed: () {
          //Navigator.push(context,
          //  MaterialPageRoute(builder: (context) => UserPage()));
        },
      ),
    );
  }
}

class RecentNewsSlider extends StatefulWidget {
  @override
  _RecentNewsSliderState createState() => _RecentNewsSliderState();
}

class _RecentNewsSliderState extends State<RecentNewsSlider> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final state = watch(recentNewsProvider.state);
        if(state is RecentNewsFetched) {
        return CarouselSlider(
                options: CarouselOptions(
                  height: SizeConfig.heightMultiplier * 30,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 1700),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  //onPageChanged: (value, ) {},
                  scrollDirection: Axis.horizontal,
                ),
                items: state.newsList!.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DisplayNewsScreen(
                                      urlPage: state.newsList![state.newsList!.indexOf(i)].url
                                  )));
                        },
                        child: RecentNewsBox(
                          state: state,
                          element: i,
                        )
                      );
                    },
                  );
                }).toList(),
              );
            } else if (state is LoadingRecentNewsState) {
              return Center(child: CircularProgressIndicator());
            }
            else if (state is RecentNewsError) {
              return Center(child: Text('Something went wrong :('));
            }
            else {
              return Center(child: Text("No news available."));
            }
}
    );
  }
}

class RecentNewsBox extends StatefulWidget {
  final RecentNewsFetched state;
  final NewsModel element;

  RecentNewsBox({required this.state, required this.element});

  @override
  _RecentNewsBoxState createState() => _RecentNewsBoxState();
}

class _RecentNewsBoxState extends State<RecentNewsBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            height: SizeConfig.heightMultiplier * 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        widget.state
                            .newsList![
                        widget.state.newsList!.indexOf(widget.element)]
                            .img,
                        fit: BoxFit.fill,
                        height: SizeConfig.screenHeight * 100,
                        width: SizeConfig.screenWidth * 100,
                      )),
                ),
                Wrap(
                  children: <Widget>[
                    Container(
                      height:
                      SizeConfig.heightMultiplier * 10,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 10,
                            left: 10,
                            right: 10,
                            child: Container(
                              height: 30,
                              child: Text(
                                widget.state
                                    .newsList![widget.state.newsList!
                                    .indexOf(widget.element)]
                                    .title,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: SizeConfig
                                        .textMultiplier *
                                        2,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.deepOrange),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            left: 10,
                            right: 10,
                            child: Container(
                              height: 30,
                              child: Text(
                                widget.state
                                    .newsList![widget.state.newsList!
                                    .indexOf(widget.element)]
                                    .description,
                                maxLines: 2,
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontStyle:
                                    FontStyle.italic,
                                    fontSize: SizeConfig
                                        .textMultiplier *
                                        1.27),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class NewsListView<T> extends StatefulWidget {
  final T state;

  NewsListView({required this.state});

  @override
  _NewsListViewState createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: widget.state.newsList!.length,
        itemBuilder: (context, index) {
          return NewsBox(
            title: widget.state.newsList![index].title,
            description: widget.state.newsList![index].description,
            urlPage: widget.state.newsList![index].url,
            image: widget.state.newsList![index].img,
            date: widget.state.newsList![index].date,
          );
        });
  }
}
