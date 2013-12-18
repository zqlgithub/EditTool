package
{
	import flash.events.Event;
	
	public class EntityEvent extends Event
	{
		public static const CLICK:String = "entity_click";
		
		public function EntityEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}