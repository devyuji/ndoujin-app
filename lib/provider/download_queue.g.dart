// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_queue.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$downloadQueueHash() => r'51c6016d0bcd13e216e8cdc5cf928a757b4e247a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [downloadQueue].
@ProviderFor(downloadQueue)
const downloadQueueProvider = DownloadQueueFamily();

/// See also [downloadQueue].
class DownloadQueueFamily extends Family<AsyncValue<void>> {
  /// See also [downloadQueue].
  const DownloadQueueFamily();

  /// See also [downloadQueue].
  DownloadQueueProvider call({
    required String url,
    required String userAgent,
  }) {
    return DownloadQueueProvider(
      url: url,
      userAgent: userAgent,
    );
  }

  @override
  DownloadQueueProvider getProviderOverride(
    covariant DownloadQueueProvider provider,
  ) {
    return call(
      url: provider.url,
      userAgent: provider.userAgent,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'downloadQueueProvider';
}

/// See also [downloadQueue].
class DownloadQueueProvider extends AutoDisposeFutureProvider<void> {
  /// See also [downloadQueue].
  DownloadQueueProvider({
    required String url,
    required String userAgent,
  }) : this._internal(
          (ref) => downloadQueue(
            ref as DownloadQueueRef,
            url: url,
            userAgent: userAgent,
          ),
          from: downloadQueueProvider,
          name: r'downloadQueueProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$downloadQueueHash,
          dependencies: DownloadQueueFamily._dependencies,
          allTransitiveDependencies:
              DownloadQueueFamily._allTransitiveDependencies,
          url: url,
          userAgent: userAgent,
        );

  DownloadQueueProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
    required this.userAgent,
  }) : super.internal();

  final String url;
  final String userAgent;

  @override
  Override overrideWith(
    FutureOr<void> Function(DownloadQueueRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DownloadQueueProvider._internal(
        (ref) => create(ref as DownloadQueueRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
        userAgent: userAgent,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DownloadQueueProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadQueueProvider &&
        other.url == url &&
        other.userAgent == userAgent;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, userAgent.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DownloadQueueRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `url` of this provider.
  String get url;

  /// The parameter `userAgent` of this provider.
  String get userAgent;
}

class _DownloadQueueProviderElement
    extends AutoDisposeFutureProviderElement<void> with DownloadQueueRef {
  _DownloadQueueProviderElement(super.provider);

  @override
  String get url => (origin as DownloadQueueProvider).url;
  @override
  String get userAgent => (origin as DownloadQueueProvider).userAgent;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
