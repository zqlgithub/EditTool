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
		private var data:Object = null;
		
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
			var file:File = File.applicationStorageDirectory.resolvePath("data.json");
			if(file.exists)
			{
				var stream:FileStream = new FileStream;
				stream.open(file, FileMode.READ);
				parseToData(JSON.parse(stream.readUTFBytes(stream.bytesAvailable)));
				stream.close();
				
			}
			else 
			{
				data = new Object;
				data.level = new Object;
			}
			updateLevelData();
			
			var loader:URLLoader = new URLLoader;
			loader.addEventListener(Event.COMPLETE, onLoadMatsData);
			loader.load(new URLRequest("Resource/enemyData.xml"));
		}
		private function parseToData(source:Object):void
		{
			//for(var i in data)
				
		}
		private function parseDataToObject():Object
		{
			/*var obj:Object = new Object;
			for(var i in data)
			{
				obj[i] = new Object;
				var arr:Array = Array(data[i]);
				for(var j:int = 0; j < arr.length; j++)
				{
					obj[i][j]
				}
					
			}*/
			return null;
		}
		
		private function updateLevelData():void
		{
			levelData = <Root></Root>;
			for(var i in data)
			{
				levelData.appendChild(new XML("<level label='"+i+"'></level>"));
			}
		}
		
		public function addNewLevel(name:String):void
		{
			if(data.hasOwnProperty(name))
				return;
			data[name] = new Object;
			updateLevelData();
		}
		
		public function addMatsOnLevel(level:String, matData:Object):void
		{
			//data[level] = matData;
		}
		
		public function save():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("data.json");
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(JSON.stringify(data));
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