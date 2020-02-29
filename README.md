
# Missile-Command
A Java based clone of the classic game missile command designed in Processing.

Compile Instructions:
- Put the file in a folder called Missile Command
- Open the missile command file using processing
- Execute the program to start the game.

Objective:
The objective of the game is to use missiles to destroy falling particles to protect the cities on the
ground.

Layout:
The basic layout of a level has 3 silos and 6 cities on the ground, and particles falling from the sky
towards the ground. The silos are placed on the left corner, right corner and the center of the screen
each, and the cities are paced such that there are 3 cities between the center silo and each of the corner
silos.

Controls:
Move the cross-hair to take aim and click to launch a missile to reach the specified destination. The silo
from which the missile is launched is chosen depending on whichever is the closest.
Each silo only has 10 missiles each round and if a silo is destroyed, it cant shoot missiles for that round.
Missiles can also be launched using the arrow keys LEFT, RIGHT and UP to shoot a missile from the
left, right or center silo respectively. The missiles shot by the center silo are faster than the ones shot
form the other silos.

Waves:
Each wave has a set number of particles that increase with each wave. The particles also start to fall at a
higher velocity as the waves progress.
At the end of each wave, all the dead silos are repaired and restocked with missiles.
A wave is completed if after the destruction of all particles and enemies, at-least one city is still alive.

Progression:
As we get to higher waves, we start seeing new enemies like the Bomber and the Satellite that drop
new particles periodically across the play-field. We also see a “smart bomb” at later stages which
detects an incoming missile and slows itself down to avoid being hit by the missile.

Scoring:
Each particle destroyed adds 25 points to the score, each killed enemy (bomber/satellite) adds 100
points. At the end of each wave, 100 additional points are added for each surviving city and 5 for each
unused missile.
The score is multiplied as per the wave number (the multiplier increases by 1 after every 2 waves till
the 11 th wave).
A dead city is revived for every 10000 points made at the end of the round in which the required mark
is crossed.

Lose condition:
The game is lost once all the cities are dead.
