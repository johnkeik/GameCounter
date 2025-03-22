import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapComponenState extends StatefulWidget {
  const MapComponenState({super.key});

  @override
  State<MapComponenState> createState() => _MapComponenStateState();
}

class _MapComponenStateState extends State<MapComponenState> {
  final List<LatLng> markerLocations = [
    LatLng(40.624212, 22.950193),
    LatLng(40.632227, 22.940664),
    LatLng(40.643552, 22.962493),
  ];
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(40.6401, 22.9444),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayer(
            markers: markerLocations.map((location) {
              return Marker(
                width: 30,
                height: 30,
                point: location,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Hello'),
                                  ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Close'))
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        ]);
  }
}
