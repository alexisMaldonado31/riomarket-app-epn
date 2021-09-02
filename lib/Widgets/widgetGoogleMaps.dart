import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

// ignore: must_be_immutable
class MapSample extends StatefulWidget {
  bool editable;
  LatLng coordenadas;
  ValueChanged<LatLng> parentAction;
  MapSample(
      {Key key, @required this.editable, this.coordenadas, this.parentAction})
      : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  CameraPosition _kPosition;
  bool _serviceEnabled;
  bool listo = false;
  loc.Location location = new loc.Location();
  loc.PermissionStatus _permissionGranted;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-0.177666, -78.468770),
    zoom: 14.4746,
  );
  Future<bool> prenderGPS() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.GRANTED) {
        _permissionGranted = loc.PermissionStatus.GRANTED;
      }
    }
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      print('si $_serviceEnabled');
      if (_serviceEnabled) {
        return true;
      }
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    iniciarWidget();
  }

  iniciarWidget() async {
    listo = await prenderGPS();

    setState(() {
      print('listo $listo');
    });
    if (listo) {
      if (widget.coordenadas != null) {
        _kPosition = CameraPosition(
            bearing: 192.8334901395799,
            target: widget.coordenadas,
            tilt: 59.440717697143555,
            zoom: 11);
        _goPosition(_kPosition);
      } else {
        getCurrentPosition();
      }
    }
  }

  getCurrentPosition() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _kPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 19);
    _goPosition(_kPosition);
  }

  @override
  Widget build(BuildContext context) {
    return listo
        ? Scaffold(
            body: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers.values.toSet(),
              onTap: _getPositionClick,
              rotateGesturesEnabled: widget.editable,
              scrollGesturesEnabled: widget.editable,
              zoomGesturesEnabled: widget.editable,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: _getLocation,
              backgroundColor: Theme.of(context).primaryColor,
              label: Text('Tu ubicación',
                  style: TextStyle(color: Colors.white), textScaleFactor: 1.0),
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Para acceder a esta función, '
                        'activa la ubicación del dispositivo, '
                        'que usa los servicios de ubicación de Google.',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () {
                        iniciarWidget();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      color: Color(0xffe05c45),
                      textColor: Colors.white,
                      child: Text('Activar GPS'),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _markers.clear();
      final marker = Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: 'Tu ubicación'),
          icon: pinLocationIcon);
      //_markers["Current Location"] = marker;
      _setPosition(LatLng(currentLocation.latitude, currentLocation.longitude));
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            devicePixelRatio: 10, size: Size(double.infinity, double.infinity)),
        'assets/img/navicon.png');
  }

  void _getPositionClick(LatLng pos) {
    setState(() {
      _markers.clear();
      final marker = Marker(
          markerId: MarkerId("curr_loc"),
          position: pos,
          infoWindow: InfoWindow(title: 'Tu ubicación'),
          icon: pinLocationIcon,
          zIndex: 2);
      _markers["Current Location"] = marker;
      _setPosition(pos);
    });
  }

  _setPosition(LatLng pos) {
    widget.parentAction(pos);
  }

  Future<void> _goPosition(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }
}
