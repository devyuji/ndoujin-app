import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ndoujin/constraint.dart';
import 'package:ndoujin/provider/list_feed.dart';
import 'package:ndoujin/screen/browser.dart';
import 'package:ndoujin/utils/show_toast.dart';
import 'package:ndoujin/widgets/gap.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  bool _showDeveloperLog = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _remove(int id) async {
    ref.read(listFeedProvider.notifier).remove(id);

    Navigator.pop(context);
  }

  Future<void> _copy(String code) async {
    await Clipboard.setData(ClipboardData(text: code));

    ShowToast.show("copied to clipboard!");

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _navigate(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BrowserScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(listFeedProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text("List"),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(kDefaultPadding),
          sliver: data.when(
            data: (d) {
              if (d.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("List is empty"),
                  ),
                );
              }

              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => GestureDetector(
                    onTap: () => _navigate(d[index].source),
                    onLongPress: () => showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              onTap: () => _copy(d[index].code),
                              leading: const Icon(Icons.content_copy_outlined),
                              title: const Text("Copy id"),
                            ),
                            ListTile(
                              onTap: () => _remove(d[index].id!),
                              leading: const Icon(Icons.delete),
                              title: const Text("Delete"),
                            )
                          ],
                        );
                      },
                    ),
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Image.memory(
                              d[index].image,
                              fit: BoxFit.cover,
                              frameBuilder: (context, child, frame,
                                  wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) return child;
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(
                                    milliseconds: 250,
                                  ),
                                  curve: Curves.easeOut,
                                  child: child,
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.6),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Text("#${d[index].code}"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  childCount: d.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 200,
                  crossAxisSpacing: kDefaultPadding / 2,
                  mainAxisSpacing: kDefaultPadding / 2,
                ),
              );
            },
            error: (err, stack) => SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    const Text("Something went wrong! 😔"),
                    const Gap(),
                    TextButton.icon(
                      onPressed: () {
                        ref.refresh(listFeedProvider.future);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                    ),
                    const Gap(),
                    ExpansionPanelList(
                      elevation: 0,
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          _showDeveloperLog = !isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          headerBuilder: (_, __) => const ListTile(
                            title: Text("Developer log"),
                          ),
                          body: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text("$err"),
                          ),
                          isExpanded: _showDeveloperLog,
                          canTapOnHeader: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
