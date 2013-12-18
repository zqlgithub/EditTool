package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	public class MatsView extends UIComponent
	{
		private var matsData:XML = null;
		private var matsIcons:Array;
		private var grid_width:int = 120;
		private var grid_height:int = 150;
		private var entitiesMap:Dictionary;
		private var selected:Sprite = null;
		
		public function MatsView()
		{
			matsIcons = new Array;
			var instance = DataManager.getInstance();
			for each(var e:Entity in DataManager.getInstance().mats)
			{
				var view:EntityView = new EntityView(e);
				view.addEventListener(MouseEvent.CLICK, onClick);
				matsIcons.push(view);
				this.addChild(view);
			}
			resize(220, 0);
		}
		
		private function onClick(e:MouseEvent):void
		{
			var target:EntityView = e.target as EntityView;
			if(selected)
			{
				selected.alpha = 1;
				selected = null;
			}
			if(target != selected)
			{
				target.alpha = 0.5;
				selected = target;
			}
			DataManager.getInstance().setCurrSelectMat(target.entity);
		}

		public function resize(width:Number, height:Number):void
		{
			var cols:int = width/grid_width+1;
			for(var i:int = 0; i < matsIcons.length; i++)
			{
				matsIcons[i].x = 60+i%cols*grid_width;
				matsIcons[i].y = 60+int(i/cols)*grid_height;
			}
		}
	}
}