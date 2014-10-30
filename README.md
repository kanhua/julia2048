This is a 2048 game written in Julia.

The game is launched from ```playjulia2048.jl```, namely running this in command line:

```
$> julia playjulia2048.jl
```

Apart from the standard human-computer game interface, this project also implements several AI agent that plays the game. Please see ```playjulia2048.jl``` for details.

Here is the summary of the files:

- ```play2048.jl``` : the entry point of this 2048 game.
- ```julia2048.jl```: It contains the main games loop and the implementation of different AI agents
- ```core2048.jl```: Functions for making the moves and merges of the 2048 game board