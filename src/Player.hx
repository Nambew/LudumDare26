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
	
	private var _color:UInt;
	
	private var _bitmapData:BitmapData;
	private var _border:BitmapData;
	private var _dim:Rectangle;
	
	private var _xSpeed:Float = 0;
	private var _ySpeed:Float = 0;
	private var _jumpSpeed:Float = 6;
	
	public function new() 
	{
		grounded();
		
		_dim = new Rectangle(0, 0, 16, 32 );
		_position = new IntPoint( 0, 0 );
		_color = 0x777777;
		
		_bitmapData = new BitmapData( Math.floor( _dim.width ), Math.floor( _dim.height ), true, _color + 0xFF000000 );
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
	
	public function jump():Void {
		_isJumping = true;
		_ySpeed = -_jumpSpeed;
		trace( "JUMP" );
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
		_position.x -= x;
	}
	
	public function moveRight( x:UInt ):Void {
		_position.x += x;
	}
	
	public function addRed():Void {
		var tmpColor:UInt = _color & 0xFF0000;
		var newColor:UInt = _color;
		
		switch( tmpColor ) {
			case 0:
				newColor += 0x770000;
			case 0x770000:
				newColor += 0x880000;
		}
		
		if ( newColor != 0xFFFFFF && newColor != 0x000000 ) {
			updateColor( newColor );
		}
		
		
	}
	
	public function addGreen():Void {
		var tmpColor:UInt = _color & 0xFF00;
		var newColor:UInt = _color;
		
		switch( tmpColor ) {
			case 0:
				newColor += 0x7700;
			case 0x7700:
				newColor += 0x8800;
		}
		
		if ( newColor != 0xFFFFFF && newColor != 0x000000 ) {
			updateColor( newColor );
		}
	}
	
	public function addBlue():Void {
		var tmpColor:UInt = _color & 0xFF;
		var newColor:UInt = _color;
		
		switch( tmpColor ) {
			case 0:
				newColor += 0x77;
			case 0x77:
				newColor += 0x88;
		}
		
		if ( newColor != 0xFFFFFF && newColor != 0x000000 ) {
			updateColor( newColor );
		}
	}
	
	public function addColor():Void {
		
		
	}
	
	public function removeColor():Void {
		
		
	}
	
	public function getPosition():IntPoint {
		return _position;
	}
	
	public function setPosition( x:Int, y:Int ):Void {
		_position.x = x;
		_position.y = y;
	}
	
	
	public function removeRed():Void {
		var tmpColor:UInt = _color & 0xFF0000;
		var newColor:UInt = _color;
		
		switch( tmpColor ) {
			case 0xFF0000:
				newColor -= 0x880000;
			case 0x770000:
				newColor -= 0x770000;
		}
		
		if ( newColor != 0xFFFFFF && newColor != 0x000000 ) {
			updateColor( newColor );
		}
	}
	
	public function removeGreen():Void {
		var tmpColor:UInt = _color & 0xFF00;
		var newColor:UInt = _color;
		
		switch( tmpColor ) {
			case 0xFF00:
				newColor -= 0x8800;
			case 0x7700:
				newColor -= 0x7700;
		}
		
		if ( newColor != 0xFFFFFF && newColor != 0x000000 ) {
			updateColor( newColor );
		}
	}
	
	public function removeBlue():Void {
		var tmpColor:UInt = _color & 0xFF;
		var newColor:UInt = _color;
		
		switch( tmpColor ) {
			case 0xFF:
				newColor -= 0x88;
			case 0x77:
				newColor -= 0x77;
		}
		
		if ( newColor != 0xFFFFFF && newColor != 0x000000 ) {
			updateColor( newColor );
		}
	}
	
	public function getColor():UInt {
		return _color;
	}
	
	private function updateColor( newColor:UInt ):Void {
		_color = newColor;
		_bitmapData.fillRect( _dim, _color + 0xFF000000 ); 
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
	}
}