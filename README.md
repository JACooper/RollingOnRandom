# RollingOnRandom

A project made for an interactive media class. Creates a randomized infinite 2D scene with a character & vehicle moving across it.

NOTE: This program was developed in Processing, a specialized Java-based development tool, and requires it to run. You can download Processing for free here: https://processing.org/download/
(This project was initially developed for Processing 2, but has been updated to work with the latest version, Processing 3.)

User Functionality: 
	-	User functionality is limited to opening and closing the program; the program is self-contained

“Above & Beyond” Features: 
	-	Generated a perlin noise foreground that scrolls infinitely; has 3 tints of green to visually break it up a little.
	-	Similarly generated a perlin noise background giving the illusion of mountains in the background. It scrolls slower than the foreground, giving a parallax effect.
	-	A semi-random (that is, random within a small range) amount of snow falls from the sky at varying speeds and sways.
	-	Snow gradually accumulates on the ground as time goes on.
	-	There is a day night cycle. Each night, a randomly determined collection of stars appears in random positions above the mountains. Simple constellations occasionally appear between close stars.
	-	The cart pusher, Kjeldson, will react when the stars appear.
	-	Both the character and the vehicle are textured and their movement is animated.
	-	Both the character and the vehicle will rotate their orientation based on the elevation of the perlin generated ground.
	-	There’s a blood moon that moves across the sky and eventually plunges the world into endless night.
