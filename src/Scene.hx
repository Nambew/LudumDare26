package ;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

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
	
	public function new( width:UInt, height:UInt ) 
	{
		super( new BitmapData( width, height ) );

		_dimensions = new IntPoint( width, height );
		_camera = new IntPoint( 0, 0 );
	}
	
	public function refresh():Void {
		this.bitmapData.lock();
		
		this.bitmapData.copyPixels( _background, new Rectangle( _camera.x, _camera.y, 600, 400 ), new Point( 0, 0 ) );
		
		this.bitmapData.unlock();
	}
	
	public function setBackground( bmd:BitmapData ):Void {
		_background = bmd;
		_maxX = _background.width - this.bitmapData.width;
		_maxY = _background.height - this.bitmapData.height;
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
	}
	
	
}