# bf.rc

A brainfuck interpreter written in pure rc

## Info

- "Pure" rc here means only using the Plan 9 base utilities, excluding `awk`, as you can't really do anything with just rc builtins (and `awk` is more powerful than rc)
	- I also tried to use as few external utilities as few times as possible; the current list is `ascii`, `bc`, `echo`, and `read`.
- It reads the program from a file named in the first argument
	- If there are no arguments, it reads from standard input
- An array with around 30,000 cells to the right and 2,000 to the left is created
- Output is ASCII-encoded
