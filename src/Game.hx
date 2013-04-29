package ;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
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

@:bitmap("gfx/title.png") class TitleScreen extends flash.display.BitmapData {}
@:bitmap("gfx/gameover.png") class GameOverScreen extends flash.display.BitmapData {}
@:bitmap("gfx/success.png") class SuccessScreen extends flash.display.BitmapData {}

 
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
	private var _enemies:Array<Enemy>;
	
	private var _textColor:TextField;
	private var _textFPS:TextField;
	private var _textStealth:TextField;
	private var _stage:Stage;
	
	private var _gravity:Float = 0.5;
	private var _physicEntites:Array<PhysicEntity>;
	private var _ftpsTime:Int;
	private var _frameCount:Int = 0;
	private var _stealthMode:Bool = false;
	private var _goal:Rectangle;
	private var _contener:Sprite;
	private var _screen:Sprite;
	private var _currentLevel:Level;
	private var _levels:Array<Level>;
	
	public function new( stage:Stage ) 
	{
		_stage = stage;
		_contener = new Sprite();
		_screen = new Sprite();
		_stage.addChild( _contener );
		_stage.addChild( _screen );
		
		_levels = new Array<Level>();
		_levels.push( new Level1() );
		_levels.push( new Level2() );
		_levels.push( new Level3() );
		
		_currentLevel = _levels.shift();
		
		_key = new KeyboardRegistry( _stage );
		
		_pos = new Point( 0, 0 );
		_player = new Player();
		
		
		_enemies = new Array<Enemy>();
		
		_scene = new Scene( 600, 400 );
		
		_scene.setPlayer( _player );
		
		_physicEntites = new Array<PhysicEntity>();
		
		_contener.addChild( _scene );
		
		#if debugmode
			_textColor = new TextField();
			_textColor.textColor = 0;
			_textColor.border = true;
			_textColor.x = _stage.stageWidth + 20;
			_textColor.y = _stage.stageHeight - 70;
			_textColor.height = 20;
			_textColor.width = 100;
			_textColor.text = "Color:";
			
			_contener.addChild( _textColor );
			
			_textFPS = new TextField();
			_textFPS.textColor = 0;
			_textFPS.border = true;
			_textFPS.height = 20;
			_textFPS.width = 100;
			_textFPS.x = _stage.stageWidth + 20;
			_textFPS.y = _stage.stageHeight - 30;
			_textFPS.text = "FPS:";
			
			_contener.addChild( _textFPS );
			
			_textStealth = new TextField();
			_textStealth.textColor = 0;
			_textStealth.border = true;
			_textStealth.height = 20;
			_textStealth.width = 100;

			_textStealth.x = _stage.stageWidth + 20;
			_textStealth.y = _stage.stageHeight - 100;
			_textStealth.text = "Stealth:";
			
			_contener.addChild( _textStealth );
		#end
		
		
		
		showTitleScreen();
	}
	
	private function isPlayerStealth():Bool {
		return _scene.checkColorRegion( _player.getParentBounds(), _player.getColor() );
	}
	
	public function start():Void {
		reset();
		_stage.addEventListener( Event.ENTER_FRAME, gameLoop );
		_ftpsTime = flash.Lib.getTimer();
		_frameCount = 0;
		_key.activate();
	}
	
	public function end( success:Bool ):Void {
		_stage.removeEventListener( Event.ENTER_FRAME, gameLoop );
		_key.deactivate();
		
		if ( success ) {
			if ( _levels.length == 0 ) {
				showSuccess();
			} else {
				_currentLevel = _levels.shift();
				start();
			}
			
		} else {
			showGameOver();
		}
	}
	
	private function reset():Void {
		_scene.setBackground( _currentLevel.getBackground() );
		_player.setPosition( _currentLevel.getPlayerPosition().x, _currentLevel.getPlayerPosition().y );
		_scene.reset();
		_player.reset();
		
		_goal = _currentLevel.getGoal();
		
		_physicEntites = new Array<PhysicEntity>();
		_enemies = new Array<Enemy>();
		
		_physicEntites.push( _player );
		
		for ( enemyData in _currentLevel.getEnemies() ) {
			_enemies.push( new Enemy( enemyData.start.clone(), _scene, enemyData.end.clone() ) );
		}
		
		for( enemy in _enemies ) {
			_scene.addEnemy( enemy );
			_physicEntites.push( enemy );
		}
		
		_key.clear();
	}
	
	private function retry():Void {
		start();
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
		
		if ( !_player.isJumping() && ( _key.isDown( Keyboard.UP ) ||  _key.isDown( Keyboard.SPACE ) ) ) {
			_player.jump();
		}
		
		if ( _key.isToggle( Keyboard.A ) ) {
			_player.addColor();
			#if debugmode
				updateText();
			#end
		}
		
		if ( _key.isToggle( Keyboard.S ) ) {
			_player.removeColor();
			#if debugmode
				updateText();
			#end
		}
		
		_stealthMode = isPlayerStealth();
		
		#if debugmode
			if ( _stealthMode ) {	
				_textStealth.text = "Stealth: YES"; 
			} else {
				_textStealth.text = "Stealth: NO"; 
			}
		#end
		
		resolveIA();
		
		resolvePhysic();
		
		_scene.refresh();
		
		if ( !_stealthMode && gameIsOver() ) {
			end( false );
		} else if ( checkGoal() ) {
			end( true );
		}

		
		#if debugmode
			var currentTime:Float = ( Lib.getTimer() - _ftpsTime ) / 1000;
			_frameCount++;
			
			if( currentTime > 1. ) {
				_textFPS.text = "FPS:" + ( _frameCount / currentTime );
				_frameCount = 0;
				_ftpsTime = Lib.getTimer();
			}
		#end
		
	}
	
	private function resolveIA():Void {
		for ( ennemy in _enemies ) {
			if ( ennemy.isActive() ) {
				ennemy.ia( _stealthMode, _player.getPosition(), new IntPoint( _player.getWidth(), _player.getHeight() ) );
			}
		}
	}
	
	private function gameIsOver():Bool {
		var dim:Rectangle;
		var playerRect:Rectangle = _player.getBound().clone();
		playerRect.y = _player.getPosition().y - playerRect.height;
		playerRect.x = _player.getPosition().x;
		
		for ( enemy in _enemies ) {
			dim = enemy.getBound().clone();
			dim.y = enemy.getPosition().y - dim.height;
			dim.x = enemy.getPosition().x;
			
			if ( dim.intersects( playerRect ) )
				return true;
		}
		
		return false;
	}
	
	private function checkGoal():Bool {
		var playerRect:Rectangle = _player.getBound().clone();
		playerRect.y = _player.getPosition().y - playerRect.height;
		playerRect.x = _player.getPosition().x;
		
		return _goal.intersects( playerRect );
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
			
			entity.setCollision( resolveCollision( entity ) );
			
		}
	}
	
	private function resolveCollision( entity:PhysicEntity ):IntPoint {
		var pos:IntPoint = entity.getPosition();
		var bound:Rectangle = entity.getBound();
		var moveVector:IntPoint = new IntPoint( Math.floor( entity.getXSpeed() ),  Math.floor( entity.getYSpeed() ) );
		var collisionVector:IntPoint = new IntPoint( 0, 0 );
		
		//bottom collision
		if( moveVector.y > 0 ) {
			var leftFoot:Int = pos.x;
			var rightFoot:Int = pos.x + Math.ceil( bound.width ) - 3;
			var leftDist:Int = moveVector.y;
			var rightDist:Int = moveVector.y;
			
			while ( _scene.isCollision( leftFoot, pos.y + leftDist ) && leftDist > 0 ) {
				leftDist--;
				entity.grounded();
				collisionVector.y = 1;
			}
			
			while ( _scene.isCollision( rightFoot, pos.y + rightDist ) && rightDist > 0 ) {
				rightDist--;
				entity.grounded();
				collisionVector.y = 1;
			}
			
			moveVector.y = Math.round( Math.min( leftDist, rightDist ) );
			
		// up collision
		} else if ( moveVector.y < 0 ) {
			var leftTop:Int = pos.x;
			var righTop:Int = pos.x + Math.ceil( bound.width ) - 3;
			var leftDist:Int = moveVector.y;
			var rightDist:Int = moveVector.y;
			
			while ( _scene.isCollision( leftTop, pos.y -  Math.ceil( bound.height ) + leftDist ) && leftDist < 0 ) {
				leftDist++;
				entity.setYSpeed( 0 );
				collisionVector.y = -1;
			}
			
			while ( _scene.isCollision( righTop, pos.y -  Math.ceil( bound.height ) + rightDist ) && rightDist < 0 ) {
				rightDist++;
				entity.setYSpeed( 0 );
				collisionVector.y = -1;
			}
			
			moveVector.y = Math.round( Math.max( leftDist, rightDist ) );
		}
		
		//left
		if ( moveVector.x < 0 ) {
			var top:Int = pos.y - Math.floor( bound.height );
			var bottom:Int = pos.y;
			var middle:Int = pos.y - Math.floor( bound.height / 2 );
			var topDist:Int = moveVector.x;
			var bottomDist:Int = moveVector.x;
			var middleDist:Int = moveVector.x;
			
			while ( _scene.isCollision( pos.x + bottomDist, bottom ) && bottomDist < 0 ) {
				bottomDist++;
				entity.setXSpeed( 0 );
				collisionVector.x = -1;
			}
			
			while ( _scene.isCollision( pos.x + topDist, top ) && topDist < 0 ) {
				topDist++;
				entity.setXSpeed( 0 );
				collisionVector.x = -1;
			}
			
			while ( _scene.isCollision( pos.x + middleDist, middle ) && middleDist < 0 ) {
				middleDist++;
				entity.setXSpeed( 0 );
				collisionVector.x = -1;
			}
			
			moveVector.x = Math.round( Math.max( middleDist, Math.max( bottomDist, topDist ) ) );
		//right
		} else if ( moveVector.x > 0 ) {
			var top:Int = pos.y - Math.floor( bound.height );
			var width:Int = Math.floor( bound.width ) - 1;
			var bottom:Int = pos.y;
			var middle:Int = pos.y - Math.floor( bound.height / 2 );
			var topDist:Int = moveVector.x;
			var bottomDist:Int = moveVector.x;
			var middleDist:Int = moveVector.x;
			
			while ( _scene.isCollision( pos.x + width + bottomDist, bottom ) && bottomDist > 0 ) {
				bottomDist--;
				entity.setXSpeed( 0 );
				collisionVector.x = 1;
			}
			
			while ( _scene.isCollision( pos.x + width + topDist, top ) && topDist > 0 ) {
				topDist--;
				entity.setXSpeed( 0 );
				collisionVector.x = 1;
			}
			
			while ( _scene.isCollision( pos.x + width + middleDist, middle ) && middleDist > 0 ) {
				middleDist--;
				entity.setXSpeed( 0 );
				collisionVector.x = 1;
			}
			
			moveVector.x = Math.round( Math.min( middleDist, Math.min( bottomDist, topDist ) ) );
		}
		
		entity.setPosition( pos.x + moveVector.x, pos.y + moveVector.y );
		
		return collisionVector;
	}
	
	private function showTitleScreen():Void {
		var bmp:Bitmap = new Bitmap( new TitleScreen( 0, 0 ) );
		_screen.addChild( bmp );
		
		_stage.addEventListener( MouseEvent.CLICK, onClickTitle );
	}
	
	private function onClickTitle( e:MouseEvent ):Void {
		_stage.removeEventListener( MouseEvent.CLICK, onClickTitle );
		_screen.removeChildAt( 0 );
		start();
	}
	
	private function showGameOver():Void {
		var bmp:Bitmap = new Bitmap( new GameOverScreen( 0, 0 ) );
		_screen.addChild( bmp );
		
		_stage.addEventListener( MouseEvent.CLICK, onClickRetry );
	}
	
	private function onClickRetry( evt:MouseEvent ):Void {
		_stage.removeEventListener( MouseEvent.CLICK, onClickRetry );
		_screen.removeChildAt( 0 );
		retry();
	}
	
	private function showSuccess():Void {
		var bmp:Bitmap = new Bitmap( new SuccessScreen( 0, 0 ) );
		_screen.addChild( bmp );
	}
	
}