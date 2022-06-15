import flixel.system.FlxPreloader;
import flixel.text.FlxText;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.text.TextField;
import flash.text.TextFormat;


@:bitmap("assets/images/preloader/loading.png") 
class LoadingBitmapData extends flash.display.BitmapData {}

@:bitmap("assets/images/preloader/loaded.png") 
class LoadedBitmapData extends flash.display.BitmapData {}

@:bitmap("assets/images/preloader/click.png") 
class ClickBitmapData extends flash.display.BitmapData {}


class Preloader extends FlxPreloader
{


	private var _bg:Bitmap;
	private var _loadingText:Bitmap;
	private var _loadedText:Bitmap;
	private var _clickText:Bitmap;
	private var _loadingBar:Bitmap;


	override private function create():Void
	{
		_min = 6000000;

		_buffer = new Sprite();
		addChild(_buffer);

		_bg = new Bitmap(new BitmapData(640,480,false,0x000000));
		_bg.x = 0; _bg.y = 0;

		_buffer.addChild(_bg);

		_loadingText = new Bitmap(new LoadingBitmapData(0,0));
		_loadingText.x = stage.stageWidth / 2 - _loadingText.width / 2;
		_loadingText.y = stage.stageHeight / 2 - _loadingText.height;
		
		_buffer.addChild(_loadingText);

		_loadedText = new Bitmap(new LoadedBitmapData(0,0));
		_loadedText.x = stage.stageWidth / 2 - _loadedText.width / 2;
		_loadedText.y = stage.stageHeight / 2 - _loadedText.height;
		_loadedText.visible = false;

		_buffer.addChild(_loadedText);

		_loadingBar = new Bitmap(new BitmapData(1,4,false,0xFFFFFF));
		_loadingBar.x = 0;
		_loadingBar.y = _loadingText.y + _loadingText.height;

		_buffer.addChild(_loadingBar);

		_clickText = new Bitmap(new ClickBitmapData(0,0));
		_clickText.x = stage.stageWidth / 2 - _clickText.width / 2;
		_clickText.y = _loadingBar.y + 10;
		_clickText.visible = false;

		_buffer.addChild(_clickText);

	}


	override private function update(Percent:Float):Void
	{
		var ActualPercent:Float = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
		_loadingBar.scaleX = ActualPercent * (stage.stageWidth + 10);

		if (ActualPercent >= 1.0 && !_loadedText.visible)
		{
			_loadingText.visible = false;
			_loadedText.visible = true;
			_clickText.visible = true;
			stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN,mouseDown);
		}
	}


	private function mouseDown(e:flash.events.MouseEvent):Void 
	{
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN,mouseDown);
		_min = 1000;
		stage.focus = null;
	}


}
