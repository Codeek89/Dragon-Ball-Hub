import 'package:dragonballhub/custom_widgets/dbh_drawer.dart';
import 'package:dragonballhub/custom_widgets/news_widgets.dart';
import 'package:dragonballhub/custom_widgets/search_page_widgets.dart';
import 'package:dragonballhub/providers/all_news_providers.dart';
import 'package:dragonballhub/screens/search_news_page.dart';
import 'package:dragonballhub/states/db_states.dart';
import 'package:dragonballhub/states/dbsuper_states.dart';
import 'package:dragonballhub/states/dbz_states.dart';
import 'package:dragonballhub/states/manga_states.dart';
import 'package:dragonballhub/states/videogames_states.dart';
import 'package:dragonballhub/utils/layout_responsiveness.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsScreen extends ConsumerWidget {
  static const id = "/news_screen";

  void loadNewsStates(ScopedReader watch) {
    final recentProvider = watch(recentNewsProvider);
    final mangaNewsProvider = watch(mangaProvider);
    final dbSuperNewsProvider = watch(dbSuperProvider);
    final dbZNewsProvider = watch(dbZProvider);
    final dbNewsProvider = watch(dbProvider);
    final videogamesNewsProvider = watch(videogamesProvider);

    recentProvider.getRecentNews();
    mangaNewsProvider.getMangaNews();
    dbSuperNewsProvider.getDbSuperNews();
    dbZNewsProvider.getDbZNews();
    dbNewsProvider.getDbNews();
    videogamesNewsProvider.getVideogamesNews();
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    this.loadNewsStates(watch);

    return Scaffold(
      drawer: DbhDrawer(),
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.orange, Colors.deepOrange])),
        child: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 1), () {
              this.loadNewsStates(watch);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Page Refreshed'),
                ),
              );
            });
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: AppBar(
                backgroundColor: Colors.transparent,
                toolbarHeight: 50,
                flexibleSpace: Stack(
                  children: [
                    Image.asset("res/appbar_wallpaper.png",
                        fit: BoxFit.scaleDown),
                    Positioned(
                        bottom: 10,
                        left: 20,
                        child: Text(
                          "News",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 4,
                              color: Colors.white,
                              fontWeight: FontWeight.w300
                          ),
                        )),
                  ],
                ),
              )),
              SliverList(
                delegate: SliverChildListDelegate([
                  NewsDashboard(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsDashboard extends StatefulWidget {
  @override
  _NewsDashboardState createState() => _NewsDashboardState();
}

class _NewsDashboardState extends State<NewsDashboard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
      child: Material(
        elevation: 25.0,
        borderRadius: BorderRadius.all(Radius.circular(14)),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              children: [
                WelcomeBackWidget(height: SizeConfig.heightMultiplier * 15),
                Container(
                  child: GestureDetector(
                    child: Hero(
                      tag: 'search',
                      child: SearchBar(
                        hintText: "Search news",
                        isEnabled: false,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, SearchNewsPage.id);
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5.0),
                  child: Row(
                    children: [
                      Text(
                        "Recent News",
                        style: GoogleFonts.nunito(
                          letterSpacing: 0,
                          fontSize: SizeConfig.textMultiplier * 3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                RecentNewsSlider(),
                SizedBox(height: 20),
                Divider(
                  thickness: 1.4,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    children: [
                      Text(
                        "All News",
                        style: GoogleFonts.nunito(
                          letterSpacing: 0,
                          fontSize: SizeConfig.textMultiplier * 3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Consumer(builder: (context, watch, child) {
                  return DefaultTabController(
                    length: 5,
                    child: SizedBox(
                      height: SizeConfig.heightMultiplier * 80,
                      child: Column(
                        children: <Widget>[
                          TabBar(
                            labelColor: Colors.deepOrange,
                            isScrollable: true,
                            physics: BouncingScrollPhysics(),
                            indicatorColor: Colors.deepOrangeAccent,
                            unselectedLabelColor: Colors.black.withOpacity(0.3),
                            labelStyle: GoogleFonts.nunito(
                              letterSpacing: 0,
                              fontSize: SizeConfig.textMultiplier * 2,
                              fontWeight: FontWeight.w500,
                            ),
                            tabs: <Widget>[
                              Tab(
                                text: "Manga Super",
                              ),
                              Tab(
                                text: "Dragon Ball Super",
                              ),
                              Tab(
                                text: "Dragon Ball Z",
                              ),
                              Tab(
                                text: "Dragon Ball",
                              ),
                              Tab(
                                text: "Videogames",
                              )
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: Consumer(
                                      builder: (context, watch, child) {
                                        final mangaNewsState =
                                            watch(mangaProvider.state);
                                        if (mangaNewsState
                                            is LoadingMangaState) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (mangaNewsState is MangaNewsError) {
                                          return Center(
                                              child: Text(
                                                  'Something went wrong :('));
                                        } else if (mangaNewsState
                                            is MangaNewsFetched) {
                                          return mangaNewsState.newsList != null
                                              ? NewsListView<MangaNewsFetched>(
                                                  state: mangaNewsState)
                                              : Center(
                                                  child: Text(
                                                      "No news available."));
                                        } else {
                                          return Center(
                                              child: Text("Mistake!"));
                                        }
                                      },
                                    )),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: Consumer(
                                      builder: (context, watch, child) {
                                        final dbSuperNewsState =
                                            watch(dbSuperProvider.state);
                                        if (dbSuperNewsState
                                            is LoadingDbSuperState) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (dbSuperNewsState
                                            is DbSuperNewsError) {
                                          return Center(
                                              child: Text(
                                                  'Something went wrong :('));
                                        } else if (dbSuperNewsState
                                            is DbSuperNewsFetched) {
                                          return dbSuperNewsState.newsList !=
                                                  null
                                              ? NewsListView<DbSuperNewsFetched>(
                                                  state: dbSuperNewsState)
                                              : Center(
                                                  child: Text(
                                                      "No news available."));
                                        } else {
                                          return Center(
                                              child: Text("Mistake!"));
                                        }
                                      },
                                    )),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: Consumer(
                                      builder: (context, watch, child) {
                                        final dbzNewsState =
                                            watch(dbZProvider.state);
                                        if (dbzNewsState is LoadingDbZState) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (dbzNewsState is DbZNewsError) {
                                          return Center(
                                              child: Text(
                                                  'Something went wrong :('));
                                        } else if (dbzNewsState
                                            is DbZNewsFetched) {
                                          return dbzNewsState.newsList != null
                                              ? NewsListView<DbZNewsFetched>(
                                                  state: dbzNewsState)
                                              : Center(
                                                  child: Text(
                                                      "No news available."));
                                        } else {
                                          return Center(
                                              child: Text("Mistake!"));
                                        }
                                      },
                                    )),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: Consumer(
                                      builder: (context, watch, child) {
                                        final dbNewsState =
                                            watch(dbProvider.state);
                                        if (dbNewsState is LoadingDbState) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (dbNewsState is DbNewsError) {
                                          return Center(
                                              child: Text(
                                                  'Something went wrong :('));
                                        } else if (dbNewsState
                                            is DbNewsFetched) {
                                          return dbNewsState.newsList != null
                                              ? NewsListView<DbNewsFetched>(
                                                  state: dbNewsState)
                                              : Center(
                                                  child: Text(
                                                      "No news available."));
                                        } else {
                                          return Center(
                                              child: Text("Mistake!"));
                                        }
                                      },
                                    )),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: Consumer(
                                      builder: (context, watch, child) {
                                        final videogamesNewsState =
                                            watch(videogamesProvider.state);
                                        if (videogamesNewsState
                                            is LoadingVideogamesState) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (videogamesNewsState
                                            is VideogamesNewsError) {
                                          return Center(
                                              child: Text(
                                                  'Something went wrong :('));
                                        } else if (videogamesNewsState
                                            is VideogamesNewsFetched) {
                                          return videogamesNewsState.newsList !=
                                                  null
                                              ? NewsListView<
                                                      VideogamesNewsFetched>(
                                                  state: videogamesNewsState)
                                              : Center(
                                                  child: Text(
                                                      "No news available."));
                                        } else {
                                          return Center(
                                              child: Text("Mistake!"));
                                        }
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            )),
      ),
    );
  }
}
