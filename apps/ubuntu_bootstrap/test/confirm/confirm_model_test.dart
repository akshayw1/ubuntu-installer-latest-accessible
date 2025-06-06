import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:subiquity_test/subiquity_test.dart';
import 'package:ubuntu_bootstrap/pages/confirm/confirm_model.dart';

import 'test_confirm.dart';

void main() {
  final testDisks = <Disk>[
    fakeDisk(
      path: '/dev/sda',
      partitions: [const Partition(number: 1, preserve: false)],
    ),
    fakeDisk(
      path: '/dev/sdb',
      preserve: true,
      partitions: [
        const Partition(number: 1),
        const Partition(number: 2, preserve: false),
      ],
    ),
    fakeDisk(
      path: '/dev/sdc',
      partitions: [
        const Partition(number: 3, preserve: false),
        const Partition(number: 4, grubDevice: false),
      ],
    ),
    fakeDisk(
      path: '/dev/sdd',
      preserve: true,
      partitions: [
        const Partition(number: 1, preserve: true),
        const Partition(number: 2, mount: '/mnt'),
        const Partition(number: 3, wipe: 'superblock'),
        const Partition(number: 4, resize: true),
      ],
    ),
    fakeDisk(
      path: '/dev/sde',
      preserve: true,
      partitions: [
        const Partition(number: 1, preserve: true),
      ],
    ),
  ];

  final modifiedDisks = testDisks.sublist(0, 4);

  test('get storage', () async {
    final installer = MockInstallerService();
    final storage = MockStorageService();
    final network = MockNetworkService();
    final product = MockProductService();
    final session = MockSessionService();
    when(storage.guidedTarget).thenReturn(null);
    when(storage.getStorage()).thenAnswer((_) async => testDisks);
    when(storage.getOriginalStorage()).thenAnswer((_) async => testDisks);
    when(storage.hasBitLocker()).thenAnswer((_) async => false);

    final model = ConfirmModel(installer, storage, network, product, session);
    await model.init();
    verifyInOrder([
      storage.getStorage(),
      storage.getOriginalStorage(),
    ]);
    verifyNever(storage.setGuidedStorage());

    expect(model.disks, equals(testDisks));
    expect(model.modifiedDisks, equals(modifiedDisks));
    expect(
      model.partitions,
      equals({
        'sda': [const Partition(number: 1, preserve: false)],
        'sdb': [
          const Partition(number: 1),
          const Partition(number: 2, preserve: false),
        ],
        'sdc': [
          const Partition(number: 3, preserve: false),
          const Partition(number: 4, grubDevice: false),
        ],
        'sdd': [
          const Partition(number: 1, preserve: true),
          const Partition(number: 2, mount: '/mnt'),
          const Partition(number: 3, wipe: 'superblock'),
          const Partition(number: 4, resize: true),
        ],
        'sde': [
          const Partition(number: 1, preserve: true),
        ],
      }),
    );
    expect(
      model.getOriginalPartition('sdd', 3),
      const Partition(number: 3, wipe: 'superblock'),
    );
  });

  test('set guided storage', () async {
    const target = GuidedStorageTarget.reformat(diskId: 'sda');

    final installer = MockInstallerService();
    final storage = MockStorageService();
    final network = MockNetworkService();
    final product = MockProductService();
    final session = MockSessionService();
    when(storage.guidedTarget).thenReturn(target);
    when(storage.getStorage()).thenAnswer((_) async => testDisks);
    when(storage.getOriginalStorage()).thenAnswer((_) async => testDisks);
    when(storage.setGuidedStorage())
        .thenAnswer((_) async => fakeGuidedStorageResponse());
    when(storage.hasBitLocker()).thenAnswer((_) async => false);

    final model = ConfirmModel(installer, storage, network, product, session);
    await model.init();
    verify(storage.setGuidedStorage()).called(1);
  });

  test('start installation', () async {
    final installer = MockInstallerService();
    final storage = MockStorageService();
    final network = MockNetworkService();
    final product = MockProductService();
    final session = MockSessionService();
    when(storage.guidedTarget).thenReturn(null);
    when(storage.getStorage()).thenAnswer((_) async => testDisks);
    when(storage.getOriginalStorage()).thenAnswer((_) async => testDisks);
    when(storage.setStorage()).thenAnswer((_) async => testDisks);
    when(storage.hasBitLocker()).thenAnswer((_) async => false);

    final model = ConfirmModel(installer, storage, network, product, session);
    await model.init();
    await model.startInstallation();

    verifyNever(storage.setStorage());
    verify(storage.passphrase = null).called(1);
    verify(installer.start()).called(1);
  });

  test('mark network configured', () async {
    final installer = MockInstallerService();
    final storage = MockStorageService();
    final network = MockNetworkService();
    final product = MockProductService();
    final session = MockSessionService();
    when(storage.guidedTarget).thenReturn(null);
    when(storage.getStorage()).thenAnswer((_) async => testDisks);
    when(storage.getOriginalStorage()).thenAnswer((_) async => testDisks);
    when(storage.setStorage()).thenAnswer((_) async => testDisks);
    when(storage.hasBitLocker()).thenAnswer((_) async => false);

    final model = ConfirmModel(installer, storage, network, product, session);
    await model.init();
    await model.markNetworkConfigured();

    verify(network.markConfigured()).called(1);
  });
}
