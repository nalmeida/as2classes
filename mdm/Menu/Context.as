/**
* @author 	MDM/Glactin
* @version 	1.0.1
*/
intrinsic class mdm.Menu.Context {
	/* events */
	var onContextMenuClick_:Function;
	/* constructor */
	/* methods */
	static function disable():Void;
	static function enable():Void;
	static function insertDivider():Void;
	static function insertItem(itemLabel:String):Void;
	static function insertChecked(itemLabel:String, checked:Boolean):Void;
	static function itemEnabled(itemLabel:String, checked:Boolean):Void
	static function itemVisible(itemLabel:String, visible:Boolean):Void;
	static function removeItem(itemLabel:String):Void
	/* properties */
	static var menuType:String;
}
