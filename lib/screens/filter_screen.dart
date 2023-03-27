import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:deepar/modal/lenses.dart';
import 'package:deepar/screens/image_preview_screen.dart';
import 'package:deepar/widgets/icon_action_btn.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';

import '../services/file_downloader_service.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  CarouselController carouselController = CarouselController();
  bool isInitialized = false;
  int isCurrentIndexLoading = -1;
  final List<Lenses> lstOfLenses = [
    Lenses(
        previewImageUrl: 'devil.png',
        deepARAssetFile:
            'https://firebasestorage.googleapis.com/v0/b/dreamkasper-website.appspot.com/o/Neon_Devil_Horns.deepar?alt=media&token=a4f8ae37-7b43-4dce-9709-bc580d4814a9'),
    Lenses(
        previewImageUrl: 'elephant-trunk.png',
        deepARAssetFile:
            'https://firebasestorage.googleapis.com/v0/b/dreamkasper-website.appspot.com/o/Elephant_Trunk.deepar?alt=media&token=95490200-9277-409c-807c-c0b4632aff92'),
    Lenses(
        previewImageUrl: 'fire.png',
        deepARAssetFile:
            'https://firebasestorage.googleapis.com/v0/b/dreamkasper-website.appspot.com/o/burning_effect.deepar?alt=media&token=0df3910c-83c5-4660-a759-e4338645bb21')
  ];
  int currentIndex = 0;
  final DeepArController _controller = DeepArController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.destroy();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller
        .initialize(
            androidLicenseKey:
                '94e59601267ad4022700f8ad365af6c4180994dbec71ad5e02fc5d34140d5348e6638b58dbc239ce',
            iosLicenseKey: '')
        .then((value) {
      isInitialized = true;
      setState(() {});
    });
  }

  Future<void> switchEffect(String fileUrl) async {
    //  isInitialized = false;
    // setState(() {});
    File? deepARFile = await FileDownloaderService.downloadedFile(
      url: fileUrl,
      preferredExtension: '.deepar',
    );
    //  isInitialized = true;
    // setState(() {});
    _controller.switchEffectWithSlot(slot: 'mask', path: deepARFile.path);
  }

  @override
  Widget build(BuildContext context) {
    double itemSize = 70;
    return Scaffold(
      body: Stack(children: [
        Container(
          child: _controller.isInitialized && isInitialized
              ? isCurrentIndexLoading == currentIndex
                  ? const Center(child: CircularProgressIndicator())
                  : DeepArPreview(
                      _controller,
                      onViewCreated: () async {
                        await switchEffect(
                            lstOfLenses[currentIndex].deepARAssetFile);
                      },
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        Positioned(
            left: 20,
            top: 40,
            child: IconActionButton(
              icon: Icon(Icons.flip_camera_android),
              onTap: () {
                _controller.flipCamera();
              },
            )),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Stack(
            children: [
              SizedBox(
                height: itemSize + 50,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SizedBox.expand(),
                ),
              ),
              Container(
                height: itemSize - 18,
                color: Colors.transparent,
                margin: const EdgeInsets.all(13),
                child: Center(
                  child: CarouselSlider(
                    carouselController: carouselController,
                    items: [
                      ...lstOfLenses.map((e) => GestureDetector(
                            onTap: () async {
                              if (!isInitialized) {
                                return;
                              }
                              isCurrentIndexLoading = currentIndex;
                              currentIndex = lstOfLenses.indexOf(e);
                              carouselController.jumpToPage(currentIndex);
                              await switchEffect(
                                  lstOfLenses[currentIndex].deepARAssetFile);
                              isCurrentIndexLoading = -1;
                              setState(() {});
                            },
                            child: SizedBox(
                              child: e.previewImageUrl.isEmpty
                                  ? Container(
                                      width: itemSize - 18,
                                      height: itemSize - 18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                    )
                                  : SizedBox(
                                      width: itemSize - 18,
                                      height: itemSize - 18,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.asset(
                                              'assets/images/${e.previewImageUrl}')),
                                    ),
                            ),
                          ))
                    ],
                    options: CarouselOptions(
                      height: 200,
                      initialPage: currentIndex,
                      scrollPhysics: const PageScrollPhysics(),
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {},
                      viewportFraction: 2.2 / 10,
                    ),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails drag) {},
                  onTap: () async {
                    //
                    final File file = await _controller.takeScreenshot();
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImagePreview(
                                file: file,
                              )),
                    );
                  },
                  child: SizedBox(
                    width: itemSize + 5,
                    height: itemSize + 5,
                    child: CircularProgressIndicator(
                      value: !isInitialized ? null : 1,
                      color: !isInitialized
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
