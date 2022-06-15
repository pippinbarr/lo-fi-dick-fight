package;


import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.util.FlxCollision;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

enum DickType {
	SMALL;
	MEDIUM;
	BIG;
}

class Player extends FlxSpriteGroup
{
	private static var X_MARGIN:Int = 50;
	private static var Y_MARGIN:Int = 200;

	private static var XSPEED:Int = 300;
	private static var YSPEED:Int = 180;

	private static var PROJECTILE_DICK_SPEED:Int = 600;
	private static var FLACCID_TIME:Int = 2;

	public var body:FlxSprite;
	public var dick:FlxSprite;
	// public var dickHit:FlxSprite;

	// public var dickTip:FlxSprite;
	// public var dickBase:FlxSprite;

	private var dickType:DickType;
	public var dxMax:Int;
	public var dxMin:Int;
	public var hitFrame:Int;
	public var hittableFrame:Int;
	private var fallenDickFrame:Int;
	private var dickStartIndex:Int;
	private var flaccidDickFrame:Int;
	private var hitStartFrame:Int;

	public var projectileDick:Bool = false;
	public var hasDick:Bool = true;
	public var blewWad:Bool = false;
	public var deadDick:Bool = false;
	public var dickReturning:Bool = false;
	public var dickFlaccid:Bool = true;
	public var winner:Bool = false;
	public var gameOver:Bool = false;

	public var inputEnabled:Bool = false;

	private var leftKey:String;
	private var rightKey:String;
	private var upKey:String;
	private var downKey:String;
	private var attackKey:String;

	public var flaccidTimer:FlxTimer;
	

	private var footstep:FlxSound;
	private var slap:FlxSound;
	private var launch:FlxSound;
	private var hit:FlxSound;
	private var returned:FlxSound;
	public var erection:FlxSound;
	
	public function new(X:Int, Y:Int, TheDickType:DickType, ProjectileDick:Bool, LeftKey:String, RightKey:String, UpKey:String, DownKey:String, AttackKey:String):Void
	{
		super(X,Y);

		leftKey = LeftKey;
		rightKey = RightKey;
		upKey = UpKey;
		downKey = DownKey;
		attackKey = AttackKey;

		body = new FlxSprite(X,Y);
		// body.loadGraphic("assets/images/walk.png",true,true,6,16,false);
		body.loadGraphic("assets/images/walk_6x.png",true,true,18*6,16*6,true);
		body.animation.add("walk",[0,1],12,true);
		body.animation.add("idle",[0,0],12,true);
		body.animation.add("lose",[2,2],12,true);

		dickType = TheDickType;
		projectileDick = ProjectileDick;

		var dickGraphic:String = "";
		var animHitFrames:Array<Int> = [];
		var dickStartIndex:Int = 0;

		switch (dickType)
		{
			case BIG:
			dickGraphic = "assets/images/big_dick_6x.png";
			dxMax = 3*6 + 4*6;
			dxMin = 3*6;
			hitFrame = 4;
			hittableFrame = 6;
			fallenDickFrame = 5;
			animHitFrames = [1,2,3,4,5,6];
			dickStartIndex = hittableFrame;	
			flaccidDickFrame = 7;	
			hitStartFrame = 3;		

			case MEDIUM:
			dickGraphic = "assets/images/medium_dick_6x.png";
			dxMax = 4*6 + 3*6;
			dxMin = 4*6;
			hitFrame = 3;
			hittableFrame = 5;
			fallenDickFrame = 4;
			animHitFrames = [1,2,3,4,5];
			dickStartIndex = hittableFrame;
			flaccidDickFrame = 6;
			hitStartFrame = 3;

			case SMALL:
			dickGraphic = "assets/images/small_dick_6x.png";
			dxMax = 5*6 + 2*6;
			dxMin = 5*6;
			hitFrame = 2;
			hittableFrame = 4;
			fallenDickFrame = 3;
			animHitFrames = [1,2,3,4];
			dickStartIndex = hittableFrame;		
			flaccidDickFrame = 5;
			hitStartFrame = 2;				
		}

		dick = new FlxSprite(X,Y);
		dick.loadGraphic(dickGraphic,true,true,18*6,16*6,true);
		dick.animation.add("hit",animHitFrames,10,false);
		dick.animation.add("win",animHitFrames,10,true);
		dick.animation.add("erect",[dickStartIndex,dickStartIndex],10,true);
		dick.animation.add("flaccid",[flaccidDickFrame,flaccidDickFrame],10,true);				

		dick.animation.play("flaccid");

		flaccidTimer = FlxTimer.recycle();


		footstep = new FlxSound();
		footstep.loadEmbedded("assets/sounds/footstep.mp3",false);
		launch = new FlxSound();
		launch.loadEmbedded("assets/sounds/slap.mp3",false);
		slap = new FlxSound();
		slap.loadEmbedded("assets/sounds/slap.mp3",false);
		hit = new FlxSound();
		hit.loadEmbedded("assets/sounds/hit.mp3",false);
		returned = new FlxSound();
		returned.loadEmbedded("assets/sounds/dickreturned.mp3",false);
		erection = new FlxSound();
		erection.loadEmbedded("assets/sounds/erection.mp3",false);

		// dickTip = new FlxSprite(0,0);
		// dickTip.makeGraphic(1,24,0xFFFFFFFF);		
		// dickBase = new FlxSprite(0,0);
		// dickBase.makeGraphic(1,24,0xFFFFFFFF);

	}


	override public function destroy():Void
	{
		body.destroy();
		dick.destroy();

		flaccidTimer.destroy();
		

		footstep.destroy();
		slap.destroy();
		launch.destroy();
		hit.destroy();
		returned.destroy();
		erection.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		handleLimits();
		handleDickReturn();
		handleInput();

		if (dick.animation.frameIndex == hitStartFrame && !gameOver)
		{
			slap.play();
		}

		if (body.animation.frameIndex == 1)
		{
			footstep.play();
		}
	}





	private function flaccidTimerOver(t:FlxTimer):Void
	{
		if (hasDick)
		{
			dickFlaccid = false;
			dick.animation.play("erect");
			erection.play();
		}
	}


	private function handleDickReturn():Void
	{
		if (dickReturning)
		{
			dick.y = body.y;
			if (FlxCollision.pixelPerfectCheck(dick,body))
			{
				returned.play();

				dick.velocity.x = 0;
				dick.x = body.x;
				dick.facing = body.facing;

				hasDick = true;
				blewWad = false;
				dickReturning = false;
				dickFlaccid = true;
				
				if (!gameOver)
				{
					dick.animation.play("flaccid");					
					flaccidTimer.run(FLACCID_TIME,flaccidTimerOver);
				}
				else
				{
					if (winner)
					{
						dick.animation.play("win");
					}
					else
					{
						dick.animation.play("flaccid");
					}
				}
			}
		}
	}


	private function handleLimits():Void
	{
		if (body.x < X_MARGIN) body.x = X_MARGIN;
		if (body.x + body.width > FlxG.width - X_MARGIN) body.x = FlxG.width - body.width - X_MARGIN;
		if (body.y < Y_MARGIN) body.y = Y_MARGIN;
		if (body.y + body.height > FlxG.height) body.y = FlxG.height - body.height;

		if (hasDick && !blewWad)
		{
			dick.x = body.x;
			dick.y = body.y;
		}

		if (blewWad)
		{
			if (dick.velocity.x > 0 && dick.x > FlxG.width)
			{
				dick.x = 0 - dick.width;
				dickReturning = true;
			}
			else if (dick.velocity.x < 0 && dick.x + dick.width < 0)
			{
				dick.x = FlxG.width;
				dickReturning = true;
			}
		}
	}


	private function handleInput():Void
	{
		if (!inputEnabled) return;

		if (FlxG.keyboard.pressed(leftKey))
		{
			body.velocity.x = -XSPEED;
			if (hasDick) dick.velocity.x = -XSPEED;
		}
		else if (FlxG.keyboard.pressed(rightKey))
		{
			body.velocity.x = XSPEED;
			if (hasDick) dick.velocity.x = XSPEED;
		}
		else
		{
			body.velocity.x = 0;
			if (hasDick) dick.velocity.x = 0;			
		}

		if (FlxG.keyboard.pressed(upKey))
		{
			body.velocity.y = -YSPEED;
			if (hasDick) dick.velocity.y = -YSPEED;			
		}
		else if (FlxG.keyboard.pressed(downKey))
		{
			body.velocity.y = YSPEED;
			if (hasDick) dick.velocity.y = YSPEED;
		}
		else
		{
			body.velocity.y = 0;
			if (hasDick) dick.velocity.y = 0;
		}

		if (body.velocity.x != 0 || body.velocity.y != 0) 
		{
			body.animation.play("walk");
		}
		else 
		{
			body.animation.play("idle");
		}

		if (FlxG.keyboard.justPressed(attackKey))
		{
			if (!projectileDick && hasDick)
			{
				dick.animation.play("hit");
			}
			else if (projectileDick && !blewWad && hasDick && !dickFlaccid)
			{
				blewWad = true;
				hasDick = false;

				launch.play();

				if (dick.facing == FlxObject.RIGHT)
				{
					dick.velocity.x = PROJECTILE_DICK_SPEED;
					dick.velocity.y = 0;
				}
				else
				{
					dick.velocity.x = -PROJECTILE_DICK_SPEED;
					dick.velocity.y = 0;
				}
			}
		}
	}


	public function checkForHit(p:Player):Bool
	{
		// Handle projectile dicks
		if (projectileDick)
		{
			if (deadDick || p.deadDick) return false;
			if (!blewWad && !p.blewWad) return false;

			if (blewWad && !p.blewWad && FlxCollision.pixelPerfectCheck(dick,p.dick))
			{
				return true;
			}
			else if (blewWad && p.blewWad && FlxCollision.pixelPerfectCheck(dick,p.dick))
			{
				return true;
			}

			return false;
		}
		else
		{
			// Check for dicks
			if (!hasDick || !p.hasDick) return false;

			// Check for y-range
			if (Math.abs(dick.y - p.dick.y) > 2*6) return false;

			// Now check for precise x-range
			var myDickBaseX:Float = (dick.facing == FlxObject.RIGHT) ? dick.x + dick.width - dxMax : dick.x + dxMax;
			var myDickTipX:Float = (dick.facing == FlxObject.RIGHT) ? dick.x + dick.width - dxMin : dick.x + dxMin;

			var pDickBaseX:Float = (p.dick.facing == FlxObject.RIGHT) ? p.dick.x + p.dick.width - p.dxMax : p.dick.x + p.dxMax;
			var pDickTipX:Float = (p.dick.facing == FlxObject.RIGHT) ? p.dick.x + p.dick.width - p.dxMin : p.dick.x + p.dxMin;

			// Check for frames
			if (dick.animation.frameIndex == hitFrame &&
				p.dick.animation.frameIndex == p.hittableFrame)
			{
				if (dick.facing == FlxObject.RIGHT)
				{
					if ((myDickTipX > pDickTipX && myDickTipX < pDickBaseX) ||
						(pDickTipX > myDickBaseX && pDickTipX < myDickTipX))
					{
						return true;
					}
				}
				else
				{
					if ((myDickTipX < pDickTipX && myDickTipX > pDickBaseX) ||
						(pDickTipX < myDickBaseX && pDickTipX > myDickTipX))
					{
						return true;
					}				
				}
			}
			else if (dick.animation.frameIndex == hitFrame &&
				p.dick.animation.frameIndex == p.hitFrame)
			{
				if (dick.facing == FlxObject.RIGHT)
				{
					if ((myDickTipX > pDickTipX && myDickTipX < pDickBaseX) ||
						(pDickTipX > myDickBaseX && pDickTipX < myDickTipX))
					{
						return true;
					}
				}
				else
				{
					if ((myDickTipX < pDickTipX && myDickTipX > pDickBaseX) ||
						(pDickTipX < myDickBaseX && pDickTipX > myDickTipX))
					{
						return true;
					}				
				}				
			}

			return false;
		}
	}


	public function dickWasHit():Void
	{
		flaccidTimer.abort();

		hasDick = false;
		if (projectileDick) dick.x -= 2*FlxG.elapsed*dick.velocity.x;
		dick.animation.pause();
		dick.animation.frameIndex = fallenDickFrame;
		dick.velocity.x = 0;
		dick.velocity.y = 0;
		dick.y += 6*6;

		deadDick = true;

		hit.play();
	}


	public function face(Direction:Int):Void
	{
		body.facing = Direction;

		if (hasDick) dick.facing = Direction;
	}


	public function resetTo(X:Float,Y:Float):Void
	{
		body.x = X;
		body.y = Y;
		dick.x = X;
		dick.y = Y;

		hasDick = true;
		blewWad = false;
		dickFlaccid = false;
		dickReturning = false;
		deadDick = false;

		dick.animation.play("erect");
		erection.play();

		// flaccidTimer.run(FLACCID_TIME,flaccidTimerOver);
	}


	public function win():Void
	{
		winner = true;
		gameOver = true;

		if (hasDick)
		{
			body.velocity.x = body.velocity.y = 0;
			dick.velocity.x = dick.velocity.y = 0;
			dick.x = body.x;
			dick.y = body.y;
			dick.animation.play("win");			
		}
		flaccidTimer.abort();
		inputEnabled = false;

		body.animation.play("idle");
	}


	public function lose():Void
	{
		gameOver = true;

		if (hasDick)
		{
			body.velocity.x = body.velocity.y = 0;
			dick.velocity.x = dick.velocity.y = 0;
			dick.x = body.x;
			dick.y = body.y;
			dick.animation.play("flaccid");
		}		
		flaccidTimer.abort();
		inputEnabled = false;
		body.animation.play("lose");
	}

}