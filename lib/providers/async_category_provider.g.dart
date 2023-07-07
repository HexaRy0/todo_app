// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$asyncCategoryHash() => r'e3243180698b9c57049a53ed468764f3c8fb1541';

/// See also [AsyncCategory].
@ProviderFor(AsyncCategory)
final asyncCategoryProvider = AutoDisposeAsyncNotifierProvider<AsyncCategory,
    List<CategoryData>>.internal(
  AsyncCategory.new,
  name: r'asyncCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$asyncCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AsyncCategory = AutoDisposeAsyncNotifier<List<CategoryData>>;
String _$selectedCategoryHash() => r'78885ca4e36859e6229a71e13af51c24e66778c8';

/// See also [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, CategoryData?>.internal(
  SelectedCategory.new,
  name: r'selectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategory = AutoDisposeNotifier<CategoryData?>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
