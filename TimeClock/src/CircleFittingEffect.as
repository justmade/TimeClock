/**
 * Copyright shapevent ( http://wonderfl.net/user/shapevent )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/hZCr
 */

package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	
	
	
	public class CircleFittingEffect extends MovieClip {
		private var circs:Array;
		private var circNum:int;
		
		private var textArr:Array = [] ; 
		
		private var totalNum:int  =  0; 
		
		private var containSp:Sprite ; 
		
		private var textFSp:Sprite ; 
		
		private var remindEvents:String ; 
		
		
		public function CircleFittingEffect(_txt:String){
			// init
			remindEvents = _txt;
			containSp = new Sprite();
			textFSp = new Sprite();
			this.addChild(textFSp);
			this.addChild(containSp);
//			t.mask = containSp ;
			circs = []
			circNum = 200;
			addEventListener(Event.ENTER_FRAME, onAdd);
			
			var t:TextField = getText() ; 
			var w:int = Math.ceil(500 / t.width);
			var h:int = Math.ceil(200 / t.height);
			for(var i:int = 0 ; i < w * h ; i++){
				var tf:TextField = getText() ; 
				tf.x = (i % w) * tf.width ; 
				tf.y = int(i / w) * tf.height ; 
				textFSp.addChild(tf);
			}
			textFSp.mask = containSp ; 
			
		}
		
		private function getText():TextField{
			var textf:TextField  = new TextField();
			textf.text =remindEvents;
			var textFormat:TextFormat = new TextFormat(null,18 + Math.random()*6,0xffffff * Math.random(),true);
			textf.setTextFormat(textFormat);
			textf.defaultTextFormat = textFormat ; 
			textf.width = textf.textWidth +10;  
			textf.height =textf.textHeight +5; 
			return textf; 
		}
		// private methods
		
		private function onAdd(evt:Event):void {
			if (circs.length < circNum){
				makeGrowable();
			}
		}
		private function makeGrowable():void{
			var s:MovieClip = new MovieClip();
			containSp.addChild(s);
			s.x = Math.random() * stage.stageWidth;
			s.y = Math.random() * stage.stageHeight;
			s.graphics.beginFill(0xffffff*Math.random(),1)
			s.graphics.lineStyle(0,0,0);
			s.graphics.drawCircle(0,0,10);
			circs.push(s);
			s.scaleX = s.scaleY = 0;
			s.addEventListener(Event.ENTER_FRAME, onScaleUp);
		}
		private function onScaleUp(evt:Event):void {
			var c:MovieClip = MovieClip(evt.currentTarget);
			c.scaleX = c.scaleY += 0.1;
//			var t:TextField = textArr[circs.indexOf(evt.currentTarget)];
//			t.scaleX = t.scaleY += 0.1;
			for (var i:int = 0; i<circs.length; i++){
				var circ:MovieClip = circs[i];
				if (circ != c){
					var amt:Number = circ.width/2 + c.width/2;
					var dx:Number = circ.x - c.x;
					var dy:Number = circ.y - c.y;
					var dist:Number = Math.sqrt(dx * dx + dy * dy);
					if (amt >80){
						c.removeEventListener(Event.ENTER_FRAME, onScaleUp);
						totalNum++;
						if(totalNum ==200){
							setTimeout(addsListener , 1000);
						}
						if (c.scaleX < 0.1){
							if (contains(c)){
								containSp.removeChild(c);
							}
						}
					}
				}
				
			}
		}
		
		private function addsListener():void{
			for (var i:int = 0; i<circs.length; i++){
				circs[i].addEventListener(Event.ENTER_FRAME ,onScaleDown);
			}
		}
		
		
		
		
		private function onScaleDown(e:Event):void{
			var c:MovieClip = MovieClip(e.currentTarget);
			c.scaleX = c.scaleY -= 0.05 *Math.random() +0.05;
			if (c.scaleX < 0.1){
				c.removeEventListener(Event.ENTER_FRAME ,onScaleDown);
				totalNum-- ; 
				if(totalNum==1){
					this.dispatchEvent(new Event("Finish"))
				}
				if (contains(c)){
					containSp.removeChild(c);
				}
			}
		}
		
		
	}
	
}