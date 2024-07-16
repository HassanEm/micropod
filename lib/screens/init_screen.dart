import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micropod/components/podcast_cell_widget.dart';
import 'package:micropod/components/universal_scaffold.dart';
import 'package:micropod/models/favorites_pool.dart';
import 'package:micropod/models/podcast_pool.dart';
import 'package:micropod/utils/http_services.dart';
import 'package:micropod/utils/utils.dart';
import 'package:provider/provider.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();

    /// Home
    Map<String, PodcastPool> pools = {
      "Worl Wide": PodcastPool.chart(),
    };
    HttpService().getGeolocation().then((json) {
      if (json != null) {
        final counrty = countryCodeDict[json["country"]];
        if (counrty != null) {
          pools.addAll({
            "Best of ${counrty.name}":
                PodcastPool.chart(poolQuery: PoolQuery(country: counrty))
          });
        }
      }
      pools.addAll({
        "Business": PodcastPool.chart(poolQuery: PoolQuery(genre: "Business")),
        "Comedy": PodcastPool.chart(poolQuery: PoolQuery(genre: "Comedy")),
        "BPlus": PodcastPool.search(poolQuery: PoolQuery(term: "bplus")),
      });
      print("geo json===> $json");
      _screenOptions.removeAt(0);
      _screenOptions.insert(
          0,
          _HomeScreen(
            pools: pools,
          ));
      setState(() {});
    });
  }

  int _selectedIndex = 0;

  final List<Widget> _screenOptions = <Widget>[
    const Center(child: CircularProgressIndicator()),
    const _FavoriteScreen(),
    _SearchSection(
      pool: PodcastPool.search(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return UniversalScaffold(
        appBar: AppBar(
          // backgroundColor: Colors.amber,
          title: Text(
            '🎼 MicroPod',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor))),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber.shade800,
            onTap: _onItemTapped,
          ),
        ),
        body: _screenOptions[_selectedIndex]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({required this.pools, super.key});

  final Map<String, PodcastPool> pools;

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: pools.entries
            .map((entry) =>
                _PodcastSectionWidget(title: entry.key, pool: entry.value))
            .toList());
  }
}

class _PodcastSectionWidget extends StatelessWidget {
  const _PodcastSectionWidget({required this.pool, required this.title});
  final String title;
  final PodcastPool pool;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: pool,
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Consumer<PodcastPool>(builder: (context, pool, _) {
                if (pool.count == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          pool.fetchState == FetchState.fetching
                              ? const Text("Loading...")
                              : Text(pool.fetchState == FetchState.error
                                  ? pool.erorr ?? "Something went wrong"
                                  : "Nothing found."),
                          TextButton(
                              onPressed: pool.fetchState == FetchState.fetching
                                  ? null
                                  : () {
                                      pool.fetch();
                                    },
                              child: const Text("REFRESH"))
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 220,
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: pool.count,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) => SizedBox(
                          width: 150,
                          height: 180,
                          child: PodcastCellWidget(pool.podcasts![i]))),
                );
              }),
            ],
          );
        });
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({super.key});

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class _FavoriteScreen extends StatelessWidget {
  const _FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesPool>(builder: (context, favPool, _) {
      if (favPool.episodes.isEmpty && favPool.podcasts.isEmpty) {
        return const Center(
          child: Text(
            "No any favorite items",
            textAlign: TextAlign.center,
          ),
        );
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                if (favPool.favGener == null || favPool.favGener!.isEmpty) {
                  return const SizedBox();
                } else {
                  final color = letterToMateriaColor(favPool.favGener![0]);
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8)),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "Your Favorite Subject is",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.apply(color: color),
                            children: [
                              const TextSpan(text: "\n"),
                              TextSpan(
                                  text: favPool.favGener,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.apply(color: color))
                            ])),
                  );
                }
              },
            ),
            SizedBox(
              height: 252,
              child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: favPool.podcasts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => SizedBox(
                      width: 150,
                      height: 180,
                      child: PodcastCellWidget(favPool.podcasts[i]))),
            ),
          ],
        ),
      );
    });
  }
}

class _SearchSection extends StatefulWidget {
  const _SearchSection({required this.pool, super.key});
  final PodcastPool pool;

  @override
  State<_SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<_SearchSection> {
  @override
  void initState() {
    queryTerm = widget.pool.q.term;
    super.initState();
  }

  String queryTerm = "";
  bool searching = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CupertinoTextField(
            prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.search, color: Colors.grey)),
            suffix: searching
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: CupertinoActivityIndicator(),
                  )
                : null,
            controller: TextEditingController(text: queryTerm),
            placeholder: "What you looking for? 👁‍🗨",
            style: const TextStyle(color: Colors.white),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade800,
            ),
            onSubmitted: (value) async {
              queryTerm = value;
              setState(() => searching = true);
              await widget.pool.newSearch(PoolQuery(term: value));
              setState(() => searching = false);
            },
          ),
          if (queryTerm.isNotEmpty == true)
            _PodcastSectionWidget(
                pool: widget.pool, title: 'Result for "$queryTerm"')
        ],
      ),
    );
  }
}
