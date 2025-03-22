import 'package:flutter/material.dart';
import '../../data/monuments.dart';

class MonumentsList extends StatefulWidget {
  const MonumentsList({super.key});

  @override
  State<StatefulWidget> createState() => _MonumentsListState();
}

class _MonumentsListState extends State<MonumentsList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        childAspectRatio: 0.5, // Adjust this to change the aspect ratio
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
      ),
      itemCount: monuments.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: NetworkImage(monuments[index]['imgSrc'] ??
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                fit: BoxFit.cover, // Ensure image covers the space
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      monuments[index]['title'] ?? '',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Limit title to 1 line
                    ),
                    const SizedBox(height: 5),
                    Text(
                      monuments[index]['description'] ?? '',
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
