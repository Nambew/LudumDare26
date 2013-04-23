package ;
import haxe.Timer;
import flash.Lib;
import flash.ui.Keyboard;

/**
 * ...
 * @author andre
 */
class Game
{
	private static var _framerate:Int = 40;
	private var _timer:Timer;
	private var _key:KeyboardRegistry;
	
	public function new() 
	{
		_timer = new Timer(Math.round( 1000/_framerate) );
		_timer.run = gameLoop;
		
		_key = new KeyboardRegistry( Lib.current.stage );
		
	}
	
	public function start():Void {
		_key.activate();
	}
	
	private function gameLoop():Void {
		if ( _key.isDown( Keyboard.LEFT ) ) {
			trace( "left" );
		}
	}
	
}