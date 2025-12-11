 Week 3 Project: User Profile Screen

 

 Overview

In Week 3, we transitioned from pure Dart logic to building visual user interfaces with Flutter. The goal was to master layout composition by constructing a complete User Profile Screen using complex nested widgets.

🛠️ Key Components Built

1. The Header (Identity)

Layout Strategy: Used a Row to align the avatar and text horizontally.

Widgets:

CircleAvatar: Displayed the profile picture using NetworkImage.

Column: Stacked the Name and Title vertically next to the avatar.

SizedBox: Added spacing between the avatar and text.

2. Stats Row (Social Proof)

Layout Strategy: Used a Row with MainAxisAlignment.spaceEvenly to distribute stats across the screen width.

Widgets:

Column: Stacked the number ("1.1B") above the label ("Followers").

Text: Styled with specific font sizes and colors to create hierarchy.

3. Bio Section (About)

Layout Strategy: Used a Container to create a "Card" effect.

Widgets:

Container: Provided the dark grey background color (Colors.grey[900]) and padding.

Text: Displayed multi-line description text.

Center: Centered the bio container on the screen.

4. Gallery Grid (Portfolio)

Layout Strategy: Used a GridView to display a collection of work.

Widgets:

GridView: Configured with crossAxisCount: 3 for a 3-column layout.

Key Solution: Used shrinkWrap: true and physics: NeverScrollableScrollPhysics() to allow the grid to live inside the main page's scrolling column without crashing.