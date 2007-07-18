
class as2classes.util.SO{
	
	private static function getObj($name:String):Object{
		return SharedObject.getLocal($name);
	}
	
	public static function get($name:String,$param:String):String{
		if(arguments.length<2) trace("ERROR: Invalid number of arguments. Can't Get SO.");
		else {
			return getObj($name).data[$param];
		}
	}
	
	public static function set($name:String,$param:String,$value:String):Boolean{
		if(arguments.length<3) trace("ERROR: Invalid number of arguments. Can't Set SO.");
		else {
			if(!getObj($name)) {
				trace("ERROR: Object \"" + $name + "\" does not exist. Can't Set SO.");
				return false;
			}
			getObj($name).data[$param] = $value;
			getObj($name).flush();
		}
	}
	
	public static function list($name:String):Void{
		if(arguments.length<1) trace("ERROR: Invalid number of arguments. Can't List SO.");
		else {
			trace("Shared Object: " + $name);
			for(var i in getObj($name).data){
				trace("|\t" + i + " = " + getObj($name).data[i]);
			}
			trace("\n");
		}
	}
	
	public static function remove($name:String,$param:String):Boolean{
		var ok
		if(arguments.length<2) trace("ERROR: Invalid number of arguments. Can't Delete SO.");
		else {
			if(!getObj($name)) {
				trace("ERROR: Object \"" + $name + "\" does not exist. Can't Delete SO.");
				return false;
			}
			for(var i in getObj($name).data){
				if(i == $param){
					delete getObj($name).data[i];
					ok = true;
					break;
				}
			}
			if(!ok) trace("ERROR: Parameter \"" + $param + "\" does not exist in \"" + $name + "\". Can't Delete SO.");
			delete ok;
		}
	}
	
	public static function clear($name:String):Boolean{
		if(arguments.length<1) trace("ERROR: Invalid number of arguments. Can't Clear SO.");
		else {
			if(!getObj($name)) {
				trace("ERROR: Object \"" + $name + "\" does not exist. Can't Clear SO.");
				return false;
			}
			for(var i in getObj($name).data){
				 delete getObj($name).data[i]; 
			}
			getObj($name).flush();
		}
	}
	
	private function SO(){} // Avoid instace creation
}
