import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerScreen extends StatefulWidget {
  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _selectedLatLng = const LatLng(19.0760, 72.8777); // Default: Mumbai
  String _address = '';
  final TextEditingController _searchController = TextEditingController();

  void _onMapTapped(LatLng position) async {
    setState(() => _selectedLatLng = position);
    await _updateAddressFromLatLng(position);
  }

  Future<void> _updateAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address = '${place.street}, ${place.locality}, ${place.postalCode}';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _searchAndNavigate() async {
    try {
      final locations = await locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final newLatLng = LatLng(location.latitude, location.longitude);
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLatLng, 15));
        _onMapTapped(newLatLng);
      }
    } catch (e) {
      print('Search error: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Address')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _selectedLatLng, zoom: 15),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTapped,
            markers: {
              Marker(markerId: const MarkerId('selected'), position: _selectedLatLng),
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchAndNavigate(),
                decoration: InputDecoration(
                  hintText: "Search location",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchAndNavigate,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'address': _address,
                  'lat': _selectedLatLng.latitude,
                  'lng': _selectedLatLng.longitude,
                });
              },
              child: const Text('Select This Location'),
            ),
          ),
        ],
      ),
    );
  }
}
