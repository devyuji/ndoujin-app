import 'package:flutter/material.dart';
import "package:flutter/services.dart";

import 'package:ndoujin/constraint.dart';
import 'package:ndoujin/screen/browser.dart';
import 'package:ndoujin/widgets/gap.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  late final TextEditingController _textController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _textController = TextEditingController();

    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pasteClipboardToTextField() async {
    final value = await Clipboard.getData("text/plain");
    _textController.text = value!.text ?? "";
  }

  void _read() {
    if (!_formKey.currentState!.validate()) return;

    final value = _textController.text;

    String url = "";
    bool validURL = Uri.parse(_textController.text).isAbsolute;
    bool isNumber = double.tryParse(value) != null;

    if (validURL) {
      url = _textController.text;
    } else if (isNumber) {
      url = 'https://nhentai.net/g/$value/1';
    } else {
      url = 'https://nhentai.net/search/?q=$value';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrowserScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          pinned: true,
          title: Text(
            "ndoujin",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(kDefaultPadding),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter code or paste url",
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                  ),
                ),
                const Gap(),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "input field is empty";
                      }

                      return null;
                    },
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "344982",
                      border: const OutlineInputBorder(),
                      suffixIcon: _textController.text.isEmpty
                          ? IconButton(
                              onPressed: _pasteClipboardToTextField,
                              icon: const Icon(Icons.content_paste_outlined),
                            )
                          : IconButton(
                              onPressed: () {
                                _textController.text = "";
                              },
                              icon: const Icon(Icons.close_outlined),
                            ),
                    ),
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    onFieldSubmitted: (_) => _read(),
                  ),
                ),
                const Gap(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const BrowserScreen(url: "https://nhentai.net"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.web_outlined),
                      label: const Text("Home"),
                    ),
                    const Gap(
                      isHorizontal: true,
                      size: kDefaultPadding / 2,
                    ),
                    TextButton.icon(
                      onPressed: _read,
                      icon: const Icon(Icons.search_outlined),
                      label: const Text("Search"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
