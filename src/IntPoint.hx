package ;

/**
 * ...
 * @author andre
 */
class IntPoint
{

	public var x:Int;
	public var y:Int;
	
	public function new( x:Int = 0, y:Int = 0 ) 
	{
		this.x = x;
		this.y = y;
	}
	
	public function clone():IntPoint {
		return new IntPoint( this.x, this.y );
	}
	
	public function equal( p:IntPoint ):Bool {
		return this.x == p.x && this.y == p.y;
	}
	
}