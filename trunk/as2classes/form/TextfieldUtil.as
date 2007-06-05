/**
* Form Utiliities
* @author Nicholas Almeida
* @version 0.1
*/

class as2classes.form.TextfieldUtil {
	
	public static function aplyRestriction(textField:TextField, $restriction:String):Void{
		
		var restriction:String = $restriction.toLowerCase();
		
		switch (restriction){
			case "alnum" :
			case "alphanumeric" :
				textField.restrict = "a-z A-Z �����������������������\\s\\-?!.@";
				break;
				
			case "let" :
			case "letters" :
				textField.restrict = "a-z A-Z 0-9 �����������������������\\s\\-?!.@";
				break;
				
			case "num" :
			case "numbers" :
				textField.restrict = "0-9";
				break;
				
			case "rest" :
			case "restrict" :
				textField.restrict = "a-z0-9\\-_";
				break;
				
			case "email" :
				textField.restrict = "a-z0-9\\-_@+.";
				break;
				
			case "mon" :
			case "money" :
				textField.restrict = "$0-9,";
				break;
				
			case "cpf" :
				textField.restrict = "0-9\\-.";
				break;
				
			case "rg" :
				textField.restrict = "0-9\\-.A-Z";
				break;
				
			case "cnpj" :
				textField.restrict = "0-9\\-./";
				break;
				
			case "disable" :
			case "all" :
				textField.restrict = "-";
				break;
				
			case "none" : 
				textField.restrict = "^";
				break;
				
			default : 
				textField.restrict = restriction || "^";
		}
	}
}
