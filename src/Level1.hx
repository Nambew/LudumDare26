package ;
import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * ...
 * @author andre
 */
@:bitmap("gfx/level1.png") class BgLevel1 extends flash.display.BitmapData {}
 
class Level1 implements Level
{

	public function new() 
	{
		
	}
	
	public function getPlayerPosition():IntPoint {
		return new IntPoint( 2 * 16, 9 * 16 - 1 );
	}
	
	public function getGoal():Rectangle {
		return new Rectangle( 16 * 16, 7 * 16, 32, 32 );
	}
	
	public function getBackground():BitmapData {
		return new BgLevel1( 0, 0 );
	}
	
	public function getEnemies():Array<EnemyData> {
		var enemies:Array<EnemyData> = new Array<EnemyData>();
		
		enemies.push( new EnemyData( new IntPoint( 5 * 16, 5 * 16 ), new IntPoint( 5 * 16, 5 * 16 ) ) );
		
		return enemies;
	}
	
}