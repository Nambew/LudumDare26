package ;
import flash.display.DisplayObject;
import flash.events.KeyboardEvent;
import haxe.ds.IntMap;

/**
 * ...
 * @author andre
 */
class KeyboardRegistry
{
	private var _pressKeys:IntMap<Bool>;
	private var _target:DisplayObject;
	private var _activate:Bool;
	
	public function new( target:DisplayObject ) 
	{
		_target = target;
		_pressKeys = new IntMap<Bool>();
		_activate = false;
	}
	
	public function isDown( code:Int ):Bool {
		return _pressKeys.exists( code );
	}
	
	public function isUp( code:Int ):Bool {
		return !_pressKeys.exists( code );
	}
	
	public function activate():Void {
		if ( !_activate ) {
			_target.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			_target.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			_activate = true;
		}
	}
	
	public function deactivate():Void {
		if ( _activate ) {
			_target.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			_target.removeEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			_activate = false;
		}
	}
	
	private function onKeyDown( e:KeyboardEvent ):Void {
		_pressKeys.set( e.keyCode, true );
	}
	
	private function onKeyUp( e:KeyboardEvent ):Void {
		_pressKeys.remove( e.keyCode );
	}
	
	
}