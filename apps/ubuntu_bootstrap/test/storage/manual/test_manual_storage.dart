import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:ubuntu_bootstrap/pages/storage/manual/manual_storage_model.dart';

import 'test_manual_storage.mocks.dart';
export '../../test_utils.dart';
export 'test_manual_storage.mocks.dart';

@GenerateMocks([ManualStorageModel])
ManualStorageModel buildManualStorageModel({
  bool? isValid,
  List<Disk>? disks,
  Gap? selectedGap,
  Disk? selectedDisk,
  int? selectedDiskIndex,
  Partition? selectedPartition,
  int? selectedObjectIndex,
  bool? canAddPartition,
  bool? canRemovePartition,
  bool? canEditPartition,
  bool? canReformatDisk,
  int? bootDiskIndex,
  bool? waitingForReply,
}) {
  final model = MockManualStorageModel();
  when(model.isValid).thenReturn(isValid ?? false);
  when(model.disks).thenReturn(disks ?? <Disk>[]);
  when(model.originalConfig(any)).thenAnswer((i) {
    return disks
        ?.expand((d) => d.partitions.whereType<Partition>())
        .firstWhereOrNull((p) => p.path == i.positionalArguments[0].path);
  });

  when(model.selectedGap).thenReturn(selectedGap);
  when(model.selectedDisk).thenReturn(selectedDisk);
  when(model.selectedDiskIndex).thenReturn(selectedDiskIndex ?? 0);
  when(model.selectedPartition).thenReturn(selectedPartition);
  when(model.selectedObjectIndex).thenReturn(selectedObjectIndex ?? 0);
  when(model.selectionChangedNotifier).thenAnswer((_) => ChangeNotifier());
  when(model.isStorageSelected(any, any)).thenReturn(false);
  when(model.canSelectStorage(any, any)).thenReturn(true);

  when(model.canAddPartition).thenReturn(canAddPartition ?? false);
  when(model.canRemovePartition).thenReturn(canRemovePartition ?? false);
  when(model.canEditPartition).thenReturn(canEditPartition ?? false);
  when(model.canReformatDisk).thenReturn(canReformatDisk ?? false);

  when(model.bootDiskIndex).thenReturn(bootDiskIndex);
  when(model.waitingForReply).thenReturn(waitingForReply ?? false);
  return model;
}
