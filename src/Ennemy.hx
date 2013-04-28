package ;
import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * ...
 * @author andre
 */
class Ennemy implements PhysicEntity
{

	private var _bitmapData:BitmapData;
	
	private var _position:IntPoint;
	private var _isGrounded:Bool;
	private var _isJumping:Bool;
	private var _walking:Bool;
	
	private var _active:Bool;
	private var _dim:Rectangle;
	
	private var _maxSpeed:Float = 5;
	private var _xSpeed:Float = 0;
	private var _ySpeed:Float = 0;
	private var _jumpSpeed:Float = 6;
	
	public function new( startPos:IntPoint, scene:Scene ) 
	{
		_position = startPos;
		_active = false;
		_dim = new Rectangle( 0, 0, 32, 32 );
	}
	
	/* INTERFACE PhysicEntity */
	
	public function activate():Void {
		_active = true;
		_bitmapData = new BitmapData( Math.floor( _dim.width ), Math.round(_dim.height ), true );
		draw();
	}
	
	private function draw():Void {
		_bitmapData.fillRect( new Rectangle(0, 0, 32, 10 ), 0xFF999999 );
		_bitmapData.fillRect( new Rectangle(8, 22, 16, 10 ), 0xFF999999 );
		_bitmapData.fillRect( new Rectangle(0, 22, 32, 10 ), 0xFF999999 );
	}
	
	public function deactivate():Void {
		_active = false;
		_bitmapData = null;
	}
	
	public function isActive():Bool {
		return _active;
	}
	
	public function ia( stealth:Bool ):Void {
		
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
	
}