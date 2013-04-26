package ;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.Timer;
import flash.Lib;
import flash.ui.Keyboard;

/**
 * ...
 * @author andre
 */

@:bitmap("gfx/map.png") class GfxBg extends flash.display.BitmapData {}
 
class Game
{
	private static var _framerate:Int = 40;
	private var _timer:Timer;
	private var _key:KeyboardRegistry;
	
	private var _render:Bitmap;
	private var _bmd:BitmapData;
	private var _pos:Point;
	private var _bg:BitmapData;
	
	private var _scene:Scene;
	
	public function new() 
	{
		Lib.current.stage.addEventListener( Event.ENTER_FRAME, gameLoop );
		
		_key = new KeyboardRegistry( Lib.current.stage );
		
		_pos = new Point( 0, 0 );
		
		_scene = new Scene( 600, 400 );
		_scene.setBackground( new GfxBg( 0, 0 ) );
		
		Lib.current.stage.addChild( _scene );
	}
	
	public function start():Void {
		_key.activate();
	}
	
	private function gameLoop( e:Event ):Void {
		
		
		
		if ( _key.isDown( Keyboard.LEFT ) ) {
			_scene.translateCamera( -5, 0 );
		} else if ( _key.isDown( Keyboard.RIGHT ) ) {
			_scene.translateCamera( 5, 0 );
		}
		
		if ( _key.isDown( Keyboard.UP ) ) {
			_scene.translateCamera( 0, -5 );
		} else if ( _key.isDown( Keyboard.DOWN ) ) {
			_scene.translateCamera( 0, 5 );
		}
		
		_scene.refresh();
	}
	
}