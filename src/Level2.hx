package ;
import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * ...
 * @author andre
 */
@:bitmap("gfx/level2.png") class BgLevel2 extends flash.display.BitmapData {}
 
class Level2 implements Level
{

	public function new() 
	{
		
	}
	
	public function getPlayerPosition():IntPoint {
		return new IntPoint( 2 * 16, 6 * 16 - 1 );
	}
	
	public function getGoal():Rectangle {
		return new Rectangle( 31 * 16, 7 * 16, 32, 32 );
	}
	
	public function getBackground():BitmapData {
		return new BgLevel2( 0, 0 );
	}
	
	public function getEnemies():Array<EnemyData> {
		var enemies:Array<EnemyData> = new Array<EnemyData>();
		
		enemies.push( new EnemyData( new IntPoint( 1 * 16, 9 * 16 - 1 ), new IntPoint( 5 * 16, 9 * 16 - 1 ) ) );
		enemies.push( new EnemyData( new IntPoint( 18 * 16, 9 * 16 - 1 ), new IntPoint( 23 * 16, 9 * 16 - 1 ) ) );
		
		return enemies;
	}
	
}