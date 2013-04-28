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
		return new IntPoint( 20, 120 );
	}
	
	public function getGoal():Rectangle {
		return new Rectangle( 6 * 16, 25 * 16, 32, 32 );
	}
	
	public function getBackground():BitmapData {
		return new BgLevel1( 0, 0 );
	}
	
	public function getEnemies():Array<EnemyData> {
		var enemies:Array<EnemyData> = new Array<EnemyData>();
		
		enemies.push( new EnemyData( new IntPoint( 464, 111 ), new IntPoint( 20 * 16, 9 * 16 ) ) );
		enemies.push( new EnemyData( new IntPoint( 53 * 16, 7 * 16 ), new IntPoint( 53 * 16, 7 * 16 ) ) );
		enemies.push( new EnemyData( new IntPoint( 49 * 16, 13 * 16 ), new IntPoint( 49 * 16, 13 * 16 ) ) );
		
		return enemies;
	}
	
}