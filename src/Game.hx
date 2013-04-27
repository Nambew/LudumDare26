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
	private var _textFPS:TextField;
	private var _stage:Stage;
	
	private var _gravity:Float = 0.5;
	private var _physicEntites:Array<PhysicEntity>;
	private var _ftpsTime:Int;
	private var _frameCount:Int = 0;
	
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
		_textColor.border = true;
		_textColor.x = _stage.width - 100;
		_textColor.y = _stage.height - 70;
		_textColor.height = 20;
		_textColor.width = 100;
		_textColor.text = "Color:";
		
		_stage.addChild( _textColor );
		
		_textFPS = new TextField();
		_textFPS.textColor = 0;
		_textFPS.border = true;
		_textFPS.height = 20;
		_textFPS.width = 100;
		_textFPS.x = _stage.width - 100;
		_textFPS.y = _stage.height - 30;
		_textFPS.text = "FPS:";
		
		_stage.addChild( _textFPS );
	}
	
	private function isPlayerStealth():Bool {
		return _scene.checkColorRegion( _player.getParentBounds(), _player.getColor() );
	}
	
	public function start():Void {
		_ftpsTime = flash.Lib.getTimer();
		_frameCount = 0;
		_key.activate();
	}
	
	private function updateText():Void {
		_textColor.text = "Color:" + StringTools.hex( _player.getColor(), 6 );
	}
	
	private function gameLoop( e:Event ):Void {
		
		_player.stop();
		
		if ( _key.isDown( Keyboard.LEFT ) ) {
			_player.moveLeft( 1 );
			_player.walk();
		} else if ( _key.isDown( Keyboard.RIGHT ) ) {
			_player.moveRight( 1 );
			_player.walk();
		}
		
		if ( !_player.isWalking() ) {
			_player.setXSpeed( 0 );
		}
		
		if ( !_player.isJumping() && _key.isDown( Keyboard.UP ) ) {
			_player.jump();
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
		
		if ( isPlayerStealth() ) {
			
		}
		
		resolvePhysic();
		
		_scene.refresh();
		
		
		
		var currentTime:Float = ( Lib.getTimer() - _ftpsTime ) / 1000;
		_frameCount++;
		
		if( currentTime > 1. ) {
			_textFPS.text = "FPS:" + ( _frameCount / currentTime );
			_frameCount = 0;
			_ftpsTime = Lib.getTimer();
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
			pos = entity.getPosition();
			bound = entity.getBound();
			
			if ( entity.isGravitable() ) {
				
				
				checkRegion.x = pos.x;
				checkRegion.y = pos.y;
				checkRegion.width = bound.width;
				
				if ( _scene.isFloor( checkRegion ) ) {
					if( entity.isFalling() ) {
						entity.grounded();
					}
				} else if( entity.isGrounded() ) {
					entity.fall();
				}
				
				if ( entity.isFalling() || entity.isJumping() ) {
					entity.setYSpeed( entity.getYSpeed() + _gravity );
				}
				
			}
			
			resolveCollision( entity );
			
		}
	}
	
	private function resolveCollision( entity:PhysicEntity ):Void {
		var pos:IntPoint = entity.getPosition();
		var bound:Rectangle = entity.getBound();
		var moveVector:IntPoint = new IntPoint( Math.floor( entity.getXSpeed() ),  Math.floor( entity.getYSpeed() ) );
		
		//bottom collision
		if( moveVector.y > 0 ) {
			var leftFoot:Int = _scene.getFloorDistance( pos );
			var rightFoot:Int = _scene.getFloorDistance( new IntPoint( pos.x + Math.round( bound.width ), pos.y ) );
			
			//entity.setPosition( pos.x + Math.round( entity.getXSpeed() ), pos.y + Math.round( entity.getYSpeed() ) );
			
			var smallest:Int = Math.round( Math.min( leftFoot, rightFoot ) );
			
			if ( smallest < 0 ) {
				//entity.setPosition( pos.x, entity.getPosition().y + smallest );
			}
		// up collision
		} else if ( moveVector.y < 0 ) {
			
		}
		
		if ( moveVector.x < 0 ) {
			var top:Int = pos.y - Math.floor( bound.height );
			var bottom:Int = pos.y;
			var topDist:Int = moveVector.x;
			var bottomDist:Int = moveVector.x;
			
			while ( _scene.isCollision( pos.x + bottomDist, bottom ) && bottomDist < 0 ) {
				bottomDist++;
				entity.setXSpeed( 0 );
			}
			
			while ( _scene.isCollision( pos.x + topDist, top ) && topDist < 0 ) {
				topDist++;
				entity.setXSpeed( 0 );
			}
			
			moveVector.x = Math.round( Math.max( bottomDist, topDist ) );
			
			entity.setPosition( pos.x + moveVector.x, pos.y );
		} else if ( moveVector.x > 0 ) {
			var top:Int = pos.y - Math.floor( bound.height );
			var width:Int = Math.floor( bound.width ) - 1;
			var bottom:Int = pos.y;
			var topDist:Int = moveVector.x;
			var bottomDist:Int = moveVector.x;
			
			while ( _scene.isCollision( pos.x + width + bottomDist, bottom ) && bottomDist > 0 ) {
				bottomDist--;
				entity.setXSpeed( 0 );
			}
			
			while ( _scene.isCollision( pos.x + width + topDist, top ) && topDist > 0 ) {
				topDist--;
				entity.setXSpeed( 0 );
			}
			
			moveVector.x = Math.round( Math.min( bottomDist, topDist ) );
			
			entity.setPosition( pos.x + moveVector.x, pos.y );
		}
	}
	
}