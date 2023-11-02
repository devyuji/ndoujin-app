// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_download_file.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readFileHash() => r'7e91351bb3fea66baeb339c57da984524f82a5ed';

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

/// See also [readFile].
@ProviderFor(readFile)
const readFileProvider = ReadFileFamily();

/// See also [readFile].
class ReadFileFamily extends Family<AsyncValue<List<Uint8List>>> {
  /// See also [readFile].
  const ReadFileFamily();

  /// See also [readFile].
  ReadFileProvider call({
    required String path,
  }) {
    return ReadFileProvider(
      path: path,
    );
  }

  @override
  ReadFileProvider getProviderOverride(
    covariant ReadFileProvider provider,
  ) {
    return call(
      path: provider.path,
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
  String? get name => r'readFileProvider';
}

/// See also [readFile].
class ReadFileProvider extends AutoDisposeFutureProvider<List<Uint8List>> {
  /// See also [readFile].
  ReadFileProvider({
    required String path,
  }) : this._internal(
          (ref) => readFile(
            ref as ReadFileRef,
            path: path,
          ),
          from: readFileProvider,
          name: r'readFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$readFileHash,
          dependencies: ReadFileFamily._dependencies,
          allTransitiveDependencies: ReadFileFamily._allTransitiveDependencies,
          path: path,
        );

  ReadFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String path;

  @override
  Override overrideWith(
    FutureOr<List<Uint8List>> Function(ReadFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadFileProvider._internal(
        (ref) => create(ref as ReadFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Uint8List>> createElement() {
    return _ReadFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadFileProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReadFileRef on AutoDisposeFutureProviderRef<List<Uint8List>> {
  /// The parameter `path` of this provider.
  String get path;
}

class _ReadFileProviderElement
    extends AutoDisposeFutureProviderElement<List<Uint8List>> with ReadFileRef {
  _ReadFileProviderElement(super.provider);

  @override
  String get path => (origin as ReadFileProvider).path;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
