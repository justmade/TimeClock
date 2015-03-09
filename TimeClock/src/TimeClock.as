package
{
	import com.greensock.TweenMax;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import ui.Icons;
	import ui.MaskSp;
	import ui.MyFont;
	import ui.OpenFile;
	import ui.SecondNode;

	[SWF(height="200",width="500")]
	public class TimeClock extends Sprite
	{
		private var s:Sprite = new Sprite();
		
		private var num:Number =10.6 ; 
		
		private var time:int = 0; 
		
		private var clockSp:Sprite = new Sprite();
		
		private var secondNode:SecondNode ; 
		
		private var timer:Timer = new Timer(1000);
		
		private var angle:int = -90 ;
		
		private var R:int = 100 ;
		
		private var buffBmp:Bitmap ;
		
		private var buffBmd:BitmapData ; 
		
		private var rotationNum:int = 0 ; 
		
		private var window:NativeWindow ;
		
		private var myoption:NativeWindowInitOptions;
		
		private var mainSp:Sprite ; 
		
		private var maskSp:MaskSp ; 
		
		private var myFontStr:String ; 
		
		private var textFormat:TextFormat ; 
		
		private var nodeArr:Array = new Array();
		
		private var currentHour:int ;
		 
		private var currentMinutes:int ; 
		
		private var screenWidth:int ;
		
		private var screenHeight:int ; 
		
		private var openBt:OpenFile ; 
		
		private var icons:BitmapData = new Icons();
		
		private var displayContain:Sprite ;
		
		private var effectContain:Sprite ; 
		
		private var circleFitting:CircleFittingEffect ; 
		public function TimeClock()
		{
			
//			myoption=new NativeWindowInitOptions();
//			myoption.systemChrome = NativeWindowSystemChrome.NONE;
//			myoption.transparent = true;
//			myoption.type = NativeWindowType.UTILITY;
//			//新建窗口，
			
			displayContain = new Sprite();
			this.addChild(displayContain) ;
			effectContain = new Sprite();
			this.addChild(effectContain);
			window = stage.nativeWindow ; 
			window.alwaysInFront = true ;
			initFont();
			getDateTxt();
			
			screenWidth = Capabilities.screenResolutionX ;
			screenHeight = Capabilities.screenResolutionY ; 
			mainSp = new Sprite();
			displayContain.addChild(mainSp)
			this.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			
			openBt = new OpenFile();
			displayContain.addChild(openBt);
			openBt.x = 187 ; 
			openBt.y = 8  ;
			openBt.alpha =  0.3 ; 
			openBt.addEventListener(MouseEvent.MOUSE_OVER , onMouseOver);
			openBt.addEventListener(MouseEvent.MOUSE_OUT , onMouseOut);
			openBt.addEventListener(MouseEvent.CLICK , onGetList);
			
			missionList = new MissionList();
			displayContain.addChild(missionList);
			missionList.x = 250 ;
			missionList.alpha = 0 ;
			
			timer.addEventListener(TimerEvent.TIMER , onClockPlay);
			timer.start() ; 
			initMask();
			addIcons();
			addListener();
			
		
		}
		
		private function addListener():void{
			window.addEventListener(NativeWindowBoundsEvent.RESIZE ,onResize);
		}
		
		protected function onResize(event:Event):void
		{
			if(window.displayState == NativeWindowDisplayState.MAXIMIZED){
				window.restore();
			}
		}
		
		private var missionList:MissionList
		protected function onGetList(event:MouseEvent):void
		{
		
			if(missionList.alpha!=1){
				TweenMax.to(missionList,0.3,{alpha:1});
			}else if(missionList.alpha!=0){
				TweenMax.to(missionList,0.3,{alpha:0});
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			if(openBt.alpha !=0){
				TweenMax.to(openBt,0.3,{alpha:0.3});
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if(openBt.alpha !=1){
				TweenMax.to(openBt,0.3,{alpha:1});
			}
		}
		
		private function remindEvent():void{
			window.restore(); 
			window.bounds = new Rectangle(screenWidth/2 -  500/2, screenHeight/2 - 50,stage.stageWidth,stage.stageHeight);
			onTime();
			
		}
		
		private function onTime():void{
			TweenMax.to(displayContain , 1 , {scaleX:0 ,scaleY:0});
			circleFitting = new CircleFittingEffect(remindEvents);
			circleFitting.addEventListener("Finish" , onEffectFinish);
			effectContain.addChild(circleFitting);
		}
		
		protected function onEffectFinish(event:Event):void
		{
			effectOver();
		}
		
		private function effectOver():void{
			TweenMax.to(displayContain , 0.3 , {scaleX:1 ,scaleY:1});
			if(	effectContain.contains(circleFitting)){
				effectContain.removeChild(circleFitting);
			}
		}
		
		protected function onDown(event:MouseEvent):void
		{
			window.startMove();
		}		

		
		private function initFont():void{
			myFontStr = new MyFont().fontName ; 
			textFormat = new TextFormat(myFontStr,50,0x0099CC);
		}
		
		private var minutesTxt:TextField ; 
		private var hourTxt:TextField ; 
		private function getDateTxt():void{
			var d:Date = new Date();
			
			minutesTxt = new TextField();
			minutesTxt.embedFonts = true ; 
			minutesTxt.defaultTextFormat = textFormat ; 
			minutesTxt.text = setNum(d.minutes) ; 
			currentMinutes = d.minutes ; 
			displayContain.addChild(minutesTxt);
			minutesTxt.x = 90 ;
			minutesTxt.y = 100 ;
			minutesTxt.mouseEnabled = false ; 
			
			hourTxt = new TextField();
			hourTxt.embedFonts = true ; 
			hourTxt.defaultTextFormat = textFormat ; 
			hourTxt.text = setNum(d.hours);
			currentHour = d.hours ; 
			displayContain.addChild(hourTxt);
			hourTxt.x = 40 ;
			hourTxt.y = 40 ;
			hourTxt.mouseEnabled = false ; 
			
			angle = -90 + d.seconds * 6 ;
			rotationNum = d.seconds * 6 ;
			
			saveStaticTime(d.hours , d.minutes , d.seconds);
		}
		
		private function saveStaticTime(_h:int,_m:int,_s:int):void{
			StaticBox.hours = _h;
			StaticBox.minutes = _m ; 
			StaticBox.seconds = _s ; 
		}
		
		private function setNum(_num:int):String{
			if(_num <10){
				return "0"+_num ; 
			}
			else{
				return String(_num) ; 
			}
		}
		
		private function initMask():void{
			maskSp = new MaskSp();
			displayContain.addChild(maskSp);
			mainSp.mask = maskSp ; 
			maskSp.cacheAsBitmap = true ;
			mainSp.cacheAsBitmap = true ;
		}
		
		private function changeTime():void{
			if(currentMinutes<59){
				currentMinutes++
			}
			else if(currentMinutes == 59){
				currentMinutes = 0 ; 
				currentHour++
			}
			minutesTxt.text = setNum(currentMinutes) ; 
			hourTxt.text =setNum(currentHour);
			saveStaticTime(currentHour , currentMinutes , 0);
			cheakClock();
		}
		
		private var remindEvents:String ;
		private function cheakClock():void{
			var arr :Array = missionList.missionListArr ; 
			for(var i:int = 0 ; i < arr.length ; i++){
				var s:SingleMission = arr[i];
				if(s.missionVo.hours == currentHour && s.missionVo.minutes==currentMinutes){
					remindEvents = s.missionVo.events ; 
					remindEvent();
					s.removeFun();
				}
			}
		}
		
		
		protected function onClockPlay(event:TimerEvent):void
		{
			if(angle == 270){
				rotationNum = 0 ;
				angle = - 90 ; 
				changeTime();
				clearSp();
			}
			angle += 6 
			var radian:Number = Math.PI * angle / 180 ; 
			rotationNum+=6 ; 
			
			secondNode = new SecondNode(); 
			secondNode.x =R * Math.cos(radian) + 100 ; 
			secondNode.y = R * Math.sin(radian) + 100 ;
			mainSp.addChild(secondNode);
			secondNode.rotation = rotationNum ; 
			nodeArr.push(secondNode);
			
			num -= 0.01; 
			
			if(num<=-100){
				num = 10.6
			}
			var $bright:uint = 0xffffff ;
			var r:uint = uint( ( Math.sin(num) +1 ) * 255 + $bright ) ;
			var g:uint = uint( ( Math.sin( num + 2.1 ) +1 ) * 255 + $bright ) ;
			var b:uint = uint( ( Math.sin( num + 4.2 ) +1 ) * 255 + $bright ) ;
			var ctf:ColorTransform = new ColorTransform( 0, 0, 0, 1, r, g, b, 0)
			secondNode.transform.colorTransform = ctf ;
		}		
		
		private function clearSp():void{
			for(var i:int = nodeArr.length -1 ; i>=0;i-- ){
				mainSp.removeChild(nodeArr[i]);
				nodeArr.splice(i,1) ;
			}
		}
		
		private function addIcons():void{
			NativeApplication.nativeApplication.icon.bitmaps = [icons] ;
			if (NativeApplication.supportsSystemTrayIcon)
			{
				SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = "TimeClock";
				SystemTrayIcon(NativeApplication.nativeApplication.icon).addEventListener(MouseEvent.CLICK, undock);
				stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, minF);
				SystemTrayIcon(NativeApplication.nativeApplication.icon).menu = dockMenu();
			}
			//根据需要启动后是否自动隐藏到托盘
			dock();
		}
		
		private function minF(e:NativeWindowDisplayStateEvent):void
		{
			if (e.afterDisplayState == NativeWindowDisplayState.MINIMIZED)
			{
				// 当按下最小化按钮是，要阻止默认的最小化发生    
				e.preventDefault();
				dock();
			}
		}
		
		private function dock(e:Event=null):void
		{
			window.visible = false;
		}
		
	    private	function dockMenu():NativeMenu
		{
			var menu:NativeMenu = new NativeMenu();
			var item0:NativeMenuItem = new NativeMenuItem("打开");
			var item1:NativeMenuItem = new NativeMenuItem("关闭");
			
			item0.addEventListener(Event.SELECT, undock);
			item1.addEventListener(Event.SELECT, closeApp);
			menu.addItem(item0);
			menu.addItem(new NativeMenuItem("",true));
			menu.addItem(item1);
			return menu;
		}
		
		private function undock(e:Event=null):void
		{
			window.visible = true;
		}
		
		private function closeApp(e:Event=null):void
		{
			window.close();
		}
		
		
	}
}