## Adventuredice.com ##

iPhone/iPad App

iPad can be used as the board or the controller
iPhone used as the controller (but shows results too)

link up iphones/ipads. all throws shown on all screens
This will use gamekit to create a game session

https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/GameKit_Guide/Matchmaking/Matchmaking.html#//apple_ref/doc/uid/TP40008304-CH9-SW1

iPad will 'host' the game and add the iPhones to it.

### Features ###
* favourites: allows throwing of same dice over and over again
* any dice: allows creation of any sided dice, added to main dice selection screen
* See history of throws.
* shake to throw
* option to say the numbers thrown out loud
* option to have an animated delay before dice is shown, or instant result
* option to have graphics or just numbers
* Ability to add a static bonus to favourites (i.e. result + 5 or whatever)
* Must be obvious when the dice is thrown (how do I know if I threw the same number again?) but no animation

### Flow ###
* start the app
* if there are favourites, show the favourites tab, otherwise show default dice bag
* there are four tabs [dice bag, favourites, history, settings]
* dice bag:
 * show a list of all of the default dice (include a button to add any sided dice)
 * when a dice is pressed, add it to the bag on the right of the screen
 * if the star button is pressed, add it to the favourites (the start will already be lit if it's a favourite)
 * when the device is shaken, show the results
* favourites:
 * show a list of the favourite dice bags
 * swipe to delete favourite
 * tap to roll the dice in that bag
* history:
 * show a list of previous rolls and their results
 * clear button (with confirmation) allows clearing of the history
* settings:
 * add/remove dice from default dice on the dice bag tab (doesn't affect favourites)
 * turn on/off shake to throw function

### MVP ###
* add type of dice to main throw screen
* Select dice to roll on iphone/ipad this turn
* Show result on same device
* favourite dice choices
* shake to throw
* instant results

### Version 1 ###
* link up to ipad, see results on ipad (each direction sees clearly)
* throw history on primary device
* speak results (not text to speech, have to be recorded!)

### Version 2 ###
* link up to other iphones, all devices show results
* animated delay or instant results
* graphics or numbers

### Development Thoughts ###

DiceBagController
  DiceBagView
FavouritesController
  FavouritesView
HistoryController
	HistoryView
SettingsController
	SettingsView
	
DiceModel
	Sides
	
ResultsController
	ResultsView
	
rootViewController = tabView
tabView controllers =
[Dice Bag] = DiceBagController -> ResultsController [show modal]
[Favourites] = FavouritesController -> ResultsController  [show modal]


###Dice List###
* 2
* 3
* 4
* 5
* 6
* 7
* 8
* 10
* 12
* 14
* 16
* 18
* 20
* 24
* 30
* 34
* 50
* 60
* 100
