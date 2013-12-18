package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class EntityView extends Sprite
	{
		public var entity:Entity = null;
		
		public function EntityView(entity:Entity)
		{
			this.entity = entity;
			
			var loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSkin);
			loader.load(new URLRequest("Resource/"+entity.skinPath));
		}
		
		private function onLoadSkin(e:Event):void
		{
			var skin:Bitmap = Bitmap((e.target as LoaderInfo).loader.content);
			skin.x = -skin.width*0.5;
			skin.y = -skin.height*0.5;
			addChild(skin);
		}
	}
}