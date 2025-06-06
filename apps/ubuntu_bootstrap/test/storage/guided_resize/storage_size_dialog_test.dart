import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuntu_bootstrap/pages/storage/guided_resize/storage_size_dialog.dart';
import 'package:ubuntu_bootstrap/widgets/storage_size_box.dart';
import 'package:ubuntu_test/ubuntu_test.dart';
import 'package:ubuntu_utils/ubuntu_utils.dart';
import 'package:ubuntu_widgets/ubuntu_widgets.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('resize storage', (tester) async {
    await tester.pumpApp((_) => const Scaffold());

    final result = showStorageSizeDialog(
      tester.element(find.byType(Scaffold)),
      title: 'Test title',
      name: 'Test storage',
      path: '/dev/sda1',
      initialSize: toBytes(100, DataUnit.megabytes),
      minimumSize: toBytes(50, DataUnit.megabytes),
      maximumSize: toBytes(200, DataUnit.megabytes),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test title'), findsOneWidget);
    expect(find.text('/dev/sda1 (Test storage)'), findsOneWidget);
    expect(find.text('50-200 MB'), findsOneWidget);

    expect(find.byType(StorageSizeBox), findsOneWidget);
    expect(find.byType(EditableText), findsOneWidget);

    await tester.enterText(find.byType(StorageSizeBox), '150');
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(await result, toBytes(150, DataUnit.megabytes));
  });

  testWidgets('change unit', (tester) async {
    await tester.pumpWidget(tester.buildApp((_) => const Scaffold()));

    final result = showStorageSizeDialog(
      tester.element(find.byType(Scaffold)),
      title: 'Test title',
      name: 'Test storage',
      initialSize: toBytes(50, DataUnit.gigabytes),
      minimumSize: toBytes(20, DataUnit.gigabytes),
      maximumSize: toBytes(100, DataUnit.gigabytes),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(StorageSizeDialog));

    for (final unit in DataUnit.values) {
      final menuButton = find.byType(MenuButtonBuilder<DataUnit>);
      expect(menuButton, findsOneWidget);
      await tester.pumpAndSettle();
      await tester.ensureVisible(menuButton);
      await tester.pumpAndSettle();
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      final dropDownUnit = find.byKey(ValueKey(unit)).last;
      await tester.ensureVisible(dropDownUnit);
      await tester.pumpAndSettle();
      expect(dropDownUnit, findsOneWidget);
      await tester.tap(dropDownUnit);
      await tester.pumpAndSettle();

      final min = fromBytes(toBytes(20, DataUnit.gigabytes), unit).round();
      final max = fromBytes(toBytes(100, DataUnit.gigabytes), unit).round();
      expect(find.text('$min-$max ${unit.l10n(context)}'), findsOneWidget);
    }

    await tester.tapOk();
    await tester.pumpAndSettle();

    expect(await result, toBytes(50, DataUnit.gigabytes));
  });

  testWidgets('cancel', (tester) async {
    await tester.pumpApp((_) => const Scaffold());

    final result = showStorageSizeDialog(
      tester.element(find.byType(Scaffold)),
      title: 'Test title',
      name: 'Test storage',
      initialSize: toBytes(50, DataUnit.gigabytes),
      minimumSize: toBytes(20, DataUnit.gigabytes),
      maximumSize: toBytes(100, DataUnit.gigabytes),
    );
    await tester.pumpAndSettle();

    await tester.tapCancel();
    await tester.pumpAndSettle();

    expect(await result, isNull);
  });

  testWidgets('respect minimum size', (tester) async {
    await tester.pumpApp((_) => const Scaffold());

    final result = showStorageSizeDialog(
      tester.element(find.byType(Scaffold)),
      title: 'Test title',
      name: 'Test storage',
      path: '/dev/sda1',
      initialSize: toBytes(100, DataUnit.megabytes),
      minimumSize: toBytes(50, DataUnit.megabytes),
      maximumSize: toBytes(200, DataUnit.megabytes),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test title'), findsOneWidget);
    expect(find.text('/dev/sda1 (Test storage)'), findsOneWidget);
    expect(find.text('50-200 MB'), findsOneWidget);

    expect(find.byType(StorageSizeBox), findsOneWidget);
    expect(find.byType(EditableText), findsOneWidget);

    await tester.enterText(find.byType(StorageSizeBox), '10');
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(await result, toBytes(50, DataUnit.megabytes));
  });
}
