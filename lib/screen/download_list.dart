import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ndoujin/constraint.dart';
import 'package:ndoujin/model/download.dart';
import 'package:ndoujin/provider/download_list.dart';
import 'package:ndoujin/screen/read.dart';
import 'package:ndoujin/utils/show_toast.dart';
import 'package:ndoujin/widgets/gap.dart';

class DownloadScreen extends ConsumerStatefulWidget {
  const DownloadScreen({super.key});

  @override
  ConsumerState<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends ConsumerState<DownloadScreen> {
  bool _showDeveloperLog = false;

  Future<void> _remove(Downloads d) async {
    try {
      await File(d.filePath).delete();
      await File(d.coverImage).delete();
      ref.read(downloadListProvider.notifier).delete(d.id!);
    } catch (err) {
      debugPrint('$err');
      ShowToast.show('unable to delete');
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(downloadListProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Downloads"),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(kDefaultPadding),
            sliver: data.when(
              data: (d) {
                if (d.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text("You haven't download"),
                    ),
                  );
                }
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ReadFileScreen(path: d[index].filePath),
                            ),
                          );
                        },
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  ListTile(
                                    onTap: () => _remove(d[index]),
                                    leading: const Icon(Icons.delete),
                                    title: const Text("Delete"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(d[index].coverImage),
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) return child;
                              return AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(
                                  seconds: 1,
                                ),
                                curve: Curves.easeOut,
                                child: child,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.red.withOpacity(0.5),
                              child: const Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
              error: (error, _) => SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      const Text("Something went wrong! 😔"),
                      const Gap(),
                      TextButton.icon(
                        onPressed: () {},
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
                              child: Text("$error"),
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
      ),
    );
  }
}
