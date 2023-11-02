class VersionComparision {
  static bool isVersionGreaterThan(String newVersion, String currentVersion) {
    List<String> currentV = currentVersion.split('.');
    List<String> newV = newVersion.split('.');

    for (var i = 0; i < currentV.length; i++) {
      if (int.parse(newV[i]) > int.parse(currentV[i])) {
        return true;
      } else if (int.parse(newV[i]) < int.parse(currentV[i])) {
        return false;
      }
    }

    return false;
  }
}
