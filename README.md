CIS 1051 Final Project by Rob Butaev, Landen Lloyd, Kristin Wieland.

Video link: https://temple.zoom.us/rec/play/LnJYpifjNnRgogO_A2__T2h0rR1EowEo3yO9CtBAlb26IqdPqwsfwwEQW5M8Nmc1IvgLXqujaW6l_RRe.VLOwK7IxnxecyW5k?startTime=1607394546000

Problems:
1. Lua Scope:
  We were experiencing nonsensical errors, like the arrow keys moving the tetrimino. We unknowingly put all our variables in the global scope, causing the different classes to override eachother. We solved this using classes and the self keyword.
2. Table Overriding:
  Originally, the center block would move in ways that almost seemed random with blocks being deleted, and some blocks moving twice. We found out that since we were editing our tables in place, and the keys were based on block coordinates, one block would move on top of the other and override the other. We fixed this by building a second table with the new coordinates, and then assigning the old table variable to the new table.
3. Program Flow:
  We originally had an issue where sometimes the tetrimino would be added multiple times because collision is called multiple times before drawing which updates the table, so we tried calling tetriminoManager:shapes() which would reset the table immediately but the error persisted. We then updated the table inside the collision function which fixed the issue.
4. Poor Logic:
  We spent a long time chasing a bug where blocks would not collide vertically. We found that the collision checking formula was checking blocks 1 out rather than 4 out, so this was an easy fix. Easy fix, but it took a LONG time to find the error.
