Chopsticks: a terminal-based game written in C

This is an interpretation of the hand game called "Chopsticks", where players take turns wacking eachothers fingers until the other person has none left (Note: the game isn't violent, it's a numbers game. A better explanation can be found here: https://en.wikipedia.org/wiki/Chopsticks_(hand_game) )
The player is playing against a simple AI opponent, and has the following input commands available:
	LL or LR or RL or RR:
		This is how the player designates what hand hits which. For example, 'LR' means to hit the computers right hand with your left hand.
	split:
		When you only have one hand available and it has an even number of fingers, you can use the split command to split the number between both hands (For example, you go from having a hand state of 4-0 to 2-2)
	quit:
		After finishing a round, you can enter 'quit' to end the program.
	restart:
		After finishing a round, you can choose to restart the game.

This project was a for-fun project of mine to get more comfortable writing code in C.