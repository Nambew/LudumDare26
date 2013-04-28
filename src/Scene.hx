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
	
	private var _enemies:Array<Enemy>;
	
	public function new( width:UInt, height:UInt ) 
	{
		super( new BitmapData( width, height ) );

		_dimensions = new IntPoint( width, height );
		_camera = new IntPoint( 0, 0 );
		_enemies = new Array<Enemy>();
	}
	
	public function refresh():Void {
		this.bitmapData.lock();
		
		updateCamera();
		
		this.bitmapData.copyPixels( _background, new Rectangle( _camera.x, _camera.y, 600, 400 ), new Point( 0, 0 ) );
		
		
		for ( enemy in _enemies ) {
			this.bitmapData.copyPixels( enemy.getBitmapData(), enemy.getBound(), new Point( enemy.getTopLeftCorner().x - _camera.x, enemy.getTopLeftCorner().y - _camera.y ), null, null, true );
		}
		
		this.bitmapData.copyPixels( _player.getBitmapData(), _player.getBound(), new Point( _player.getTopLeftCorner().x - _camera.x, _player.getTopLeftCorner().y - _camera.y ), null, null, true );
		
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
	
	public function addEnemy( enemy:Enemy ):Void {
		enemy.activate();
		_enemies.push( enemy );
		
	}
	
	public function reset():Void {
		for ( enemy in _enemies ) {
			enemy.deactivate();
		}
		
		_enemies = new Array<Enemy>();
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
	
	public function rayCast( start:IntPoint, end:IntPoint ):Bool {
	
		return checkSegment( start.x, start.y, end.x, end.y );
	}
	
	private function getSegment( x1:Int, y1:Int, x2:Int, y2:Int ):Array<IntPoint> {
		var dx:Int, dy:Int;
		var segment:Array<IntPoint> = new Array<IntPoint>();
		
		if( (dx = x2 - x1 ) != 0 ) {
			if( dx > 0 ) {
				if( (dy = y2 - y1 ) != 0 ) {
					if( dy > 0 ) {

						if( dx >= dy ) {
							var e:Int;
							dx = ( e = dx ) * 2;
							dy *= 2;
							
							while ( true ) {
								segment.push( new IntPoint( x1, y1 ) );
								if ( ++x1 == x2 )
									break;
									
								if ( ( e -= dy ) < 0 ) {
									y1++;
									e += dx;
								}
							}
						} else {
							var e:Int;
							dy = ( e = dy ) * 2;
							dx *= 2;
							
							while ( true ) {
								segment.push( new IntPoint( x1, y1 ) );
								if ( ++y1 == y2 )
									break;
									
								if ( ( e -= dx ) < 0 ) {
									x1++;
									e += dy;
								}
							}
						}
					} else {
						if ( dx >= -dy ) {
							var e:Int;
							dx = ( e = dx ) * 2;
							dy *= 2;
							
							while ( true ) {
								segment.push( new IntPoint( x1, y1 ) );
								if ( ++x1 == x2 )
									break;
									
								if ( ( e += dy ) < 0 ) {
									y1++;
									e += dx;
								}
							}
						} else {
							var e:Int;
							dy = ( e = dy ) * 2;
							dx *= 2;
							
							while ( true ) {
								segment.push( new IntPoint( x1, y1 ) );
								if ( --y1 == y2 )
									break;
									
								if ( ( e += dx ) > 0 ) {
									x1++;
									e += dy;
								}
							}
						}
					}
				} else {
					
					do {
						segment.push( new IntPoint( x1, y1 ) );
					} while ( ++x1 != x2 );
				}
			} else {
				
				if ( ( dy = y2 - y1 ) != 0 ) {
					if( dy > 0 ) {
						
						if ( -dx >= dy ) {
							var e:Int;
							dx = ( e = dx ) * 2;
							dy *= 2;
							
							while ( true ) {
								segment.push( new IntPoint( x1, y1 ) );
								if ( --x1 == x2 )
									break;
									
								if ( ( e += dy ) >= 0 ) {
									y1++;
									e += dx;
								}
							}
						} else {
							var e:Int;
							dy = ( e = dy ) * 2;
							dx *= 2;
							
							while ( true ) {
								segment.push( new IntPoint( x1, y1 ) );
								if ( ++y1 == y2 )
									break;
									
								if ( ( e += dx ) <= 0 ) {
									x1++;
									e += dy;
								}
							}
						}
					} else {
						
						if ( dx <= dy ) {
							var e:Int;
							dx = ( e = dx ) * 2; 
							dy *= 2;
							
							while ( true ) {
								segment.push( new IntPoint( x1, y1 ) );
								if ( --x1 == x2 )
									break;
									
								if ( ( e -= dy ) >= 0 ) {
									y1--;
									e += dx;
								}
							}
						} else {
							var e:Int;
							dy = ( e = dy ) * 2;
							dx *= 2;
							
							while ( true ) {
								segment.push( new IntPoint( x1, y1 ) );
								if ( --y1 == y2 )
									break;
									
								if ( ( e -= dx ) >= 0 ) {
									x1--;
									e += dy;
								}
							}
						}
					}
				} else {
					do {
						segment.push( new IntPoint( x1, y1 ) );
					} while ( --x1 != x2 );
				}
				
			}
		} else {

			if ( ( dy = y2 - y1 ) != 0 ) {
				if ( dy > 0 ) {
					do {
						segment.push( new IntPoint( x1, y1 ) );
					} while ( ++y1 != y2 );
				} else {
					do {
						segment.push( new IntPoint( x1, y1 ) );
					} while ( --y1 != y2 );
				}

			}
			
		}
		
		return segment;
		
	}
	
	private function checkSegment( x1:Int, y1:Int, x2:Int, y2:Int ):Bool {
		var dx:Int, dy:Int;
		
		if( (dx = x2 - x1 ) != 0 ) {
			if( dx > 0 ) {
				if( (dy = y2 - y1 ) != 0 ) {
					if( dy > 0 ) {

						if( dx >= dy ) {
							var e:Int;
							dx = ( e = dx ) * 2;
							dy *= 2;
							
							while ( true ) {
								if ( isCollision( x1, y1 ) ) return false;

								if ( ++x1 == x2 )
									break;
									
								if ( ( e -= dy ) < 0 ) {
									y1++;
									e += dx;
								}
							}
						} else {
							var e:Int;
							dy = ( e = dy ) * 2;
							dx *= 2;
							
							while ( true ) {
								if ( isCollision( x1, y1 ) ) return false;
								
								if ( ++y1 == y2 )
									break;
									
								if ( ( e -= dx ) < 0 ) {
									x1++;
									e += dy;
								}
							}
						}
					} else {
						if ( dx >= -dy ) {
							var e:Int;
							dx = ( e = dx ) * 2;
							dy *= 2;
							
							while ( true ) {
								if ( isCollision( x1, y1 ) ) return false;
								
								if ( ++x1 == x2 )
									break;
									
								if ( ( e += dy ) < 0 ) {
									y1++;
									e += dx;
								}
							}
						} else {
							var e:Int;
							dy = ( e = dy ) * 2;
							dx *= 2;
							
							while ( true ) {
								if ( isCollision( x1, y1 ) ) return false;
								
								if ( --y1 == y2 )
									break;
									
								if ( ( e += dx ) > 0 ) {
									x1++;
									e += dy;
								}
							}
						}
					}
				} else {
					
					do {
						if ( isCollision( x1, y1 ) ) return false;
					} while ( ++x1 != x2 );
				}
			} else {
				
				if ( ( dy = y2 - y1 ) != 0 ) {
					if( dy > 0 ) {
						
						if ( -dx >= dy ) {
							var e:Int;
							dx = ( e = dx ) * 2;
							dy *= 2;
							
							while ( true ) {
								if ( isCollision( x1, y1 ) ) return false;
								
								if ( --x1 == x2 )
									break;
									
								if ( ( e += dy ) >= 0 ) {
									y1++;
									e += dx;
								}
							}
						} else {
							var e:Int;
							dy = ( e = dy ) * 2;
							dx *= 2;
							
							while ( true ) {
								if ( isCollision( x1, y1 ) ) return false;
								
								if ( ++y1 == y2 )
									break;
									
								if ( ( e += dx ) <= 0 ) {
									x1++;
									e += dy;
								}
							}
						}
					} else {
						
						if ( dx <= dy ) {
							var e:Int;
							dx = ( e = dx ) * 2; 
							dy *= 2;
							
							while ( true ) {
								if ( isCollision( x1, y1 ) ) return false;
								
								if ( --x1 == x2 )
									break;
									
								if ( ( e -= dy ) >= 0 ) {
									y1--;
									e += dx;
								}
							}
						} else {
							var e:Int;
							dy = ( e = dy ) * 2;
							dx *= 2;
							
							while ( true ) {
								if ( isCollision( x1, y1 ) ) return false;
								
								if ( --y1 == y2 )
									break;
									
								if ( ( e -= dx ) >= 0 ) {
									x1--;
									e += dy;
								}
							}
						}
					}
				} else {
					do {
						if ( isCollision( x1, y1 ) ) return false;
					} while ( --x1 != x2 );
				}
				
			}
		} else {

			if ( ( dy = y2 - y1 ) != 0 ) {
				if ( dy > 0 ) {
					do {
						if ( isCollision( x1, y1 ) ) return false;
					} while ( ++y1 != y2 );
				} else {
					do {
						if ( isCollision( x1, y1 ) ) return false;
					} while ( --y1 != y2 );
				}

			}
			
		}
		
		return true;
		
	}
}