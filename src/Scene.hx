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
	
	private var _background:BitmapData;
	private var _dimensions:IntPoint;
	private var _height:UInt;
	private var _camera:IntPoint;
	private var _maxX:Int;
	private var _maxY:Int;
	
	private var _player:Player;
	
	public function new( width:UInt, height:UInt ) 
	{
		super( new BitmapData( width, height ) );

		_dimensions = new IntPoint( width, height );
		_camera = new IntPoint( 0, 0 );
	}
	
	public function refresh():Void {
		this.bitmapData.lock();
		
		this.bitmapData.copyPixels( _background, new Rectangle( _camera.x, _camera.y, 600, 400 ), new Point( 0, 0 ) );
		
		this.bitmapData.copyPixels( _player.getBitmapData(), _player.getBound(), _player.getTopLeftCorner() );
		
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
	
	public function translateCamera( x:Int, y:Int ):Void {
		_camera.x += x;
		
		if ( _camera.x < 0 )
			_camera.x = 0;
		else if ( _camera.x > _maxX )
			_camera.x = _maxX;
			
		_camera.y += y;
		
		if ( _camera.y < 0 )
			_camera.y = 0;
		else if ( _camera.y > _maxY )
			_camera.y = _maxY;
			
		if ( _camera.x < 0 )
			_camera.x = 0;
			
		if ( _camera.y < 0 )
			_camera.y = 0;
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
		var maxX:Int = Math.floor(rect.width);
		var maxY:Int = Math.floor(rect.height);
		var posX:Int = Math.floor(rect.x);
		var posY:Int = Math.floor(rect.y);
		var color:UInt;
		var localX:Int;
		var floorColor:UInt = 0;
		
		for ( x in 0...1 ) {
			localX = posX + ( x * maxX );
			for ( y in 0...maxY ) {
				color = _background.getPixel( localX, posY + y );
				if ( color == floorColor ) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	
}