import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_way/model/directions.dart';
import 'package:my_way/model/place.dart';
import 'package:my_way/repositories/directions_repository.dart';

class MapScreen extends StatefulWidget {
  List<PlaceModel> places;

  MapScreen({this.places, Key key}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController _googleMapController;
  Directions _info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildGoogleMap,
    );
  }

  @override
  void initState() {
    getDirections();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Widget get buildGoogleMap => GoogleMap(
        myLocationEnabled: true,
        //Haritada mevcut konumumuzu mavi bir nokta ile göstermek için.
        myLocationButtonEnabled: false,
        //Bu düğme, kullanıcı konumunu kamera görünümünün merkezine getirmek için kullanılır.
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        //Harita görünümünün yakınlaştırma hareketlerine yanıt verip vermeyeceği .
        zoomControlsEnabled: false,
        //Yakınlaştırma kontrollerinin gösterilip gösterilmeyeceği (yalnızca Android için geçerlidir).
        polylines: {
          if (_info != null)
            Polyline(
              polylineId: const PolylineId('overview_polyline'),
              color: Colors.red,
              width: 5,
              points: _info.polylinePoints
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList(),
            ),
        },
        onMapCreated: (controller) => _googleMapController = controller,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.places.first.lat, widget.places.first.long),
            zoom: 10),
        mapType: MapType.normal,
        markers: createMarker(),
      );

  Set<Marker> createMarker() {
    return widget.places
        .map((e) => Marker(
            markerId: MarkerId(e.hashCode.toString()),
            position: LatLng(e.lat, e.long),
            icon: BitmapDescriptor.defaultMarker,
            zIndex: 10,
            infoWindow: InfoWindow(title: e.name)))
        .toSet();
  }

  void getDirections() async {
    final directions = await DirectionsRepository().getDirections(
        origin: LatLng(widget.places.first.lat, widget.places.first.long),
        destination: LatLng(widget.places.last.lat, widget.places.last.long));
    setState(() => _info = directions);
  }
}
