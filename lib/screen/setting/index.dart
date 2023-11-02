import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ndoujin/screen/setting/check_for_update.dart';
import "package:ndoujin/constraint.dart";
import 'package:ndoujin/widgets/gap.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  int _autoSlideSpeed = 3;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      _autoSlideSpeed = pref.getInt("autoSlideSpeedTime") ?? 3;
    });
  }

  Future<void> _changeAutoSlideSpeed() async {
    _formKey.currentState!.save();

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("autoSlideSpeedTime", _autoSlideSpeed);
    setState(() {});

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Setting"),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Change Auto Slide Speed"),
                        content: Form(
                          key: _formKey,
                          child: TextFormField(
                            initialValue: _autoSlideSpeed.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            autofocus: true,
                            onSaved: (newValue) =>
                                _autoSlideSpeed = int.parse(newValue ?? "3"),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: _changeAutoSlideSpeed,
                            child: const Text("Change"),
                          ),
                        ],
                      ),
                    );
                  },
                  title: const Text(
                    "Auto Slide Speed",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text("$_autoSlideSpeed Seconds"),
                ),
                const Gap(),
                ListTile(
                  onTap: () async {
                    await launchUrl(Uri.parse(
                        "https://github.com/devyuji/ndoujin-app/issues"));
                  },
                  trailing: const Icon(Icons.bug_report_outlined),
                  title: const Text(
                    "Report a bug!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckForUpdateScreen(),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.update_outlined),
                  title: const Text(
                    "Check for update",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text("v$appVersion"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
