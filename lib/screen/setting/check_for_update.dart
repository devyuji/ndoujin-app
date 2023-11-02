import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:ndoujin/constraint.dart';

import 'package:ndoujin/provider/check_for_update.dart';
import 'package:ndoujin/widgets/gap.dart';
import 'package:path_provider/path_provider.dart';

class CheckForUpdateScreen extends ConsumerStatefulWidget {
  const CheckForUpdateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CheckForUpdateScreenState();
}

class _CheckForUpdateScreenState extends ConsumerState<CheckForUpdateScreen> {
  final CancelToken _cancelToken = CancelToken();
  String _downloadProgress = "Update";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();

    super.dispose();
  }

  Future<void> _downloadAPK(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final downloadPath = "${tempDir.path}/ndoujin.apk";

      await Dio().downloadUri(
        Uri.parse(url),
        downloadPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total <= 0) {
            return;
          }
          setState(() {
            _downloadProgress =
                "${(received / total * 100).toStringAsFixed(0)}%";
          });
        },
      );

      // install apk
      await InstallPlugin.install(downloadPath);
    } catch (err) {
      debugPrint("$err");
    }
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(checkForUpdateProvider);

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(checkForUpdateProvider.future),
          child: CustomScrollView(
            slivers: [
              const SliverAppBar.large(
                title: Text("Check For Update"),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kDefaultPadding),
                sliver: SliverToBoxAdapter(
                  child: response.when(
                    data: (data) {
                      return Column(
                        children: [
                          const Icon(Icons.auto_awesome_outlined),
                          const Gap(),
                          Text(
                            data.versionName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Gap(),
                          Text(data.body),
                          if (data.newVersion)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _downloadAPK(data.downloadUrl),
                                child: Text(
                                  _downloadProgress,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                    error: (err, _) =>
                        const Text("ERROR!! unable to check for new update."),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
