package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ui.AddMissionSkin;
	
	public class AddMission extends Sprite
	{
		private var skin:AddMissionSkin ; 
		
		private var hours:int ;
		
		private var minutes:int ; 
		
		private var events:String ; 
		
		public function AddMission()
		{
			skin = new AddMissionSkin();
			this.addChild(skin);
			skin.btnAdd.addEventListener(MouseEvent.CLICK , onAddMission);
		}
		
		
		protected function onAddMission(event:MouseEvent):void
		{
			var vo:MissionVo = new MissionVo();
			vo.hours = hours = int(skin.txtHours.text);
			vo.minutes = minutes = int(skin.txtMinutes.text);
			vo.events = events = skin.txtEvents.text ; 
			if(hours <=23 && hours >=0 && minutes>=0 && minutes<=59){
				if((hours +minutes/100) > (StaticBox.hours + StaticBox.minutes /100)){
					
					hours = - 1 ;
					minutes  = -1 ;
					var e:MissionEvent = new MissionEvent(MissionEvent.ADDMISSION);
					e.missionVo = vo ; 
					this.dispatchEvent(e);
				}
//				clearTxt();
			}
		}		
		
		private function clearTxt():void{
			skin.txtEvents.text =""
			skin.txtHours.text = ""
			skin.txtMinutes.text = "";
		}
		
	}
}