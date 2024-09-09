import 'package:flutter/material.dart';
import 'package:frontend/src/features/user_dropdown_menu/user_details_view.dart';
import 'dart:developer';

import 'package:frontend/src/features/user_dropdown_menu/user_model.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.search),
        label: const Text("Search for user"),
        onPressed: () {
          Navigator.restorablePushNamed(context, SearchBarPage.routeName);
        }
      )
      );
  } 
}


class SearchBarPage extends StatefulWidget {
  const SearchBarPage({super.key, required this.service});
  static const routeName = "/searchbar";
  final Function(String) service;

  @override
  State<SearchBarPage> createState() => SearchBarPageState();
}


class SearchBarPageState extends State<SearchBarPage> {
  late Future<List<User>> futureUsersList;

  @override
  void initState() {
    super.initState();
    futureUsersList = Future(() => [],);
  }

  @override
  Widget build(context) {
    log("building search bar page");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () {controller.openView();},
                  onChanged: (_) {controller.openView();},
                  onSubmitted: (query) async {
                    final currentContext = context;
                    try {
                      setState(() {
                        futureUsersList = widget.service(query);
                      });
                      await futureUsersList;
                    } catch(e) {
                      if (currentContext.mounted) {
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                      }
                    }
                    
                  },
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                return List<ListTile>.generate(5, (int index) {
                  final String item = "item $index";
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      controller.closeView(item);
                    }
                  );
                }); 
              },
            )
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsersList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Users not found"));
                }
                List<User> usersList = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: usersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const Icon(Icons.access_alarm_outlined),
                      title: Text(usersList[index].username),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsView(user: usersList[index]),
                          ),
                        );
                      }
                    );
                  },
                );
              },
            ),
          )
        ]
      ),
    );
  }
}
