Week 3: Flutter Basics - Learning Log

Focus: Moving from Dart logic to building visual mobile apps.

1. Flutter Fundamentals

The Entry Point (main.dart)

Key Function: runApp(Widget)

Purpose: Inflates the given widget and attaches it to the screen.

Code:

void main() {
  runApp(MyApp());
}


The Widget Tree

Concept: Everything in Flutter is a Widget.

Structure:

MaterialApp (Root/Style Wrapper)

Scaffold (Page Skeleton: AppBar, Body, FAB)

Column/Row (Layout Managers)

Text/Icon (Leaf Nodes)

2. Types of Widgets

Stateless Widgets

Definition: Immutable. They are built once and never change.

Use Case: Static content like labels, icons, or strict layout structures.

Key Method: build(BuildContext context)

Example:

class MyLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("I never change");
  }
}


Stateful Widgets

Definition: Mutable. They can change (rebuild) during the app's lifecycle.

Structure: Split into two classes:

StatefulWidget (The immutable configuration).

State (The logic and mutable variables).

Key Method: setState(() { ... }) — Triggers a rebuild.

Example:

// 1. The Widget
class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

// 2. The State
class _CounterState extends State<Counter> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() { count++; }),
      child: Text("Count: $count"),
    );
  }
}


3. Layout Basics

Column (Vertical)

Direction: Top to Bottom.

Properties:

children: A list of widgets [].

crossAxisAlignment: Aligns items horizontally (e.g., Left/Start).

Issue: Does not scroll. Causes overflow errors if too long.

ListView (Scrollable)

Direction: Vertical (by default).

Usage: Drop-in replacement for Column when content might exceed screen height.

Code:

ListView(
  children: [
    Text("Item 1"),
    Text("Item 2"),
    // ...
  ],
)


Padding

Purpose: Adds breathing room around a widget.

Usage:

Padding(
  padding: EdgeInsets.all(8.0),
  child: Text("I have space!"),
)


4. Advanced Concepts (To Do)

BuildContext

Definition: A handle to the location of a widget in the Widget Tree.

Usage: Used to look up data from parents (e.g., Theme, Navigation).

Example: Theme.of(context).primaryColor

Complex Layouts

Row: Horizontal alignment (Left to Right).

Stack: Z-axis alignment (Layers on top of each other).

GridView: 2D array of widgets (like a photo gallery).