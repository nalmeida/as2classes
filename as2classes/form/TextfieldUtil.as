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
				textField.restrict = "a-z A-Z באדגהיטךכםלמןףעץפצתשûüח\\s\\-?!.@";
				break;
				
			case "let" :
			case "letter" :
			case "letters" :
				textField.restrict = "a-z A-Z באדגהיטךכםלמןףעץפצתשûüח\\s";
				break;
				
			case "text" :
			case "message" :
				textField.restrict = "a-z A-Z 0-9 באדגהיטךכםלמןףעץפצתשûüח\\s\\-?!.@";
				break;
				
			case "num" :
			case "number" :
			case "numbers" :
				textField.restrict = "0-9";
				break;
				
			case "rest" :
			case "restrict" :
			case "pass" :
			case "passw" :
			case "password" :
				textField.restrict = "a-z0-9\\-_";
				break;
				
			case "email" :
			case "mail" :
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
