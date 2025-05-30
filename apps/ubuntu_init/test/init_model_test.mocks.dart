// Mocks generated by Mockito 5.4.4 from annotations
// in ubuntu_init/test/init_model_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:args/src/arg_results.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:ubuntu_init/services/provd_gdm_service.dart' as _i5;
import 'package:ubuntu_provision/services.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeIdentity_0 extends _i1.SmartFake implements _i2.Identity {
  _FakeIdentity_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ArgResults].
///
/// See the documentation for Mockito's code generation for more information.
class MockArgResults extends _i1.Mock implements _i3.ArgResults {
  MockArgResults() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<String> get rest => (super.noSuchMethod(
        Invocation.getter(#rest),
        returnValue: <String>[],
      ) as List<String>);

  @override
  List<String> get arguments => (super.noSuchMethod(
        Invocation.getter(#arguments),
        returnValue: <String>[],
      ) as List<String>);

  @override
  Iterable<String> get options => (super.noSuchMethod(
        Invocation.getter(#options),
        returnValue: <String>[],
      ) as Iterable<String>);

  @override
  dynamic operator [](String? name) => super.noSuchMethod(Invocation.method(
        #[],
        [name],
      ));

  @override
  bool flag(String? name) => (super.noSuchMethod(
        Invocation.method(
          #flag,
          [name],
        ),
        returnValue: false,
      ) as bool);

  @override
  String? option(String? name) => (super.noSuchMethod(Invocation.method(
        #option,
        [name],
      )) as String?);

  @override
  List<String> multiOption(String? name) => (super.noSuchMethod(
        Invocation.method(
          #multiOption,
          [name],
        ),
        returnValue: <String>[],
      ) as List<String>);

  @override
  bool wasParsed(String? name) => (super.noSuchMethod(
        Invocation.method(
          #wasParsed,
          [name],
        ),
        returnValue: false,
      ) as bool);
}

/// A class which mocks [PageConfigService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPageConfigService extends _i1.Mock implements _i2.PageConfigService {
  MockPageConfigService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, _i2.PageConfigEntry> get pages => (super.noSuchMethod(
        Invocation.getter(#pages),
        returnValue: <String, _i2.PageConfigEntry>{},
      ) as Map<String, _i2.PageConfigEntry>);

  @override
  bool get includeTryOrInstall => (super.noSuchMethod(
        Invocation.getter(#includeTryOrInstall),
        returnValue: false,
      ) as bool);

  @override
  Iterable<String> get allowedToHide => (super.noSuchMethod(
        Invocation.getter(#allowedToHide),
        returnValue: <String>[],
      ) as Iterable<String>);

  @override
  _i2.ProvisioningMode get mode => (super.noSuchMethod(
        Invocation.getter(#mode),
        returnValue: _i2.ProvisioningMode.standard,
      ) as _i2.ProvisioningMode);

  @override
  set mode(_i2.ProvisioningMode? _mode) => super.noSuchMethod(
        Invocation.setter(
          #mode,
          _mode,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get isOem => (super.noSuchMethod(
        Invocation.getter(#isOem),
        returnValue: false,
      ) as bool);

  @override
  _i4.Future<void> load() => (super.noSuchMethod(
        Invocation.method(
          #load,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [IdentityService].
///
/// See the documentation for Mockito's code generation for more information.
class MockIdentityService extends _i1.Mock implements _i2.IdentityService {
  MockIdentityService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Identity> getIdentity() => (super.noSuchMethod(
        Invocation.method(
          #getIdentity,
          [],
        ),
        returnValue: _i4.Future<_i2.Identity>.value(_FakeIdentity_0(
          this,
          Invocation.method(
            #getIdentity,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Identity>);

  @override
  _i4.Future<void> setIdentity(_i2.Identity? identity) => (super.noSuchMethod(
        Invocation.method(
          #setIdentity,
          [identity],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i2.UsernameValidation> validateUsername(String? username) =>
      (super.noSuchMethod(
        Invocation.method(
          #validateUsername,
          [username],
        ),
        returnValue:
            _i4.Future<_i2.UsernameValidation>.value(_i2.UsernameValidation.OK),
      ) as _i4.Future<_i2.UsernameValidation>);
}

/// A class which mocks [GdmService].
///
/// See the documentation for Mockito's code generation for more information.
class MockGdmService extends _i1.Mock implements _i5.GdmService {
  MockGdmService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> launchSession(
    String? username,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #launchSession,
          [
            username,
            password,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
