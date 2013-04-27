package ;
import flash.geom.Rectangle;

/**
 * ...
 * @author andre
 */
interface PhysicEntity
{

	public function getPosition():IntPoint;
	public function setPosition( x:UInt, y:UInt ):Void;
	public function getProjectedPosition():IntPoint;
	public function setProjectedPosition( x:UInt, y:UInt ):Void;
	public function getBound():Rectangle;
	public function isGrounded():Bool;
	public function isJumping():Bool;
	public function grounded():Void;
	public function fall():Void;
	public function isGravitable():Bool;
	public function getYSpeed():Float;
	public function setYSpeed( v:Float ):Void;
	
	
	
}