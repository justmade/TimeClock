package
{
	import flash.events.Event;
	
	public class MissionEvent extends Event
	{
		public static const ADDMISSION:String = "ADDMISSION" ; 
		
		public static const DELETEMISSION:String = "DELETEMISSION" ;
		
		public var missionVo:MissionVo ; 
		public function MissionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}