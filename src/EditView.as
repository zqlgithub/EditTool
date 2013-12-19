package
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.VSlider;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	import mx.events.SliderEvent;
	
	import spark.components.Button;
	import spark.components.TextInput;
	
	
	public class EditView extends UIComponent
	{
		private var map:Sprite = null;
		private var timeLine:Shape = null;
		private var slider:VSlider = null;
		private var inputField:TextInput = null;
		private var submitBtn:Button = null;
		private var canvas:Canvas;
		private var scale:Number = 0.0;
		
		private var speed:Number = 10;//pixel per second
		private var endTime:int = -1;
		private var currTime:int = -1;
		
		[Embed(source="background.jpg")]
		private var BgImage:Class;
		
		public function EditView(_container:Canvas)
		{
			this.canvas = _container;
			this.canvas.addEventListener(ResizeEvent.RESIZE, onResize);
			
			map = new Sprite;
			map.x = 100;
			this.addChild(map);
			
			timeLine = new Shape;
			timeLine.x = -400;
			map.addChild(timeLine);
			
			inputField = new TextInput;
			inputField.width = 80;
			inputField.height = 30;
			inputField.restrict = "0123456789";
			this.addChild(inputField);
			
			submitBtn = new Button();
			submitBtn.label = "确认";
			submitBtn.width = 50;
			submitBtn.height = 30;
			submitBtn.addEventListener(MouseEvent.CLICK, onSubmit);
			this.addChild(submitBtn);
			
			slider = new VSlider;
			slider.showDataTip = true;
			slider.minimum = 0;
			slider.snapInterval = 1;
			slider.height = 500;
			slider.liveDragging = true;
			slider.addEventListener(SliderEvent.CHANGE, onsliderChange);
			this.addChild(slider);
			
			setEndTime(canvas.height/speed);
			setCurrTime(0);
			
			onResize();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			map.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onSubmit(e:MouseEvent):void
		{
			setCurrTime(int(inputField.text));
		}
		
		private function onsliderChange(e:SliderEvent):void
		{
			setCurrTime(e.value);
		}
		
		
		private function onEnterFrame(e:Event):void{
			updateMapPos();
			updateMapSize();
		}
		
		private function onWheel(e:MouseEvent):void{
			setCurrTime(currTime+e.delta);
		}
		private function onClick(e:MouseEvent):void
		{
			var m:Entity = DataManager.getInstance().currSelectMat;
			if(m)
			{
				var mat:EntityView = new EntityView(m.clone());
				mat.x = e.localX;
				mat.y = e.localY;
				mat.addEventListener(MouseEvent.CLICK, onMatClick);
				map.addChild(mat);
				
			}
		}
		private function onMouseDown(e:MouseEvent):void{
			
		}
		private function onMouseMove(e:MouseEvent):void{
			
		}
		private function onMouseUp(e:MouseEvent):void{
		 	
		}
		
		
		//adjust views pos when the canvas size change
		private function onResize(e:ResizeEvent = null):void{
			this.x = canvas.width*0.5;
			this.y = canvas.height;
			slider.x = -canvas.width*0.5+50;
			slider.y = -canvas.height+80;
			inputField.x = -canvas.width*0.5+30;
			inputField.y = -canvas.height+30;
			submitBtn.x = -canvas.width*0.5+120;
			submitBtn.y = -canvas.height+30;
		}
		
		private function onMatClick(e:MouseEvent):void
		{
			e.stopPropagation();
			var target:EntityView = e.target as EntityView;
			target.removeEventListener(MouseEvent.CLICK, onMatClick);
			map.removeChild(target);
		}
		
		public function setCurrTime(value:Number):void
		{
			if(value < 0)
			{
				trace("invalid value of currTime!");
				return;
			}
			currTime = value;
			if(currTime > endTime)
				setEndTime(currTime);
			updateSlider();
		}
		
		public function setEndTime(value:Number):void
		{
			if(value < 0)
			{
				trace("invalid value of endTime!");
				return;
			}
			if(value != endTime)
			{
				endTime = value;
			}
		}
		
		
		private function updateSlider():void
		{
			slider.maximum = endTime;
			slider.value = currTime;
			slider.tickInterval = 10;
			slider.labels = ["0s", endTime+"s"];
		}
		
		private function updateMapPos():void{
			map.y = currTime*speed;
		}
		
		//this called when endTime changed
		var timeLineInterval:int = speed*5;
		private function updateMapSize():void
		{
			while(map.height < map.y+canvas.height)
			{
				var currHeight:Number = map.height;
				var img:Bitmap = new BgImage as Bitmap;
				img.scaleX = img.scaleY = 0.5;
				img.x = -img.width*0.5;
				img.y = -currHeight-img.height;
				//img.visible = false;
				map.addChild(img);
			}
			
		}

		private function updateTimeLine():void
		{
			var mapHeight = map.height;
			while(timeLine.height < mapHeight)
			{
				var interval:int = 5*speed;
				var currHeight = timeLine.height;
				timeLine.graphics.moveTo(0, currHeight);
				timeLine.graphics.lineTo(0, currHeight+interval);
				timeLine.graphics.lineTo(-5, currHeight+interval);
			}
		}
		
	}
}