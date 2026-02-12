Issue number generator.


Idea is that i want to NUMBERATE all issues, and keeping track on those is hard.

Press the keybind, window opens asking if you want to add a issue at cursor location.
it then inserts "Error: #X".

with a nvim plugin, we can at root, create a list of issues.

We store the state of this in the root of the individual project as "error_tracker"

When creating a new issue, it looks at the bottom line number, and increments based on that

the file will look like this:

Error: #1 - <rel_path to where the file is>
Error: #2 - <rel_path to where the file is>
