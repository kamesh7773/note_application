import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:multiselect_scope/multiselect_scope.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Multiselect Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //! Controllbar for MultiselectScope widget
  final MultiselectController _multiselectController = MultiselectController();

  //! List of ImageUrl that we use with GridView
  List<String> imageUrls = [
    "https://img.icons8.com/?size=48&id=TJX3x8NCUkFN&format=png",
    "https://img.icons8.com/?size=48&id=YCbKhwUNH1pc&format=png",
    "https://img.icons8.com/?size=48&id=PClBimo4GQGJ&format=png",
    "https://img.icons8.com/?size=48&id=jIM732ayEMfP&format=png",
    "https://img.icons8.com/?size=48&id=34ekiFycLzXv&format=png",
    "https://img.icons8.com/?size=48&id=629QE0a9taSF&format=png",
    "https://img.icons8.com/?size=48&id=Jd0d5Iz2TZIb&format=png",
    "https://img.icons8.com/?size=48&id=wuPAd75eU6lM&format=png",
    "https://img.icons8.com/?size=48&id=5cJddikxEAhI&format=png",
    "https://img.icons8.com/?size=48&id=WbSA1BjDR1gY&format=png",
    "https://img.icons8.com/?size=48&id=V2apQOyk6Gmy&format=png",
    "https://img.icons8.com/?size=48&id=jjfsc2prNeOb&format=png",
    "https://img.icons8.com/?size=48&id=qW0hxm9M3J5x&format=png",
  ];

  //! rebuild the UI Based on item selection.
  void listener() => setState(() {});

  @override
  void initState() {
    super.initState();

    _multiselectController.addListener(listener);
  }

  @override
  void dispose() {
    _multiselectController.addListener(listener);
    _multiselectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! Getting the value of how many item/items is got selected.
    final noOfItemSelected = _multiselectController.getSelectedItems();

    return Scaffold(
      appBar: _multiselectController.selectionAttached
          ? AppBar(
              backgroundColor: Colors.deepPurple[200],
              title: Text("${noOfItemSelected.length} Item is selected"),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    _multiselectController.clearSelection();
                  },
                  icon: const Icon(Icons.close)),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        //! This is will return the list of selected Items.
                        final itemsToRemove = _multiselectController
                            .getSelectedItems()
                            .cast<String>();

                        //! This method remove the selected itesm from orignal list and modified the orignal List.
                        imageUrls = imageUrls
                            .where(
                                (element) => !itemsToRemove.contains(element))
                            .toList();

                        //! This one is just use to clear the selection so when we remove all the items then it will remove the select AppBar() thing.
                        _multiselectController.clearSelection();
                      });
                    },
                    icon: const Icon(Icons.delete))
              ],
            )
          : AppBar(
              backgroundColor: Colors.deepPurple[200],
              title: const Text("MultiSelector"),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.grid_view_rounded),
                  color: Colors.black,
                )
              ],
            ),
      body: MultiselectScope<String>(
        controller: _multiselectController,
        dataSource: imageUrls,
        clearSelectionOnPop: true,
        keepSelectedItemsBetweenUpdates: true,
        onSelectionChanged: (indexes, items) {
          debugPrint(
              'Custom listener invoked! Indexes: $indexes Items: $items');
          return;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    final controller = MultiselectScope.controllerOf(context);

                    final itemIsSelected = controller.isSelected(index);

                    return GestureDetector(
                      //! This will select the item when we long press but once item got selected it not work.
                      onLongPress: () {
                        if (!controller.selectionAttached) {
                          controller.select(index);
                        }
                      },
                      //! After one item got selected then onTap method work for select more then 1 items.
                      onTap: () {
                        if (controller.selectionAttached) {
                          controller.select(index);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: itemIsSelected
                                  ? Border.all(
                                      color: Colors.lightBlueAccent, width: 2)
                                  : Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: imageUrls[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
