import 'package:cached_network_image/cached_network_image.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GridViewProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = DragSelectGridViewController();

  void scheduleRebuild() => setState(() {});

  @override
  void initState() {
    super.initState();
    controller.addListener(scheduleRebuild);
  }

  @override
  void dispose() {
    controller.removeListener(scheduleRebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.value.isSelecting;
    final text =
        isSelected ? "${controller.value.amount} Image Selected" : "GRID VIEW";

    return Scaffold(
      appBar: AppBar(
        title: Text(text),
        centerTitle: true,
        leading: isSelected
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : Container(),
        actions: [
          isSelected
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    var notesQuntity = controller.value.selectedIndexes;
                    context
                        .read<GridViewProvider>()
                        .removeImageUrl(notesQuntity);
                    Navigator.of(context).pop();

                    if (notesQuntity.length > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Notes deleted")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Note deleted")));
                    }
                  })
              : Container()
        ],
      ),
      body: Selector<GridViewProvider, int>(
        selector: (context, image) => image.imageUrls.length,
        builder: (context, value, child) {
          return DragSelectGridView(
            gridController: controller,
            itemCount: value,
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 160,
            ),
            itemBuilder: (context, index, selected) {
              return ContainerWidget(
                imageUrl: context.read<GridViewProvider>().imageUrls[index],
                isSelected: selected,
              );
            },
          );
        },
      ),
    );
  }
}

class ContainerWidget extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  const ContainerWidget({
    super.key,
    required this.isSelected,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Colors.blue, width: 2)
              : Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: CachedNetworkImage(
          imageUrl: imageUrl,
        )),
      ),
    );
  }
}

class GridViewProvider extends ChangeNotifier {
  final List<String> imageUrls = [
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

  //! This Method Remove the ImageURL's From List.
  void removeImageUrl(Set<int> numberOfGridView) {
    List imageurl = numberOfGridView.toList();

    imageurl.sort((a, b) => b.compareTo(a));

    for (var index in imageurl) {
      if (index >= 0 && index < imageUrls.length) {
        imageUrls.removeAt(index);
        notifyListeners();
      }
    }
  }
}
