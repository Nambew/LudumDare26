package ;
import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * ...
 * @author andre
 */
interface Level
{

	public function getPlayerPosition():IntPoint;
	public function getGoal():Rectangle;
	public function getBackground():BitmapData;
	public function getEnemies():Array<EnemyData>;
	
}