CIS 1051 Final Project by Rob Butaev, Landen Lloyd, Kristin Wieland.

Problems:
1. Lua Scope
  We were experiencing nonsensical errors, like the arrow keys moving the tetrimino. We unknowingly put all our variables in the global scope, causing the different classes to override eachother. We solved this using classes and the self keyword.
2. Table Overriding
  Originally, the center block would move in ways that almost seemed random with blocks being deleted, and some blocks moving twice. We found out that since we were editing our tables in place, and the keys were based on block coordinates, one block would move on top of the other and override the other. We fixed this by building a second table with the new coordinates, and then assigning the old table variable to the new table.
