/*
* Class Shared Object
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		1.0
* @history		Created: 
*
* @usage		
*/
class com.nicholasalmeida.util.SO{
	private var $name:Object;
	private var $param:String;
	private var $value:String;
	
	private function GetObj($name:String):Object{
		return this.$name = SharedObject.getLocal($name);
	}
	
	public function Get($name:String,$param:String):String{
		if(arguments.length<2) trace("ERROR: Invalid number of arguments. Can't Get SO.");
		else {
			return GetObj($name).data[$param];
		}
	}
	
	public function Set($name:String,$param:String,$value:String):Boolean{
		if(arguments.length<3) trace("ERROR: Invalid number of arguments. Can't Set SO.");
		else {
			if(!GetObj($name)) {
				trace("ERROR: Object \"" + $name + "\" does not exist. Can't Set SO.");
				return false;
			}
			GetObj($name).data[$param] = $value;
			GetObj($name).flush();
		}
	}
	
	public function List($name:String):Void{
		if(arguments.length<1) trace("ERROR: Invalid number of arguments. Can't List SO.");
		else {
			trace("Shared Object: " + $name);
			for(var i in GetObj($name).data){
				trace("|\t" + i + " = " + GetObj($name).data[i]);
			}
			trace("\n");
		}
	}
	
	public function Delete($name:String,$param:String):Boolean{
		if(arguments.length<2) trace("ERROR: Invalid number of arguments. Can't Delete SO.");
		else {
			if(!GetObj($name)) {
				trace("ERROR: Object \"" + $name + "\" does not exist. Can't Delete SO.");
				return false;
			}
			for(var i in GetObj($name).data){
				if(i == $param){
					delete GetObj($name).data[i];
					var ok = true;
					return;
				}
			}
			if(!ok) trace("ERROR: Parameter \"" + $param + "\" does not exist in \"" + $name + "\". Can't Delete SO.");
			delete ok;
		}
	}
	
	public function Clear($name:String):Boolean{
		if(arguments.length<1) trace("ERROR: Invalid number of arguments. Can't Clear SO.");
		else {
			if(!GetObj($name)) {
				trace("ERROR: Object \"" + $name + "\" does not exist. Can't Clear SO.");
				return false;
			}
			for(var i in GetObj($name).data){
				 delete GetObj($name).data[i]; 
			}
			GetObj($name).flush();
		}
	}
}