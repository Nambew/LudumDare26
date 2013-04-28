package ;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

/**
 * ...
 * @author andre
 */
 
class Scene extends Bitmap
{
	private var _floorColor:UInt = 0;
	
	private var _background:BitmapData;
	private var _dimensions:IntPoint;
	private var _height:UInt;
	private var _camera:IntPoint;
	private var _maxX:Int;
	private var _maxY:Int;
	
	private var _player:Player;
	
	private var _ennymies:Array<Ennemy>;
	
	public function new( width:UInt, height:UInt ) 
	{
		super( new BitmapData( width, height ) );

		_dimensions = new IntPoint( width, height );
		_camera = new IntPoint( 0, 0 );
		_ennymies = new Array<Ennemy>();
	}
	
	public function refresh():Void {
		this.bitmapData.lock();
		
		updateCamera();
		
		this.bitmapData.copyPixels( _background, new Rectangle( _camera.x, _camera.y, 600, 400 ), new Point( 0, 0 ) );
		
		this.bitmapData.copyPixels( _player.getBitmapData(), _player.getBound(), new Point( _player.getTopLeftCorner().x - _camera.x, _player.getTopLeftCorner().y - _camera.y ) );
		
		for ( enemy in _ennymies ) {
			
		}
		
		this.bitmapData.unlock();
	}
	
	public function setBackground( bmd:BitmapData ):Void {
		_background = bmd;
		_maxX = _background.width - this.bitmapData.width;
		_maxY = _background.height - this.bitmapData.height;
	}
	
	public function setPlayer( player:Player ):Void {
		_player = player;
	}
	
	public function addEnemy( enemy:Ennemy ):Void {
		
	}
	
	public function updateCamera():Void {
		var pos:IntPoint = _player.getPosition();
		_camera.x = pos.x - Math.floor( _dimensions.x / 2 );
		_camera.y = pos.y - 150;
		
		if ( _camera.x < 0 )
			_camera.x = 0;
		else if ( _camera.x > _maxX )
			_camera.x = _maxX;
			
		if ( _camera.y < 0 )
			_camera.y = 0;
		else if ( _camera.y > _maxY )
			_camera.y = _maxY;
		
	}
	
	public function checkColorRegion( rect:Rectangle, color:UInt ):Bool {
		var maxX:Int = Math.floor(rect.width);
		var maxY:Int = Math.floor(rect.height);
		var posX:Int = Math.floor(rect.x);
		var posY:Int = Math.floor(rect.y);
		
		
		
		for ( x in 0...maxX ) {
			for ( y in 0...maxY ) {
				if ( _background.getPixel( posX + x, posY + y ) != color ) {
					return false;
				}
			}
		}
		
		return true;
	}
	
	public function isFloor( rect:Rectangle ):Bool {
		var maxX:Int = Math.floor(rect.width) - 1;
		var maxY:Int = Math.floor(rect.height);
		var posX:Int = Math.floor(rect.x);
		var posY:Int = Math.floor(rect.y);
		var color:UInt;
		var localX:Int;
		
		for ( x in 0...2 ) {
			localX = posX + ( x * maxX );
			for ( y in 0...maxY ) {
				color = _background.getPixel( localX, posY + y );
				if ( color == _floorColor ) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	public function isCollision( x:Int, y:Int ):Bool {
		return _background.getPixel( x, y ) == _floorColor;
	}
	
	
}