import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ndoujin/constraint.dart';
import 'package:ndoujin/provider/read_download_file.dart';
import 'package:ndoujin/utils/show_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class ReadFileScreen extends ConsumerStatefulWidget {
  const ReadFileScreen({super.key, required this.path});

  final String path;

  @override
  ConsumerState createState() => _ReadFileScreenState();
}

class _ReadFileScreenState extends ConsumerState<ReadFileScreen> {
  late PageController _pageController;
  late TransformationController _transformationController;

  bool _pageScrolling = true;

  bool _showAppbar = false;
  int _currentPage = 0;
  int _totalPage = 1;

  Timer? _autoSlideTimer;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
    _transformationController = TransformationController();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();

        if (_currentPage == (_totalPage - 1)) {
          if (_autoSlideTimer != null) {
            _autoSlideTimer!.cancel();
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
    _transformationController.dispose();

    if (_autoSlideTimer != null) {
      _autoSlideTimer!.cancel();
    }

    super.dispose();
  }

  void _toggleMenu() {
    if (_autoSlideTimer != null) {
      if (_autoSlideTimer!.isActive) {
        _autoSlideTimer!.cancel();
        Wakelock.disable();
        ShowToast.show("Auto Slide Stopped!");
      }
    }

    setState(() {
      _showAppbar = !_showAppbar;
    });
  }

  Future<void> _handleClick(String value) async {
    switch (value) {
      case "Auto Slide":
        ShowToast.show("Auto slide started!");

        setState(() {
          _showAppbar = false;
        });

        final pref = await SharedPreferences.getInstance();

        final autoSlideSpeedTime = pref.getInt("autoSlideSpeedTime") ?? 3;

        _autoSlideTimer =
            Timer.periodic(Duration(seconds: autoSlideSpeedTime), (timer) {
          _pageController.animateToPage(
            _currentPage + 1,
            duration: const Duration(milliseconds: 550),
            curve: Curves.linear,
          );
        });
        Wakelock.enable();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(readFileProvider(path: widget.path));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: data.when(
              data: (d) {
                setState(() {
                  _totalPage = d.length;
                });

                return GestureDetector(
                  onTap: _toggleMenu,
                  child: PageView.builder(
                    physics: _pageScrolling
                        ? const PageScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    pageSnapping: true,
                    itemCount: d.length,
                    itemBuilder: (context, index) => InteractiveViewer(
                      transformationController: _transformationController,
                      panAxis: PanAxis.aligned,
                      onInteractionEnd: (details) {
                        final scale =
                            _transformationController.value.getMaxScaleOnAxis();
                        setState(() {
                          _pageScrolling = scale <= 1.0;
                        });
                      },
                      child: Image.memory(
                        d[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
              error: (error, _) => const Text("Unable to open this file"),
              loading: () => const CircularProgressIndicator(),
            ),
          ),
          // top bar appbar
          AnimatedPositioned(
            top: _showAppbar ? 0 : -size.height * 0.5,
            right: 0,
            left: 0,
            duration: const Duration(milliseconds: 550),
            child: _showAppbar
                ? AppBar(
                    actions: [
                      PopupMenuButton<String>(
                        onSelected: _handleClick,
                        itemBuilder: (BuildContext context) {
                          return {
                            "Auto Slide",
                          }.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  )
                : const SizedBox(),
          ),

          // Numeric page indicator
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Text("${_currentPage + 1}/$_totalPage"),
            ),
          ),

          // bottom menu option
          AnimatedPositioned(
            bottom: _showAppbar ? 10 : -size.height * 0.5,
            right: 10,
            left: 10,
            duration: const Duration(milliseconds: 550),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultPadding),
                color: Theme.of(context)
                    .appBarTheme
                    .backgroundColor!
                    .withOpacity(0.7),
              ),
              child: Row(
                children: [
                  Text(
                    "${_currentPage + 1}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Slider(
                      value: _currentPage.toDouble(),
                      onChanged: (value) {
                        _pageController.animateToPage(
                          value.floor(),
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.linear,
                        );
                      },
                      max: _totalPage.toDouble() - 1,
                      divisions: _totalPage == 1 ? 1 : _totalPage - 1,
                    ),
                  ),
                  Text("$_totalPage", style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
