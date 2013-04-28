package ;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author andre
 */
class Ennemy implements PhysicEntity
{
	private static var _bitmapData:BitmapData;
	
	private var _position:IntPoint;
	private var _isGrounded:Bool;
	private var _isJumping:Bool;
	private var _walking:Bool;
	
	private var _active:Bool;
	private var _dim:Rectangle;
	
	private var _maxSpeed:Float = 3;
	private var _xSpeed:Float = 0;
	private var _ySpeed:Float = 0;
	private var _jumpSpeed:Float = 6;
	
	private var _startPos:IntPoint;
	private var _endPos:IntPoint;
	private var _targetPos:IntPoint;
	
	private var _waitTime:Int = 0;
	private var _collision:IntPoint;
	private var _pursuitMode:Bool;
	
	private var _scene:Scene;
	
	public function new( startPos:IntPoint, scene:Scene, endPos:IntPoint ) 
	{
		_collision = new IntPoint(0, 0);
		_startPos = startPos.clone();
		_endPos = endPos;
		_targetPos = _endPos.clone();
		_scene = scene;
		
		_position = startPos;
		_active = false;
		_dim = new Rectangle( 0, 0, 32, 26 );
		_pursuitMode = false;
	}
	
	/* INTERFACE PhysicEntity */
	
	public function activate():Void {
		_active = true;
		
		draw();
	}
	
	private function draw():Void {
		if( _bitmapData == null ) {
			_bitmapData = new BitmapData( Math.floor( _dim.width ), Math.round(_dim.height ), true, 0x00000000 );
			_bitmapData.fillRect( new Rectangle(0, 0, 32, 10 ), 0xFF999999 );
			_bitmapData.fillRect( new Rectangle(8, 10, 16, 14 ), 0xFF999999 );
			_bitmapData.fillRect( new Rectangle(0, 14, 32, 10 ), 0xFF999999 );
		}
	}
	
	public function deactivate():Void {
		_active = false;
		_bitmapData = null;
	}
	
	public function isActive():Bool {
		return _active;
	}
	
	public function ia( stealth:Bool, playerPos:IntPoint, playerSize:IntPoint ):Void {
		var playerDistance:Float = Math.sqrt( Math.pow( _position.x - playerPos.x, 2 ) + Math.pow( _position.y - playerPos.y, 2 ) );
		var playerTooFar:Bool = ( playerDistance > 200 ) ;
		var playerVisible:Bool = false;
		if ( !playerTooFar && !stealth ) {
			playerVisible = _scene.rayCast( new IntPoint( _position.x + Math.round( _dim.width / 2 ), _position.y - Math.round( _dim.height / 2 ) )
						, new IntPoint( playerPos.x + Math.round( playerSize.x / 2 ), playerPos.y - Math.round( playerSize.y / 2 ) ) );
		}
		
		if ( stealth || playerTooFar || !playerVisible ) {
			if ( _pursuitMode ) {
				_targetPos = _startPos.clone();
			}
			
			_pursuitMode = false;
		} else if( !stealth && !playerTooFar && playerVisible ) {
			_pursuitMode = true;
		}
		
		if ( _pursuitMode ) {
			if ( _position.x > playerPos.x ) {
				setXSpeed( _xSpeed - 1 );
			} else if ( _position.x < playerPos.x ) {
				setXSpeed( _xSpeed + 1 );
			} else {
				_xSpeed = 0;
			}
			
			if ( _collision.x != 0 && playerPos.y < _position.y ) {
				this.jump();
			}
		} else {
			if ( _waitTime > 0 ) {
				_waitTime--;
			} else {
				var dist:Float =  Math.sqrt( Math.pow( _position.x - _targetPos.x, 2 ) + Math.pow( _position.y - _targetPos.y, 2 ) );
				
				if ( dist <= 5 ) {
					_waitTime = 50;
					_xSpeed = 0;
					_ySpeed = 0;
					
					if ( _targetPos.equal( _startPos ) ) {
						_targetPos = _endPos.clone();
					} else {
						_targetPos = _startPos.clone();
					}
					
				} else {
					if ( _position.x > _targetPos.x ) {
						setXSpeed( _xSpeed - 1 );
					} else if ( _position.x < _targetPos.x ) {
						setXSpeed( _xSpeed + 1 );
					} else {
						_xSpeed = 0;
					}
					
					if ( _collision.x != 0 && _targetPos.y < _position.y ) {
						this.jump();
					}
				}
				
			}
			
		}
		
		
	}
	
	public function getBitmapData():BitmapData {
		return _bitmapData;
	}
	
	public function getPosition():IntPoint 
	{
		return _position;
	}
	
	public function setPosition(x:UInt, y:UInt):Void 
	{
		_position.x = x;
		_position.y = y;
	}
	
	public function getBound():Rectangle 
	{
		return _dim;
	}
	
	public function isGrounded():Bool 
	{
		return _isGrounded;
	}
	
	public function isFalling():Bool 
	{
		return !_isGrounded;
	}
	
	public function isJumping():Bool 
	{
		return _isJumping;
	}
	
	public function jump():Void {
		_isJumping = true;
		_ySpeed = -_jumpSpeed;
	}
	
	public function grounded():Void 
	{
		_isGrounded = true;
		_isJumping = false;
		_ySpeed = 0;
	}
	
	public function fall():Void 
	{
		_isGrounded = false;
	}
	
	public function isGravitable():Bool 
	{
		return true;
	}
	
	public function getYSpeed():Float 
	{
		return _ySpeed;
	}
	
	public function setYSpeed(v:Float):Void 
	{
		_ySpeed = v;
	}
	
	public function getXSpeed():Float 
	{
		return _xSpeed;
	}
	
	public function setXSpeed(v:Float):Void 
	{
		_xSpeed = v;
		
		if ( v < 0 && _xSpeed < -_maxSpeed ) _xSpeed = -_maxSpeed;
		else if ( v > 0 && _xSpeed > _maxSpeed ) _xSpeed = _maxSpeed;
	}
	
	public function isWalking():Bool 
	{
		return _walking;
	}
	
	public function walk():Void 
	{
		_walking = true;
	}
	
	public function stop():Void 
	{
		_walking = false;
	}
	
	public function getTopLeftCorner():Point {
		return new Point( _position.x, _position.y - _dim.height );
	}
	
	public function setCollision( v:IntPoint ):Void {
		_collision = v;
	}
	
}