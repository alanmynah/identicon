# Identicon

Creates a grid similar to github identicon.

MD5 hashes the name, first 15 values are then arranged in a 25-cell grid
(10 values on the left are mirrored along the central 5 values),
like so:

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| 1   | 2   | 3   | 4   | 5   |
| 4   | 5   | 6   | 5   | 4   |
| 7   | 8   | 9   | 8   | 7   |
| 10  | 11  | 12  | 11  | 10  |
| 13  | 14  | 15  | 14  | 13  |

If a value is even - coloured cell, odd - blank cell.
And to make it pretty, the first 3 values are used to get RGB colours

Example: [banana.png](./banana.png)
