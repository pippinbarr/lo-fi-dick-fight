package;


import flixel.util.FlxCollision;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxG;

import flixel.system.FlxSound;

import flixel.text.FlxText;
import flixel.util.FlxTimer;


enum MatchState {
	START;
	PLAY;
	POINT;
	END;
}

class PlayState extends FlxState
{

	private var COLORS:Array<Int>;

	private var GAME_TIME:Int = 2*60;
	private var RESET_TIME:Int = 2;

	private var currentBG1Color:Int;
	private var previousBG1Color:Int;
	private var currentBG2Color:Int;
	private var previousBG2Color:Int;
	private var currentBG3Color:Int;
	private var previousBG3Color:Int;
	private var currentP1BodyColor:Int;
	private var previousP1BodyColor:Int;
	private var currentP1DickColor:Int;
	private var previousP1DickColor:Int;
	private var currentP2BodyColor:Int;
	private var previousP2BodyColor:Int;
	private var currentP2DickColor:Int;
	private var previousP2DickColor:Int;
	private var currentTextColor:Int;
	private var previousTextColor:Int;

	private var bg1:FlxSprite;
	private var bg2:FlxSprite;
	private var bg3:FlxSprite;
	private var p1:Player;
	private var p2:Player;

	private var p1Score:Int = 0;
	private var p2Score:Int = 0;

	private var p1GotAHit:Bool = false;
	private var p2GotAHit:Bool = false;

	private var p1ScoreText:FlxText;
	private var p2ScoreText:FlxText;
	private var gameTimerText:FlxText;

	private var flavourText:FlxText;

	private var gameTimer:FlxTimer;
	private var resetTimer:FlxTimer;


	private var point:FlxSound;
	private var victory:FlxSound;

	private var state:MatchState;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	 override public function create():Void
	 {
	 	state = START;

	 	setupColors();

		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.hide();
		#end

		bg1 = new FlxSprite(0,0,"assets/images/bg1.png");
		bg2 = new FlxSprite(0,0,"assets/images/bg2.png");
		bg3 = new FlxSprite(0,0,"assets/images/bg3.png");

		var projectileMode:Bool = (MenuState.projectileDicks == 1);
		var p1DickType:Player.DickType = SMALL;
		var p2DickType:Player.DickType = SMALL;

		switch (MenuState.p1DickSize)
		{
			case 0:
			p1DickType = SMALL;

			case 1:
			p1DickType = MEDIUM;

			case 2:
			p1DickType = BIG;
		}

		switch (MenuState.p2DickSize)
		{
			case 0:
			p2DickType = SMALL;

			case 1:
			p2DickType = MEDIUM;

			case 2:
			p2DickType = BIG;
		}		

		p1 = new Player(150,300,p1DickType,projectileMode,"A","D","W","S","F");		
		p2 = new Player(Std.int(FlxG.width - p1.body.width - 150),300,p2DickType,projectileMode,"LEFT","RIGHT","UP","DOWN","SPACE");
		
		p1ScoreText = new FlxText(0,0,Std.int(FlxG.width/3),""+p1Score,64);
		p1ScoreText.setFormat("Square",64,0xFFFFFFFF,"center");
		p1ScoreText.y = 60 - p1ScoreText.height/2;

		p2ScoreText = new FlxText(2*FlxG.width/3,0,Std.int(FlxG.width/3),""+p2Score,64);
		p2ScoreText.setFormat("Square",64,0xFFFFFFFF,"center");
		p2ScoreText.y = 60 - p2ScoreText.height/2;

		gameTimerText = new FlxText(0,0,Std.int(FlxG.width),gameTimeAsString(GAME_TIME),64);
		gameTimerText.setFormat("Square",48,0xFFFFFFFF,"center");
		gameTimerText.y = 60 - gameTimerText.height/2;

		flavourText = new FlxText(40,p2ScoreText.y + p2ScoreText.height + 0,FlxG.width - 80,"");
		flavourText.setFormat("Square",28,0xFFFFFFFF,"center");


		add(bg1);
		add(bg2);
		add(bg3);

		add(p1ScoreText);
		add(p2ScoreText);
		add(gameTimerText);
		add(flavourText);

		add(p1);
		add(p1.dick);
		add(p1.body);

		add(p2);
		add(p2.dick);
		add(p2.body);



		point = new FlxSound();
		point.loadEmbedded("assets/sounds/point.mp3",false);
		victory = new FlxSound();
		victory.loadEmbedded("assets/sounds/victory.mp3",false);


		gameTimer = FlxTimer.recycle();

		resetTimer = FlxTimer.recycle();
		resetTimer.run(RESET_TIME,resetPoint);

		cycleColors();

		super.create();
	}
	

	private function setupColors():Void
	{
		COLORS = [0xffff6666,0xffff66ff,0xff9966ff,0xff6699ff,0xff66ffcc,0xff99ff66,0xffffff66,0xffff9966];
		previousBG1Color = 0xff71ff6b;
		previousBG2Color = 0xff6ef9ff;
		previousBG3Color = 0xff00ff00;
		previousP1BodyColor = 0xfffc5cff;
		previousP1DickColor = 0xffffff00;
		previousP2BodyColor = 0xfffc5cff;
		previousP2DickColor = 0xffffff00;
	}


	private function gameTimeAsString(Time:Int):String
	{
		var minutes:Int = Math.floor(Time / 60);
		var seconds:Int = Time % 60;

		var minuteString:String = (minutes < 10) ? "0" + minutes : ""+minutes;
		var secondsString:String = (seconds < 10) ? "0" + seconds : ""+seconds;

		return minuteString + ":" + secondsString;
	}


	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	 override public function destroy():Void
	 {
	 	bg1.destroy();
	 	bg2.destroy();
	 	bg3.destroy();
	 	p1.destroy();
	 	p2.destroy();
	 	p1ScoreText.destroy();
	 	p2ScoreText.destroy();
	 	gameTimerText.destroy();

	 	flavourText.destroy();

	 	gameTimer.destroy();
	 	resetTimer.destroy();

	 	point.destroy();
	 	victory.destroy();

	 	super.destroy();
	 }



	 private function resetPoint(t:FlxTimer):Void
	 {
	 	p1.inputEnabled = true;
	 	p2.inputEnabled = true;

	 	if (state == START)
	 	{
	 		p1.resetTo(150,300);
	 		p2.resetTo(Std.int(FlxG.width - p1.body.width - 150),300);

	 		// p1.erection.play();

	 		flavourText.text = "";

	 		gameTimer.run(GAME_TIME,gameTimerOver);
	 		state = POINT;
	 	}
	 	else
	 	{

	 		if (p1GotAHit || p2GotAHit)
	 		{
	 			trace("Points were scored.");

	 			if (p1GotAHit) p1Score++;
	 			if (p2GotAHit) p2Score++;

	 			updateScores();

	 			point.play();

	 			p1GotAHit = false;
	 			p2GotAHit = false;
	 		}

	 		resetTimer.run(1,cycleColorsAndReset);	 		
	 	}

	 }


	 private function cycleColorsAndReset(t:FlxTimer):Void
	 {
	 	cycleColors();

	 	p1.resetTo(150,300);
	 	p2.resetTo(Std.int(FlxG.width - p1.body.width - 150),300);

	 	flavourText.text = "";

	 }


	 private function gameTimerOver(t:FlxTimer):Void
	 {
	 	victory.play();

	 	resetTimer.abort();
	 	p1.flaccidTimer.abort();
	 	p2.flaccidTimer.abort();

	 	if (p1GotAHit || p2GotAHit)
	 	{
	 		if (p1GotAHit) p1Score++;
	 		if (p2GotAHit) p2Score++;

	 		point.play();

	 		p1GotAHit = false;
	 		p2GotAHit = false;
	 	}

	 	gameTimerText.text = "00:00";
	 	state = END;

	 	if (p1Score > p2Score) 
	 	{
	 		flavourText.text = "WINNER PLAYER ONE\n\n[SPACE] OR [F] FOR REMATCH\n[ESCAPE] FOR MENU";
	 		p1.win();
	 		p2.lose();
	 	}
	 	else if (p2Score > p1Score)
	 	{
	 		flavourText.text = "WINNER PLAYER TWO\n\n[SPACE] OR [F] FOR REMATCH\n[ESCAPE] FOR MENU";
	 		p2.win();
	 		p1.lose();
	 	}
	 	else 
	 	{
	 		flavourText.text = "DRAW\n\n[SPACE] OR [F] FOR REMATCH\n[ESCAPE] FOR MENU";
	 		p1.lose();
	 		p2.lose();
	 	}
	 }


	 private function cycleColors():Void
	 {
	 	COLORS.sort(randomSort);

	 	currentBG1Color = COLORS[0];
	 	currentBG2Color = COLORS[1];
	 	currentBG3Color = COLORS[2];
	 	currentP1BodyColor = COLORS[3];
	 	currentP1DickColor = COLORS[4];
	 	currentP2BodyColor = COLORS[5];
	 	currentP2DickColor = COLORS[6];

	 	bg1.replaceColor(previousBG1Color,currentBG1Color);
	 	bg2.replaceColor(previousBG2Color,currentBG2Color);
	 	bg3.replaceColor(previousBG3Color,currentBG3Color);
	 	p1.body.replaceColor(previousP1BodyColor,currentP1BodyColor);
	 	p1.dick.replaceColor(previousP1DickColor,currentP1DickColor);
	 	p2.body.replaceColor(previousP2BodyColor,currentP2BodyColor);
	 	p2.dick.replaceColor(previousP2DickColor,currentP2DickColor);

	 	p1ScoreText.setFormat("Square",64,COLORS[7],"center");
	 	p2ScoreText.setFormat("Square",64,COLORS[7],"center");
	 	gameTimerText.setFormat("Square",48,COLORS[7],"center");
	 	flavourText.setFormat("Square",28,COLORS[7],"center");

	 	previousBG1Color = currentBG1Color;
	 	previousBG2Color = currentBG2Color;
	 	previousBG3Color = currentBG3Color;
	 	previousP1BodyColor = currentP1BodyColor;
	 	previousP1DickColor = currentP1DickColor;
	 	previousP2BodyColor = currentP2BodyColor;
	 	previousP2DickColor = currentP2DickColor;

	 }

	/**
	 * Function that is called once every frame.
	 */
	 override public function update():Void
	 {
	 	super.update();

	 	handleTimer();
	 	handleFacing();
	 	if (!p1GotAHit && !p2GotAHit) handleDicks();
	 	handleInput();
	 	updateScores();

	 	// trace("P1 dick frame: " + p1.dick.animation.frameIndex + ", P2 dick frame: " + p2.dick.animation.frameIndex);
	 }	


	 private function handleInput():Void
	 {
	 	if (state == END)
	 	{
	 		if (FlxG.keyboard.justPressed("SPACE") || FlxG.keyboard.justPressed("F"))
	 		{
	 			FlxG.switchState(new PlayState());
	 		}
	 		else if (FlxG.keyboard.justPressed("ESCAPE"))
	 		{
	 			FlxG.switchState(new MenuState());
	 		}
	 	}
	 }


	 private function updateScores():Void
	 {
	 	p1ScoreText.text = ""+p1Score;
	 	p2ScoreText.text = ""+p2Score;
	 }


	 private function handleTimer():Void
	 {
	 	if (state == PLAY || state == POINT)
	 	{
	 		gameTimerText.text = gameTimeAsString(Std.int(gameTimer.timeLeft));
	 	}
	 }



	 private function handleFacing():Void
	 {
	 	if (p1.body.x + p1.body.width/2 > p2.body.x + p2.body.width/2)
	 	{
	 		p1.face(FlxObject.LEFT);
	 		p2.face(FlxObject.RIGHT);
	 	}
	 	else
	 	{
	 		p1.face(FlxObject.RIGHT);
	 		p2.face(FlxObject.LEFT);
	 	}
	 }


	 private function handleDicks():Void
	 {
	 	// Check for x-range

	 	if (state == END) return;

	 	p1GotAHit = p1.checkForHit(p2);
	 	p2GotAHit = p2.checkForHit(p1);

	 	if (p1GotAHit) 
	 	{
	 		p2.dickWasHit();
	 	}

	 	if (p2GotAHit) 
	 	{
	 		p1.dickWasHit();
	 	}

	 	if (p1GotAHit || p2GotAHit)
	 	{
	 		resetTimer.run(RESET_TIME,resetPoint);
	 	}
	 }


	 public function randomSort(X:Dynamic,Y:Dynamic):Int
	 {
	 	var r:Float = Math.random();
	 	if (r < 0.33) return 1;
	 	else if (r < 0.66) return 0;
	 	else return -1;

	 }	 


	}