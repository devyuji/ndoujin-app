class AppUpdate {
  const AppUpdate({
    this.body = "",
    this.newVersion = false,
    this.versionName = "",
    this.downloadUrl = "",
  });

  final bool newVersion;
  final String versionName;
  final String body;
  final String downloadUrl;
}
