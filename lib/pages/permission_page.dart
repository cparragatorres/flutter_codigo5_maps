import 'package:flutter/material.dart';
import 'package:flutter_codigo5_maps/pages/home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatefulWidget {
  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {

  checkPermission(PermissionStatus status){
    switch(status){
      case PermissionStatus.granted:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));

        break;
      case PermissionStatus.denied:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        openAppSettings();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            SvgPicture.asset(
              'assets/images/location.svg',
              height: 140.0,
            ),
            const SizedBox(
              height: 14.0,
            ),
            const Text(
              "Permite tu ubicación",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Color(0xff202644),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Para poder utilizar todas las funcionalidades de nuestra aplicación por favor acepta los permisos para acceder a tu ubicación",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Color(0xff202644).withOpacity(0.8),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async{
                PermissionStatus status = await Permission.location.request();
                print(status);
                checkPermission(status);
                //Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));

              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              child: const Text(
                "Activar GPS",
              ),
            ),
          ],
        ),
      ),
    );
  }
}