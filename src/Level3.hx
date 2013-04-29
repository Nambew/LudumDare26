package ;
import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * ...
 * @author andre
 */
@:bitmap("gfx/level3.png") class BgLevel3 extends flash.display.BitmapData {}
 
class Level3 implements Level
{

	public function new() 
	{
		
	}
	
	public function getPlayerPosition():IntPoint {
		return new IntPoint( 2 * 16, 4 * 16 - 1 );
	}
	
	public function getGoal():Rectangle {
		return new Rectangle( 75 * 16, 27 * 16, 32, 32 );
	}
	
	public function getBackground():BitmapData {
		return new BgLevel3( 0, 0 );
	}
	
	public function getEnemies():Array<EnemyData> {
		var enemies:Array<EnemyData> = new Array<EnemyData>();
		
		enemies.push( new EnemyData( new IntPoint( 8 * 16, 11 * 16 - 1 ), new IntPoint( 22 * 16, 10 * 16 - 1 ) ) );
		
		enemies.push( new EnemyData( new IntPoint( 3 * 16, 14 * 16 - 1 ), new IntPoint( 3 * 16, 14 * 16 - 1 ) ) );
		enemies.push( new EnemyData( new IntPoint( 3 * 16, 23 * 16 - 1 ), new IntPoint( 3 * 16, 23 * 16 - 1 ) ) );
		enemies.push( new EnemyData( new IntPoint( 21 * 16, 24 * 16 - 1 ), new IntPoint( 21 * 16, 24 * 16 - 1 ) ) );
		enemies.push( new EnemyData( new IntPoint( 62 * 16, 28 * 16 - 1 ), new IntPoint( 52 * 16, 29 * 16 - 1 ) ) );
		
		enemies.push( new EnemyData( new IntPoint( 54 * 16, 11 * 16 - 1 ), new IntPoint( 54 * 16, 11 * 16 - 1 ) ) );
		enemies.push( new EnemyData( new IntPoint( 35 * 16, 24 * 16 - 1 ), new IntPoint( 49 * 16, 24 * 16 - 1 ) ) );
		enemies.push( new EnemyData( new IntPoint( 57 * 16, 7 * 16 - 1 ), new IntPoint( 70 * 16, 11 * 16 - 1 ) ) );
		enemies.push( new EnemyData( new IntPoint( 57 * 16, 19 * 16 - 1 ), new IntPoint( 66 * 16, 19 * 16 - 1 ) ) );
		
		return enemies;
	}
	
}