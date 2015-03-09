package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ui.Block;
	import ui.RemindList;
	
	public class MissionList extends Sprite
	{
		private var titleSkin:RemindList
		
		public var missionListArr:Array ; 
		
		private var addMission:AddMission ; 
		
		private var missListSp:Sprite ; 
		
		private var skin:Block ; 
		
		public function MissionList()
		{
			skin = new Block();
			this.addChild(skin);
			skin.x = -20 ; 
			titleSkin = new RemindList();
			missListSp = new Sprite();
			this.addChild(missListSp);
			missListSp.y = 67 ;
			missionListArr = new Array();
			init();
		}
		
		private function init():void{
			addMission = new AddMission();
			addMission.y = 10 ; 
			this.addChild(addMission);
			this.addChild(titleSkin);
			titleSkin.y = 42 ; 
			addMission.addEventListener(MissionEvent.ADDMISSION , onAddMission)
		}
		
		protected function onAddMission(event:MissionEvent):void
		{
			if(missionListArr.length < 4){
				var mission:SingleMission = new SingleMission();
				mission.setMission(event.missionVo);
				if(judgeAddList(event.missionVo)){
					missionListArr.push(mission);
					mission.addEventListener(MissionEvent.DELETEMISSION ,onDeleteMission);
					refreshList();
				}
			}
		}		
		
		private function judgeAddList(_vo:MissionVo):Boolean{
			for(var i:int =  0 ; i <missionListArr.length ; i++){
				var s:SingleMission = missionListArr[i] ; 
				if((_vo.hours + _vo.minutes /100) == s.sortKey ){
					return false ;
				}else{
					true ; 
				}
			}
			return true ;
		}
		
		protected function onDeleteMission(event:MissionEvent):void
		{
			var index:int = missionListArr.indexOf(event.currentTarget  as SingleMission);
			missionListArr.splice(index , 1);
			refreshList();
		}		
		
		private function refreshList():void{
			missionListArr.sortOn("sortKey" ,  Array.NUMERIC);
			for(var i:int = 0 ; i <missionListArr.length ; i++ ){
				missListSp.addChild(missionListArr[i]);
				missionListArr[i].x = 0 ;
				missionListArr[i].y = i * 32 ; 
			}
		}
		
	}
}