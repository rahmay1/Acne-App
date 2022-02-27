import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
// import 'package:acne_detector/pages/root_app.dart';
import 'package:acne_detector/search/searchPage.dart';
import 'package:image/image.dart' as imagelib;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  VideoPlayerController? videoController;

  File? _imageFile;

  // Initial values
  bool _isCameraInitialized = false;
  bool _isRearCameraSelected = true;

  // Current values
  FlashMode? _currentFlashMode;

  List<File> allFileList = [];

  final resolutionPresets = ResolutionPreset.values;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  refreshAlreadyCapturedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();
    List<Map<int, dynamic>> fileNames = [];

    for (var file in fileList) {
      if (file.path.contains('.jpg')) {
        allFileList.add(File(file.path));

        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    }

    if (fileNames.isNotEmpty) {
      final recentFile =
      fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];

      _imageFile = File('${directory.path}/$recentFileName');

      //var image = _isRearCameraSelected ? imagelib.decodeJpg(_imageFile!.readAsBytesSync()) : imagelib.flip(imagelib.decodeImage(_imageFile!.readAsBytesSync())!, imagelib.Flip.horizontal);
      var image = imagelib.decodeJpg(_imageFile!.readAsBytesSync());
      var croppedImage = imagelib.copyCrop(image!, image.width~/2 - 250, image.height~/2 - 250, 500, 500);
      File('${directory.path}/$recentFileName').writeAsBytesSync(imagelib.encodePng(croppedImage));
      _imageFile = File('${directory.path}/$recentFileName');

      setState(() {});
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();

      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    // Hide the status bar in Android
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: []);
    // Set and initialize the new camera
    onNewCameraSelected(cameras[0]);
    refreshAlreadyCapturedImages();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isCameraInitialized
            ? Column(
          children: [
            AspectRatio(
              aspectRatio: 1 / (controller!.value.aspectRatio - 0.1),
              child: Stack(
                children: [
                  controller!.buildPreview(),
                  cameraOverlay(
                      padding: 50, aspectRatio: 1, color: const Color(0x55000000)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16.0,
                      8.0,
                      16.0,
                      8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                              ),
                              child: DropdownButton<ResolutionPreset>(
                                dropdownColor: Colors.black87,
                                underline: Container(),
                                value: currentResolutionPreset,
                                items: [
                                  for (ResolutionPreset preset
                                  in resolutionPresets)
                                    DropdownMenuItem(
                                      child: Text(
                                        preset
                                            .toString()
                                            .split('.')[1]
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      value: preset,
                                    )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    currentResolutionPreset = value!;
                                    _isCameraInitialized = false;
                                  });
                                  onNewCameraSelected(
                                      controller!.description);
                                },
                                hint: const Text("Select item"),
                              ),
                            ),
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Container(
                              height: 30,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isCameraInitialized = false;
                                });
                                onNewCameraSelected(cameras[
                                _isRearCameraSelected ? 1 : 0]);
                                setState(() {
                                  _isRearCameraSelected =
                                  !_isRearCameraSelected;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.black38,
                                    size: 60,
                                  ),
                                  Icon(
                                    _isRearCameraSelected
                                        ? Icons.camera_front
                                        : Icons.camera_rear,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                XFile? rawImage =
                                await takePicture();
                                File imageFile =
                                File(rawImage!.path);

                                int currentUnix = DateTime.now()
                                    .millisecondsSinceEpoch;

                                final directory =
                                await getApplicationDocumentsDirectory();

                                String fileFormat =
                                    imageFile.path.split('.').last;

                                print(fileFormat);

                                await imageFile.copy(
                                  '${directory.path}/$currentUnix.$fileFormat',
                                );

                                refreshAlreadyCapturedImages();
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.white38,
                                    size: 80,
                                  ),
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                    size: 65,
                                  ),
                                  Container(),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap:
                              _imageFile != null
                                  ? () {

                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         RootApp(
                                //           image: _imageFile,
                                //         ),
                                //   ),
                                // );

                                imagePicked = _imageFile;
                                Navigator.of(context).pop(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                      const MyApp(),
                                  ),
                                );
                              }
                                  : null,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  image: _imageFile != null
                                      ? DecorationImage(
                                    image: FileImage(_imageFile!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: videoController != null &&
                                    videoController!
                                        .value.isInitialized
                                    ? ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  child: AspectRatio(
                                    aspectRatio: videoController!
                                        .value.aspectRatio,
                                    child: VideoPlayer(
                                        videoController!),
                                  ),
                                )
                                    : Container(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _currentFlashMode = FlashMode.off;
                              });
                              await controller!.setFlashMode(
                                FlashMode.off,
                              );
                            },
                            child: Icon(
                              Icons.flash_off,
                              color: _currentFlashMode == FlashMode.off
                                  ? Colors.amber
                                  : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _currentFlashMode = FlashMode.auto;
                              });
                              await controller!.setFlashMode(
                                FlashMode.auto,
                              );
                            },
                            child: Icon(
                              Icons.flash_auto,
                              color: _currentFlashMode == FlashMode.auto
                                  ? Colors.amber
                                  : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _currentFlashMode = FlashMode.always;
                              });
                              await controller!.setFlashMode(
                                FlashMode.always,
                              );
                            },
                            child: Icon(
                              Icons.flash_on,
                              color: _currentFlashMode == FlashMode.always
                                  ? Colors.amber
                                  : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _currentFlashMode = FlashMode.torch;
                              });
                              await controller!.setFlashMode(
                                FlashMode.torch,
                              );
                            },
                            child: Icon(
                              Icons.highlight,
                              color: _currentFlashMode == FlashMode.torch
                                  ? Colors.amber
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
            : const Center(
          child: Text(
            'LOADING',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

Widget cameraOverlay({double? padding, double? aspectRatio, Color?color}) {
  return LayoutBuilder(builder: (context, constraints) {
    double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
    double horizontalPadding;
    double verticalPadding;

    if (parentAspectRatio < (aspectRatio as double)) {
      horizontalPadding = (padding as double);
      verticalPadding = (constraints.maxHeight -
          ((constraints.maxWidth - 2 * (padding)) / (aspectRatio))) /
          2;
    } else {
      verticalPadding = padding as double;
      horizontalPadding = (constraints.maxWidth -
          ((constraints.maxHeight - 2 * (padding)) * (aspectRatio))) /
          2;
    }
    return Stack(fit: StackFit.expand, children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Container(width: horizontalPadding, color: color)),
      Align(
          alignment: Alignment.centerRight,
          child: Container(width: horizontalPadding, color: color)),
      Align(
          alignment: Alignment.topCenter,
          child: Container(
              margin: EdgeInsets.only(
                  left: horizontalPadding, right: horizontalPadding),
              height: verticalPadding,
              color: color)),
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(
                  left: horizontalPadding, right: horizontalPadding),
              height: verticalPadding,
              color: color)),
      Container(
        margin: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
      )
    ]);
  });
}