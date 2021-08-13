// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/widgets.dart';


void main() {
  testWidgets('DisposableBuildContext asserts on disposed state', (WidgetTester tester) async {
    final GlobalKey<TestWidgetState> key = GlobalKey<TestWidgetState>();
    await tester.pumpWidget(TestWidget(key));

    final TestWidgetState state = key.currentState;
    expect(state.mounted, true);

    final DisposableBuildContext context = DisposableBuildContext(state);
    expect(context.context, state.context);

    await tester.pumpWidget(const TestWidget(null));

    expect(state.mounted, false);

    expect(() => context.context, throwsAssertionError);

    context.dispose();
    expect(context.context, state.context);

    expect(() => DisposableBuildContext(state), throwsAssertionError);
  });
}

class TestWidget extends StatefulWidget {
  const TestWidget(Key key) : super(key: key);

  @override
  State<TestWidget> createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) => const SizedBox(height: 50);
}
