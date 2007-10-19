import as2classes.util.Delegate;

class as2classes.form.FormValidator extends MovieClip{
	private static var language:String;
	
	private var mc:MovieClip;
	private var arrToValidate:Array;
	
	function FormValidator($mc:MovieClip){
		mc = $mc;
		arrToValidate = [];
		
		setLanguage();
	}
	
	public function validate():Boolean{
		arrToValidate = getFieldsToValidate();
		for (var i:Number = 0; i<arrToValidate.length; i++) {
			
			var fld = arrToValidate[i];
			var t:String = fld._type;
			
			if(t === "textfield"){ // textfield validation
				trace(" ??? " + fld.prototype);
				break;
			}
		}
		
		return false;
	}
	
	private function getFieldsToValidate():Array{
		var arr:Array = [];
		for (var i in mc) {
			if(mc[i].isFormField) arr.push(mc[i]); // just form fields
		}
		arr.reverse();
		return arr;
	}
	
	
	public function setLanguage(lang:String):Void{
		language = lang || "br";
	}
	
	public function getLanguage():String{
		return language;
	}
}
