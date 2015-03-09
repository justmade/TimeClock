package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ui.MissionSkin;
	
	public class SingleMission extends Sprite
	{
		private var skin:MissionSkin ; 
		
		public var missionVo:MissionVo ; 
		
		public var sortKey:Number;
		
		
		public function SingleMission()
		{
			skin = new MissionSkin();
			this.addChild(skin);
			skin.btnDelete.addEventListener(MouseEvent.CLICK , onDelete);
		}
		
		public function setMission(_vo:MissionVo):void{
			if(_vo.hours<10){
				var h:String = "0"+ String(_vo.hours);
			}else{
				h = String(_vo.hours) ; 
			}
			skin.txtHours.text = String(h) ;
			
			if(_vo.minutes < 10){
				var m:String = "0"+String(_vo.minutes) ;
			}else{
				m =String( _vo.minutes) ; 
			}
			skin.txtMinutes.text = String(m) ;
			skin.txtEvents.text = _vo.events ;
			missionVo = _vo ; 
			
			sortKey = _vo.hours + _vo.minutes/100 ; 
		}
		
		public function removeFun():void{
			var e:MissionEvent = new MissionEvent(MissionEvent.DELETEMISSION);
			this.dispatchEvent(e);
			this.parent.removeChild(this);
		}
		
		protected function onDelete(event:MouseEvent):void
		{
			removeFun();
		}
	}
}