/**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
dynamic intrinsic class mdm.Menu.Main {
	/* events */
	var onContextMenuClick_:Function;
	/* constructor */
	/* methods */
	static function insertDivider():Void;
	static function insertHeader(headerLabel:String):Void;
	static function insertItem(headerLabel:String, itemLabel:String):Void;
	static function itemChecked(headerLabel:String, itemLabel:String, checked:Boolean):Void;
	static function itemEnable(headerLabel:String, itemLabel:String, enabled:Boolean):Void;
	static function itemVisible(headerLabel:String, itemLabel:String, visible:Boolean):Void;
	static function removeHeader(headerLabel:String):Void;
	static function removeItem(headerLabel:String, itemLabel:String):Void;
	/* properties */
	static var menuType:String;
}
