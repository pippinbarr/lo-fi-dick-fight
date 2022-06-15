package;


import flixel.util.FlxCollision;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxG;

import flixel.text.FlxText;
import flixel.util.FlxTimer;

import flixel.system.FlxSound;

class MenuState extends FlxState
{
	private var TEXT_COLORS:Array<Int>;
	private var BG_COLORS:Array<Int>;

	public static var p1DickSize:Int = 1;
	public static var p2DickSize:Int = 1;
	public static var projectileDicks:Int = 0;

	private var nextArrowText:FlxText;
	private var previousArrowText:FlxText;
	private var selectedModeText:FlxText;
	private var titleText:FlxText;
	private var p1InstructionsText:FlxText;
	private var p2InstructionsText:FlxText;

	private var modeStrings:Array<String>;
	private var modeSettings:Array<Array<Int>>;

	private var currentModeSelected:Int = 0;

	private var select:FlxSound;
	private var start:FlxSound;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	 override public function create():Void
	 {
	 	TEXT_COLORS = [0xffff6666,0xff9966ff,0xff6699ff,0xffff9966,0xffff66ff,0xff66ffcc,0xff99ff66,0xffffff66];	 	
	 	BG_COLORS = [0xffff6666,0xff9966ff,0xff6699ff,0xffff9966,0xffff66ff,0xff66ffcc,0xff99ff66,0xffffff66];	 	

	 	//BG_COLORS = [0xffffaa80,0xffff8080,0xffffe680,0xffc5ff80,0xff80ffad,0xff80feff, 0xff80a7ff,0xffbc80ff,0xffff80f8];
	 	// TEXT_COLORS = [0xffd66b6b,0xffd6a36b,0xffd6c86b,0xffafd66b,0xff70d66b];

	 	//BG_COLORS = [0xffff9999];
	 	// TEXT_COLORS = [0xffff3333];

	 	modeStrings = [
	 	"SMALL DICK\nVS.\nSMALL DICK",
	 	"MEDIUM DICK\nVS.\nMEDIUM DICK",
	 	"BIG DICK\nVS.\nBIG DICK",
	 	"SMALL DICK\nVS.\nMEDIUM DICK",
	 	"MEDIUM DICK\nVS.\nSMALL DICK",
	 	"SMALL DICK\nVS.\nBIG DICK",
	 	"BIG DICK\nVS.\nSMALL DICK",
	 	"MEDIUM DICK\nVS.\nBIG DICK",
	 	"BIG DICK\nVS.\nMEDIUM DICK",
	 	"PROJECTILE DICKS"
	 	];

	 	modeSettings = [
	 	[0,0,0],
	 	[1,1,0],
	 	[2,2,0],
	 	[0,1,0],
	 	[1,0,0],
	 	[0,2,0],
	 	[2,0,0],
	 	[1,2,0],
	 	[2,1,0],
	 	[1,1,1],
	 	];

	 	p1DickSize = 0;
	 	p2DickSize = 0;
	 	projectileDicks = 0;

	 	currentModeSelected = 0;


		// Set a background color
		FlxG.cameras.bgColor = BG_COLORS[Math.floor(Math.random() * BG_COLORS.length)];

		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.hide();
		#end
		
		titleText = new FlxText(0,0,Std.int(FlxG.width),"LO-FI\nDICK\nFIGHT",64);
		titleText.setFormat("Square",64,0xFFFFFFFF,"center");
		titleText.y = 20;

		p1InstructionsText = new FlxText(0,FlxG.height - 64,Std.int(FlxG.width/3),"PLAYER ONE:\nUSE [W,A,S,D] AND [F]",64);
		p1InstructionsText.setFormat("Square",18,0xFF000000,"center");

		p2InstructionsText = new FlxText(2*FlxG.width/3,FlxG.height - 64,Std.int(FlxG.width/3),"PLAYER TWO:\nUSE [ARROW KEYS] AND [SPACE]",64);
		p2InstructionsText.setFormat("Square",18,0xFF000000,"center");

		selectedModeText = new FlxText(0,0,Std.int(FlxG.width),"SMALL DICK\nVS.\nSMALL DICK",64);
		selectedModeText.setFormat("Square",48,0xFF000000,"center");
		selectedModeText.y = 240;

		previousArrowText = new FlxText(40,0,Std.int(FlxG.width),"<",64);
		previousArrowText.setFormat("Square",72,0xFF000000,"left");
		previousArrowText.y = selectedModeText.y + selectedModeText.height/2 - 80;

		nextArrowText = new FlxText(FlxG.width - 40 - 36,0,Std.int(FlxG.width),">",64);
		nextArrowText.setFormat("Square",72,0xFF000000,"left");
		nextArrowText.y = previousArrowText.y;

		add(titleText);
		add(p1InstructionsText);
		add(p2InstructionsText);
		add(previousArrowText);
		add(nextArrowText);
		add(selectedModeText);

		cycleColors();

		super.create();

		select = new FlxSound();
		select.loadEmbedded("assets/sounds/dickreturned.mp3",false);
		start = new FlxSound();
		start.loadEmbedded("assets/sounds/slap.mp3",false);
	}
	


	private function cycleColors():Void
	{
		TEXT_COLORS.sort(randomSort);
		BG_COLORS.sort(randomSort);

		FlxG.camera.bgColor = BG_COLORS[0];

		titleText.setFormat("Square",64,BG_COLORS[1],"center");
		// p1InstructionsText.setFormat("Square",18,TEXT_COLORS[1],"center");
		// p2InstructionsText.setFormat("Square",18,TEXT_COLORS[1],"center");
		// selectedModeText.setFormat("Square",48,TEXT_COLORS[1],"center");
		// previousArrowText.setFormat("Square",72,TEXT_COLORS[1],"left");
		// nextArrowText.setFormat("Square",72,TEXT_COLORS[1],"left");
	}
	

	public function randomSort(X:Dynamic,Y:Dynamic):Int
	{
		var r:Float = Math.random();
		if (r < 0.33) return 1;
		else if (r < 0.66) return 0;
		else return -1;

	}	


	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	 override public function destroy():Void
	 {
	 	nextArrowText.destroy();
	 	previousArrowText.destroy();
	 	selectedModeText.destroy();
	 	titleText.destroy();
	 	p1InstructionsText.destroy();
	 	p2InstructionsText.destroy();

	 	select.destroy();
	 	start.destroy();

	 	super.destroy();
	 }



	/**
	 * Function that is called once every frame.
	 */
	 override public function update():Void
	 {
	 	super.update();

	 	handleInput();
	 }	


	 private function handleInput():Void
	 {
	 	if (FlxG.keyboard.justPressed("LEFT") || FlxG.keyboard.justPressed("A") ||
	 		FlxG.keyboard.justPressed("UP") || FlxG.keyboard.justPressed("W"))
	 	{
	 		currentModeSelected = (currentModeSelected - 1);
	 		if (currentModeSelected == -1) currentModeSelected = modeStrings.length - 1;

	 		cycleColors();

	 		select.play();
	 	}
	 	else if (FlxG.keyboard.justPressed("RIGHT") || FlxG.keyboard.justPressed("D") ||
	 		FlxG.keyboard.justPressed("DOWN") || FlxG.keyboard.justPressed("S"))
	 	{
	 		currentModeSelected = (currentModeSelected + 1) % modeStrings.length;

	 		cycleColors();

	 		select.play();
	 	}
	 	else if (FlxG.keyboard.justPressed("SPACE") || FlxG.keyboard.justPressed("F"))
	 	{
	 		start.play();

	 		FlxG.switchState(new PlayState());
	 	}

	 	p1DickSize = modeSettings[currentModeSelected][0];
	 	p2DickSize = modeSettings[currentModeSelected][1];
	 	projectileDicks = modeSettings[currentModeSelected][2];
	 	selectedModeText.text = modeStrings[currentModeSelected];

	 	if (projectileDicks == 1)
	 	{
	 		selectedModeText.y = 290;
	 	}
	 	else
	 	{
	 		selectedModeText.y = 240;	
	 	}
	 }



	}