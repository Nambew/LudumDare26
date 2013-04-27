package ;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import haxe.Timer;
import flash.Lib;
import flash.ui.Keyboard;

using StringTools;

/**
 * ...
 * @author andre
 */

@:bitmap("gfx/level1.png") class BgLevel1 extends flash.display.BitmapData {}
 
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
	private var _player:Player;
	
	private var _textColor:TextField;
	private var _stage:Stage;
	
	private var _gravity:Float = 2.5;
	private var _physicEntites:Array<PhysicEntity>;
	
	public function new() 
	{
		Lib.current.stage.addEventListener( Event.ENTER_FRAME, gameLoop );
		
		_key = new KeyboardRegistry( Lib.current.stage );
		
		_pos = new Point( 0, 0 );
		_player = new Player();
		_player.setPosition( 20, 140 );
		
		_scene = new Scene( 600, 400 );
		_scene.setBackground( new BgLevel1( 0, 0 ) );
		_scene.setPlayer( _player );
		
		_physicEntites = new Array<PhysicEntity>();
		_physicEntites.push( _player );
		
		_stage = Lib.current.stage;
		
		_stage.addChild( _scene );
		
		_textColor = new TextField();
		_textColor.textColor = 0;
		_textColor.x = _stage.width - 100;
		_textColor.y = _stage.height - 50;
		_textColor.text = "Color:";
		
		_stage.addChild( _textColor );
		
	}
	
	private function isPlayerStealth():Bool {
		return _scene.checkColorRegion( _player.getParentBounds(), _player.getColor() );
	}
	
	public function start():Void {
		_key.activate();
	}
	
	private function updateText():Void {
		_textColor.text = "Color:" + StringTools.hex( _player.getColor(), 6 );
	}
	
	private function gameLoop( e:Event ):Void {
		
		if ( _key.isDown( Keyboard.LEFT ) ) {
			_player.moveLeft( 3 );
		} else if ( _key.isDown( Keyboard.RIGHT ) ) {
			_player.moveRight( 3 );
		}
		
		if ( _key.isToggle( Keyboard.A ) ) {
			
			_player.addRed();
			updateText();
		} else if ( _key.isToggle( Keyboard.Z ) ) {
			_player.removeRed();
			updateText();
		}
		
		if ( _key.isToggle( Keyboard.S ) ) {
			_player.addGreen();
			updateText();
		} else if ( _key.isToggle( Keyboard.X ) ) {
			_player.removeGreen();
			updateText();
		}
		
		if ( _key.isToggle( Keyboard.D ) ) {
			_player.addBlue();
			updateText();
		} else if ( _key.isToggle( Keyboard.C ) ) {
			_player.removeBlue();
			updateText();
		}
		
		resolvePhysic();
		
		_scene.refresh();
		
		if ( isPlayerStealth() ) {
			
		}
		
	}
	
	private function resolvePhysic():Void {
		var pos:IntPoint;
		var bound:Rectangle;
		var checkRegion:Rectangle = new Rectangle(0, 0, 0, 1);
		var impulse:Float;
		var projectedPosition:IntPoint;
		var currentPosition:IntPoint;
		
		for ( entity in _physicEntites ) {
			
			if ( entity.isGravitable() ) {
				pos = entity.getPosition();
				bound = entity.getBound();
				checkRegion.x = pos.x;
				checkRegion.y = pos.y;
				checkRegion.width = bound.width;
				
				if( _scene.isFloor( checkRegion ) ) {
					entity.grounded();
				} else {
					entity.fall();
					
				
					
					
				}
				
			}
		}
	}
	
}