package ;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author andre
 */
class Player implements PhysicEntity
{

	private var _position:IntPoint;
	private var _isGrounded:Bool;
	private var _isJumping:Bool;
	private var _walking:Bool;
	
	private var _bitmapData:BitmapData;
	private var _border:BitmapData;
	private var _dim:Rectangle;
	
	private var _maxSpeed:Float = 3;
	private var _xSpeed:Float = 0;
	private var _ySpeed:Float = 0;
	private var _jumpSpeed:Float = 8;
	
	private var _colorIndex:Int = 12;
	private var _colors:Array<UInt>;
	
	public function new() 
	{
		grounded();
		
		_dim = new Rectangle(0, 0, 16, 26 );
		_position = new IntPoint( 0, 0 );
		
		_colors = new Array<UInt>();
		
		var tpColor:UInt = 0;
		
		for ( r in 0...3 ) {
			for ( g in 0...3 ) {
				for ( b in 0...3 ) {
					switch( r ) {
						case 0:
							tpColor = 0;
						case 1:
							tpColor = 0x770000;
						case 2:
							tpColor = 0xFF0000;
					}
					
					switch( g ) {
						case 1:
							tpColor += 0x7700;
						case 2:
							tpColor += 0xFF00;
					}
					
					switch( b ) {
						case 1:
							tpColor += 0x77;
						case 2:
							tpColor += 0xFF;
					}
					
					if ( tpColor != 0xFFFFFF && tpColor != 0 ) {
						_colors.push( tpColor );
					}
				}
			}
		}
		
		
		_bitmapData = new BitmapData( Math.floor( _dim.width ), Math.floor( _dim.height ), true, getColor() + 0xFF000000 );
		_border = new BitmapData( Math.floor( _dim.width ), Math.floor( _dim.height ), true, 0 );
		
		drawBorder();
	}
	
	private function drawBorder():Void {
		
		
		for ( x in 0...Math.floor( _dim.width ) ) {
			_bitmapData.setPixel( x, 0, 0xFF000000 );
		}
		
		for ( y in 0...Math.floor( _dim.height ) ) {
			_bitmapData.setPixel( Math.floor( _dim.width ) - 1, y, 0xFF000000 );
		}
		
		for ( x in 0...Math.floor( _dim.width ) ) {
			_bitmapData.setPixel( x, Math.floor( _dim.height ) - 1, 0xFF000000 );
		}
		
		for ( y in 0...Math.floor( _dim.height ) ) {
			_bitmapData.setPixel( 0, y, 0xFF000000 );
		}
		
	}
	
	public function getBitmapData():BitmapData {
		return _bitmapData;
	}
	
	public function isGrounded():Bool {
		return _isGrounded;
	}
	
	public function isFalling():Bool {
		return !_isGrounded;
	}
	
	public function isJumping():Bool {
		return _isJumping;
	}
	
	public function isWalking():Bool {
		return _walking;
	}
	
	public function walk():Void {
		_walking = true;
	}
	
	public function stop():Void {
		_walking = false;
	}
	
	public function jump():Void {
		_isJumping = true;
		_ySpeed = -_jumpSpeed;
	}
	
	public function grounded():Void {
		_isGrounded = true;
		_isJumping = false;
		_ySpeed = 0;
	}
	
	public function fall():Void {
		_isGrounded = false;
	}
	
	public function getTopLeftCorner():Point {
		return new Point( _position.x, _position.y - _dim.height );
	}
	
	public function getBound():Rectangle {
		return _dim;
	}
	
	public function getParentBounds():Rectangle {
		var pos:Point = getTopLeftCorner();
		return new Rectangle( pos.x, pos.y, _dim.width, _dim.height );
	}
	
	public function moveLeft( x:UInt ):Void {
		setXSpeed( getXSpeed() - x );
	}
	
	public function moveRight( x:UInt ):Void {
		setXSpeed( getXSpeed() + x );
	}
	
	public function addColor():Void {
		_colorIndex = ( _colorIndex + 1 ) % _colors.length;
		updateColor();
	}
	
	public function removeColor():Void {
		if ( --_colorIndex  < 0 ) _colorIndex = _colors.length - 1;
		updateColor();
	}
	
	public function getPosition():IntPoint {
		return _position;
	}
	
	public function setPosition( x:Int, y:Int ):Void {
		_position.x = x;
		_position.y = y;
	}
	
	public function getColor():UInt {
		return _colors[ _colorIndex ];
	}
	
	private function updateColor():Void {
		_bitmapData.fillRect( _dim, getColor() + 0xFF000000 ); 
		drawBorder();
	}
	

	public function isGravitable():Bool {
		return true;
	}
	
	public function getYSpeed():Float {
		return _ySpeed;
	}
	
	public function setYSpeed( v:Float ):Void {
		_ySpeed = v;
	}
	
	public function getXSpeed():Float {
		return _xSpeed;
	}
	
	public function setXSpeed( v:Float ):Void {
		_xSpeed = v;
		if ( v < 0 && _xSpeed < -_maxSpeed ) _xSpeed = -_maxSpeed;
		else if ( v > 0 && _xSpeed > _maxSpeed ) _xSpeed = _maxSpeed;
	}
	
	public function setCollision( v:IntPoint ):Void {
		
	}
}