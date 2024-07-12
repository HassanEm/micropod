// import 'package:flutter/material.dart';

// enum FetchState {
//   unfetched,
//   fetching,
//   fetched,
//   error,
// }

// abstract class Pool<T, S> extends ChangeNotifier {
//   ///max range of items that request from the server in each request
//   static const take = 30;

//   ///this variable only hold pool skip for infinity scroll feature
//   ///each time we receive to end of item list if items list lenth < skip + take  then skip += take and new request sending
//   int skip = 0;

//   ///this variable only hold search word for update UI and infinity scroll feature
//   S? _queryFilter;
//   S? get queryFilter => _queryFilter;

//   ///

//   ///this flag represents the connection state stream on fetching items to pool
//   FetchState _fetchState = FetchState.unfetched;
//   FetchState get fetching => _fetchState;
//   void startFetching() {
//     _fetchState = FetchState.fetching;
//     notifyListeners();
//   }

//   late final BuildContext _context;
//   Pool(this._context, [this._queryFilter]) {
//     ///start fetching new data
//     startFetching();
//     fetchItems(_context, skip, take, queryFilter).then((initialCases) {
//       _fetchState = FetchState.fetched;
//       _items = initialCases;
//       notifyListeners();
//     });
//   }
//   List<T> _items = [];
//   List<T> get items => _items;

//   void put(T item) {
//     _items.insert(0, item); //update pool
//     skip += 1;
//     notifyListeners(); //update UI
//   }

//   void insertFirst(T newItem) {
//     skip++;
//     _items.insert(0, newItem);

//     notifyListeners(); //update UI
//   }

//   void remove(bool Function(T) test) {
//     _items.removeWhere(test); //update pool
//     _fetchState = FetchState.fetched;
//     skip--;
//     notifyListeners(); //update UI
//   }

//   Future<List<T>> fetchItems(
//       BuildContext context, int skip, int take, S? query);

//   Future<void> refresh(S? newQueryFilter, {bool force = false}) async {
//     ///skip function  if no paramtes changged
//     // print("queryFilter == newQueryFilter=> ${queryFilter == newQueryFilter}");
//     if (queryFilter == newQueryFilter && !force) return;
//     startFetching();
//     _queryFilter = newQueryFilter;

//     skip = 0;
//     final items = await fetchItems(_context, skip, take, newQueryFilter);
//     _items = items;
//     _fetchState = FetchState.fetched;
//     notifyListeners();
//   }

//   bool get allItemsFetched => _items.length != skip + take;
//   Future<void> loadMore(
//       [Duration delay = const Duration(milliseconds: 400)]) async {
//     ///avoid from called during build.
//     await Future.delayed(delay);

//     ///skip function  if no paramtes changged
//     if (allItemsFetched) return;
//     startFetching();
//     skip = skip + take;
//     final items = await fetchItems(_context, skip, take, queryFilter);
//     _items.addAll(items);
//     _fetchState = FetchState.fetched;
//     notifyListeners();
//   }
// }
