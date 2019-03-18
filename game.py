import time
import sys

def printString(inputed, wait=1, dellines=0):
		print(inputed)
		time.sleep(wait)
		for i in range(dellines):
			sys.stdout.write("\033[F") #back to previous line
			sys.stdout.write("\033[K") #clear line

def whatDoYouDo():
	level = 1
	typeofaxe = "rusty"
	treescut = 0
	bestaxe = "rusty"
	while(True):
		print("What do you do?\n (1) Examine bag and character \n (2) Equipt Axe")
		print(" (3) Chop Tree \n (4) Hear what Carter did this week and is doing next week")
		whatInt = int(input())
		if(whatInt == 1):
			printString("You have a " + typeofaxe + " axe")
			printString("You are level " + str(level) + " woodcutting")
			printString("You have chopped "+ str(treescut) + " trees",dellines=8)
		if(whatInt == 2):
			printString("You have equipt the "+ bestaxe +" axe")
			typeofaxe = bestaxe
		if(whatInt == 3):
			printString("You chop a tree")
			if(treescut == 0):
				printString("You find a Bronze Axe")
				bestaxe = "bronze"
			if(treescut == 2):
				printString("You are now chopping level 2")
				level = 2
			if(treescut == 4):
				printString("You find a Steel Axe")
				bestaxe = "steel"
			if(treescut == 6):
				printString("You are now chopping level 3")
				level = 3
			if(treescut == 8):
				printString("You find a Mithril Axe")
				bestaxe = "mithril"
			if(treescut == 10):
				printString("You find a Adamant Axe")
				bestaxe = "adamant"
			if(treescut == 12):
				printString("You are now chopping level 4")
				level = 4
			if(treescut == 14):
				printString("You find a Rune Axe")
				bestaxe = "rune"
			if(treescut == 20):
				printString("You are now chopping level 5")
				level = 5
			treescut += 1
		if(whatInt == 4):
			if(level < 5):
				printString("You must be chopping level 5 to hear what Carter did this week",3,6)
			else:
				printString("This week I kept working on connecting components. Working more on the memory this week and next");
		

printString("You blink your eyes open and find yourself in a dewey clearing",2)
printString("There is no one around",2,)
printString("There are some trees nearby though!",2,3)
whatDoYouDo()
