import 'package:flutter/material.dart';
import 'package:micropod/components/podcast_cell_widget.dart';
import 'package:micropod/components/universal_scaffold.dart';
import 'package:micropod/models/podcast_pool.dart';
import 'package:micropod/utils/utils.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screenOptions = const <Widget>[
    _HomeScreen(),
    Text('Index 1: Faverate'),
    Text('Index 2: Search'),
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
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.favorite_border))
          ],
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
            selectedItemColor: Colors.amber[800],
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
  const _HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _PodcastSectionWidget(
          q: PoolQuery(),
          title: "Worl Wide",
        ),
        _PodcastSectionWidget(
          q: PoolQuery(country: Country.germany),
          title: "Best of Germany",
        ),
        _PodcastSectionWidget(
          q: PoolQuery(country: Country.iran),
          title: "Best of Iran",
        ),
        _PodcastSectionWidget(
          q: PoolQuery(genre: "Business"),
          title: "Business",
        ),
        // _PodcastSectionWidget(
        //   q: PoolQuery(language: "Fr"),
        //   title: "French",
        // ),
      ],
    );
  }
}

class _PodcastSectionWidget extends StatelessWidget {
  const _PodcastSectionWidget({required this.q, required this.title});
  final PoolQuery q;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PodcastPool>(
        create: (context) => PodcastPool(poolQuery: q),
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                      pool.fetch(poolQuery: q);
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

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
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
