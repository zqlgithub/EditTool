package
{
	import flash.events.EventDispatcher;

	public class Entity extends EventDispatcher
	{
		public var id:int;
		public var skinPath:String = "";
		public var type:String = "";
		private var hintData:Object;
		
		private static var uid:int = 0;
		public function Entity(data:Object)
		{
			this.hintData = data;
			this.skinPath = data.path;
			this.type = data.type;
			id = uid++;
		}
		
		public function clone():Entity
		{
			var copy:Entity = new Entity(hintData);
			return copy;
		}

		
	}
}