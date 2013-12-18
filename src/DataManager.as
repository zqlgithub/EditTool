package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	
	public class DataManager extends EventDispatcher
	{
		public var mats:Array = null;
		public var currSelectMat:Entity = null;
		
		public var levelData:XML = null;
		
		private static var instance:DataManager = new DataManager;
		public static function getInstance():DataManager
		{
			return instance;
		}
		
		public function DataManager(target:IEventDispatcher=null)
		{
			mats = new Array;
		}
		
		public function init():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("data.xml");
			if(file.exists)
			{
				var stream:FileStream = new FileStream;
				stream.open(file, FileMode.READ);
				levelData = new XML(stream.readUTFBytes(stream.bytesAvailable));
				stream.close();
			}
			else 
				levelData = <Root label="关卡"></Root>;
			
			var loader:URLLoader = new URLLoader;
			loader.addEventListener(Event.COMPLETE, onLoadMatsData);
			loader.load(new URLRequest("Resource/enemyData.xml"));
		}
		
		public function addNewLevel(name:String):void
		{
			var currNum:int = levelData.level.length();
			levelData.appendChild(new XML("<level label='关卡"+currNum+"'></level>"));
		}
		
		public function save():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("data.xml");
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(levelData.toString());
			stream.close();
			
			Alert.show("保存成功！");
		}
		
		public function setCurrSelectMat(mat:Entity):void
		{
			currSelectMat = currSelectMat == mat ? null : mat;
		}
		
		private function onLoadMatsData(e:Event):void
		{
			var matsData:XML = XML((e.target as URLLoader).data);
			
			for each(var item:XML in matsData.item)
			{
				var entity:Entity = new Entity(item);
				mats.push(entity);
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}