package nme;


import openfl.Assets;


class AssetData {

	
	public static var className = new #if haxe3 Map <String, #else Hash <#end Dynamic> ();
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();
	
	private static var initialized:Bool = false;
	
	
	public static function initialize ():Void {
		
		if (!initialized) {
			
			className.set ("assets/data/data-goes-here.txt", nme.NME_assets_data_data_goes_here_txt);
			type.set ("assets/data/data-goes-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			className.set ("assets/images/bg.png", nme.NME_assets_images_bg_png);
			type.set ("assets/images/bg.png", Reflect.field (AssetType, "image".toUpperCase ()));
			className.set ("assets/images/big_dick.png", nme.NME_assets_images_big_dick_png);
			type.set ("assets/images/big_dick.png", Reflect.field (AssetType, "image".toUpperCase ()));
			className.set ("assets/images/big_dick_6x.png", nme.NME_assets_images_big_dick_6x_png);
			type.set ("assets/images/big_dick_6x.png", Reflect.field (AssetType, "image".toUpperCase ()));
			className.set ("assets/images/medium_dick.png", nme.NME_assets_images_medium_dick_png);
			type.set ("assets/images/medium_dick.png", Reflect.field (AssetType, "image".toUpperCase ()));
			className.set ("assets/images/medium_dick_6x.png", nme.NME_assets_images_medium_dick_6x_png);
			type.set ("assets/images/medium_dick_6x.png", Reflect.field (AssetType, "image".toUpperCase ()));
			className.set ("assets/images/medium_dick_hit.png", nme.NME_assets_images_medium_dick_hit_png);
			type.set ("assets/images/medium_dick_hit.png", Reflect.field (AssetType, "image".toUpperCase ()));
			className.set ("assets/images/walk.png", nme.NME_assets_images_walk_png);
			type.set ("assets/images/walk.png", Reflect.field (AssetType, "image".toUpperCase ()));
			className.set ("assets/images/walk_6x.png", nme.NME_assets_images_walk_6x_png);
			type.set ("assets/images/walk_6x.png", Reflect.field (AssetType, "image".toUpperCase ()));
			className.set ("assets/music/music-goes-here.txt", nme.NME_assets_music_music_goes_here_txt);
			type.set ("assets/music/music-goes-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			className.set ("assets/sounds/sounds-go-here.txt", nme.NME_assets_sounds_sounds_go_here_txt);
			type.set ("assets/sounds/sounds-go-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			
			
			initialized = true;
			
		}
		
	}
	
	
}


class NME_assets_data_data_goes_here_txt extends flash.utils.ByteArray { }
class NME_assets_images_bg_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_images_big_dick_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_images_big_dick_6x_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_images_medium_dick_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_images_medium_dick_6x_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_images_medium_dick_hit_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_images_walk_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_images_walk_6x_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_music_music_goes_here_txt extends flash.utils.ByteArray { }
class NME_assets_sounds_sounds_go_here_txt extends flash.utils.ByteArray { }
