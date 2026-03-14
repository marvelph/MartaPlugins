# MartaPlugins
[English](README.md) | [日本語](README.ja.md)

Plugins for [Marta](https://marta.sh).
## movement.lua
**Plugin ID:** `org.programmershigh.movement`
### Move to Next Selection
**Action ID:** `move.next.selection`

Moves the cursor to the next selected item.
### Move to Previous Selection
**Action ID:** `move.previous.selection`

Moves the cursor to the previous selected item.
## navigation.lua
**Plugin ID:** `org.programmershigh.navigation`
### Change Current Pane to Left
**Action ID:** `change.current.pane.left`

Moves focus to the left pane.
### Change Current Pane to Right
**Action ID:** `change.current.pane.right`

Moves focus to the right pane.
### Clone Current Folder to Active Pane
**Action ID:** `clone.active`

Matches the active pane directory to the inactive pane directory.
### Clone Current Folder to Inactive Pane
**Action ID:** `clone.inactive`

Matches the inactive pane directory to the active pane directory.
### Go to Root
**Action ID:** `go.root`

Moves to the root directory.
### Go to Home
**Action ID:** `go.home`

Moves to the home directory.
## selection.lua
**Plugin ID:** `org.programmershigh.selection`
### Select Same Files in Inactive Pane
**Action ID:** `select.same.file`

Selects files that also exist in the inactive pane with the same name.
### Select Files Not in Inactive Pane
**Action ID:** `select.different.file`

Selects files whose name does not exist in the inactive pane.
### Select All Files Only
**Action ID:** `select.all.file`

Selects all files. Directory selections are not changed.
### Invert File Selection Only
**Action ID:** `select.invert.file`

Inverts the selection state of all files. Directory selections are not changed.
### Select Files with Same Extension as Current Item
**Action ID:** `select.extension`

Selects all files with the same extension as the file under the cursor.

## Distribution
The plugin is distributed from:
https://github.com/marvelph/MartaPlugins

## License
See [LICENSE](LICENSE) for license details.

## Contact
For bug reports and feature requests, please use GitHub Issues:
https://github.com/marvelph/MartaPlugins/issues  
Email: marvel@programmershigh.org
