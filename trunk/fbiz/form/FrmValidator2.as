/*
* Class FrmValidator
*
* @author		Nicholas Almeida, nicholasalmeida.com
* @version		1.0
* @history		CPF function empowered
* 				RadioButton Check: 22/06/2006
* 				Multi-lang suport: 6/6/6
* 				Created: 30/05/2006
*
* @usage		
*/
import com.fbiz.util.RegExp;
class com.fbiz.form.FrmValidator2{
	
	public static var objToValidate:Object;
	public static var lang:String;
	
	public var onError:Function;
	public var onResetErrorFields:Function;
	public var onSuccess:Function;
	public var customValidation:Function;
	
	public var errorMsg:String;
	public var fldObj:TextField;
	public var errorObj;
	public var allErrorObj:Array = [];
	private var errorObjCont:Number = 0;
	
	/***********************************************
	* Constructor
	***********************************************/
	function FrmValidator2($lang:String){
		lang = $lang;
		objToValidate = {};
		errorMsg = "";
		fldObj = null;
		errorObj = null;
		allErrorObj = [];
	}	
	
	/***********************************************
	* Add validations
	***********************************************/
	public function amv($field, $objValidation:Object):Void{ // Add Multiple Validation
		if(!eval($field) && !$field.radioList){
			trace("ERROR: Unable to find the field: " + $field);
		} else {
			if(typeof($field) != "string")
				$field = $field._target;
				
			if(!$objValidation){
				trace("ERROR: Any validation found for the field: " + $field);	
			} else {
				objToValidate[$field] = $objValidation;
			}
			
			//errorObjects
			if(objToValidate[$field].errorObj){
				allErrorObj[errorObjCont] = objToValidate[$field].errorObj;
			}else{
				allErrorObj[errorObjCont] = [eval($field)];
			}
			errorObjCont += 1 ;
		}
	}	
	
	/***********************************************
	* Reset Error Fields
	***********************************************/

	public function resetErrorFields():Void{
		for(var i=0; i<allErrorObj.length; i++){
			for(var ii=0; ii<allErrorObj[i].length; ii++){
				onResetErrorFields(allErrorObj[i][ii]);
			}
		}
	}
	
	/***********************************************
	* Check if evething is Ok
	***********************************************/
	public function validate(){
		
		/***********************************************
		* Reset Error Fields
		***********************************************/
		resetErrorFields();
		
		if(!objToValidate){
			trace("objToValidate is not defined! \""+objToValidate+"\"");
			return false;
		}
		
		for(var i in objToValidate) {

			var fld:String = i;
			fldObj = eval(fld);
			var vals:Object = objToValidate[i];

			for(var j in vals) {
				
				/***********************************************
				* Defines Error Object
				***********************************************/
				if(vals.errorObj){
					errorObj = vals.errorObj;
				}else{
					errorObj = [fldObj];
				}

				
				/***********************************************
				* Check Required Fields
				***********************************************/
				if(vals.req){
					if(isEmpty(fld)) {
						Selection.setFocus(fld);
						if(lang == "en")
							errorMsg = "The field \"" + vals.label + "\" is required.";
						else
							errorMsg = "O campo \"" + vals.label + "\" deve ser preenchido.";
						onError(errorObj);
						return false;
					}
				}
				
				
				
				/***********************************************
				* Minimun lenght for input fields
				***********************************************/
				if(vals.minlen){
					if(!isMin(fld, vals.minlen)) {
						Selection.setFocus(fld);
						if(lang == "en")
							errorMsg = "The field \"" + vals.label + "\" must have at least  " + vals.minlen + " characters.";
						else
							errorMsg = "O campo \"" + vals.label + "\" deve conter no mínimo " + vals.minlen + " caracteres.";
						onError(errorObj);
						return false;
					}
				}
				
				
				
				/***********************************************
				* Maximun lenght for input fields
				***********************************************/
				if(vals.maxlen){
					eval(fld).maxChars = vals.maxlen;
					if(!isMax(fld, vals.maxlen)) {
						Selection.setFocus(fld);
						if(lang == "en")
							errorMsg = "The field \"" + vals.label + "\" must have al maximum " + vals.maxlen + " characters.";
						else
							errorMsg = "O campo \"" + vals.label + "\" deve conter no máximo " + vals.maxlen + " caracteres.";
						onError(errorObj);
						return false;
					}
				}
				
				
				
				/***********************************************
				* Characters Type
				***********************************************/
				if(vals.type){
					switch(vals.type) { 
						case "num": 
						case "number": {
							if(!isNum(fld)){
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg = "Only digits characters are allowed for \"" + vals.label + "\" field.";
								else
									errorMsg = "Apenas caracteres numéricos(números) são permitidos para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}
							break;
						}
						case "alnum": 
						case "alphanumeric":{
							if(only(eval(fld).text.toString(),"alnum", vals.req) == false) {
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg = "Only alpha-numeric(letters and numbers) characters are allowed for \"" + vals.label + "\" field.";
								else
									errorMsg = "Apenas caracteres alfanuméricos(letras e números) são permitidos para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}
							break;
						}
						case "letters": 
						case "let": {
							if(only(eval(fld).text.toString(),"let", vals.req) == false) {
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg = "Only letters are allowed for \"" + vals.label + "\" field.";
								else
									errorMsg = "Apenas letras são permitidas para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}
							break;
						}
						case "restrict":
						case "rest": {
							if(only(eval(fld).text.toString(),"rest", vals.req) == false) {
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg = "Only letters, digits, - and _ are allowed for \"" + vals.label + "\" field.";
								else
									errorMsg = "Apenas letras, números, - e _ são permitidas para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}
							break;
						}
						case "email": {
							if(only(eval(fld).text.toString(),"email", vals.req) == false) {
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg =  "\"" + eval(fld).text + "\" isn't a valid e-mail for \"" + vals.label + "\" field.";
								else
									errorMsg =  "\"" + eval(fld).text + "\" não é considerado um endereço válido para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}
							break;
						}
						case "cpf":{
							if(!isCPF(eval(fld).text)){
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg =  "\"" + eval(fld).text + "\" isn't a valid CPF for \"" + vals.label + "\" field.";
								else
									errorMsg =  "\"" + eval(fld).text + "\" não é considerado um valor válido de CPF para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}
							break;
						}
						case "cnpj":{
							if(!isCNPJ(eval(fld).text)){
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg =  "\"" + eval(fld).text + "\" isn't a valid CNPJ for \"" + vals.label + "\" field.";
								else
									errorMsg =  "\"" + eval(fld).text + "\" não é considerado um valor válido de CNPJ para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}

							break;
						}
						case "radio": {
							if(checkRadio(fld) == false) {
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg = "You must select an option for \"" + vals.label + "\" field.";
								else
									errorMsg = "Selecione uma das opções para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}
							break;
						}
						case "check":
						case "checkbox": {
							if(checkCheckBox(fld) == false) {
								Selection.setFocus(fld);
								if(lang == "en"){
									if(vals.customError.en){
										errorMsg = vals.customError.en;
									}else{
										errorMsg = "You must check the option for \"" + vals.label + "\" field.";
									}
								}else{
									if(vals.customError.lp){
										errorMsg = vals.customError.lp;
									}else{
										errorMsg = "Você deve selecionar a opção do campo \"" + vals.label + "\".";
									}
								}
								onError(errorObj);
								return false;
							}
							break;
						}
						case "combobox":
						case "combo": {
							if(checkCombo(fld) == false) {
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg = "You must select an option for \"" + vals.label + "\" field.";
								else
									errorMsg = "Selecione uma das opções para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}
							break;
						}
						default :{
							if(only(eval(fld).text.toString(),vals.type, vals.req) == false) {
								Selection.setFocus(fld);
								if(lang == "en")
									errorMsg = "Invalid value for \"" + vals.label + "\" field.";
								else								
									errorMsg = "Valor incorreto para o campo \"" + vals.label + "\".";
								onError(errorObj);
								return false;
							}
						}
					}
				}
				
				
				
				/***********************************************
				* Check if a number is less than some value
				***********************************************/
				if(vals.lessthan){
					if(Number(eval(fld).text) > vals.lessthan)
						if(lang == "en")
							errorMsg = "The field \"" + vals.label + "\" should be less than: " + vals.lessthan + ".";
						else	
							errorMsg = "O campo \"" + vals.label + "\" deve ser menor ou igual a: " + vals.lessthan + ".";
						onError(errorObj);
						return false;
				}
				
				
				
				/***********************************************
				* Check if a number is greater than some value
				***********************************************/
				if(vals.greaterthan){
					if(Number(eval(fld).text) < vals.greaterthan)
						if(lang == "en")
							errorMsg = "The field \"" + vals.label + "\" should be greater than: " + vals.lessthan + ".";
						else	
							errorMsg = "O campo \"" + vals.label + "\" deve ser maior ou igual a: " + vals.greaterthan + ".";
						onError(errorObj);
						return false;
				}
				
				
				
				/***********************************************
				* Check if a similatiries between fields
				***********************************************/
				if(vals.equal){
					if(eval(fld).text != eval(vals.equal.fld).text)
						if(lang == "en")
							errorMsg = "The field \"" + vals.label + "\" should be equalt to the \"" + vals.equal.label + "\" field.";
						else	
							errorMsg = "O campo \"" + vals.label + "\" deve ser igual ao campo \"" + vals.equal.label + "\".";
						onError(errorObj);
						return false;
				}
				
			}
		}
		if(customValidation)
			if(!customValidation())
				return false;
		onSuccess();
	}


	
	/***********************************************
	* Check if a field is empty
	***********************************************/
	private static function isEmpty($fld:String):Boolean{
		
		if(eval($fld).type == "input"){ // Input fields
			if(eval($fld).length == 0)
				return true;
		}
		
		return false;
	}



	/***********************************************
	* Minimun lenght for input fields
	***********************************************/
	private static function isMin($fld:String, len:Number):Boolean{
		if(eval($fld).type == "input"){ // Input fields
			if(eval($fld).length >= len) return true;
		}
		
		return false;
	}
	
	
	
	/***********************************************
	* Maximun lenght for input fields
	***********************************************/
	private static function isMax($fld:String, len:Number):Boolean{
		if(eval($fld).type == "input"){ // Input fields
			if(eval($fld).length <= len) return true;
		}else{
			trace("achou radio ou comboBox");
		}
		return false;
	}



	
	/***********************************************
	* Check if the field is a number
	***********************************************/
	private static function isNum($fld:String):Boolean{
		if(eval($fld).type == "input"){ // Input fields
			if(isNaN(eval($fld).text)) return false;
		}
		
		return true;
	}
	
	
	
	
	/***********************************************
	* Check if the field is a valid CPF number
	***********************************************/
	private static function isCPF(v):Boolean{
		if (v == "00000000000" || v == "11111111111" || v == "22222222222" || v == "33333333333" || v == "44444444444" || v == "55555555555" || v == "66666666666" || v == "77777777777" || v == "88888888888" || v == "99999999999") return false;
		if(!v) return false;
		var s=null;
		var r=null;
		var re = new RegExp("1{11};|2{11};|3{11};|4{11};|5{11};|6{11};|7{11};|8{11};|9{11};|0{11};");
		if(v.length!=11||re.match(v)) return false;
		s=0;
		for(var i=0;i<9;i++) s+=parseInt(v.charAt(i))*(10-i);
		r=11-(s%11);
		if(r==10||r==11) r=0;
		if(r!=parseInt(v.charAt(9))) return false;
		s=0;
		for(var i=0;i<10;i++) s+=parseInt(v.charAt(i))*(11-i);
		r=11-(s%11);
		if(r==10||r==11) r=0;
		if(r!=parseInt(v.charAt(10))) return false;
	
		return true;
	}
	
	
	
	/***********************************************
	* Check if the field is a valid CNPJ number
	***********************************************/
	private static function isCNPJ(v):Boolean{
		if(!v) return false;
		var m = new Array('543298765432','6543298765432');
		var d = new Array(0,0);
		for (var t=0; t<2; t++) {
			for(var x=0; x<13; x++) {
				if ((t==0 && x!=12) || t==1) d[t] += ( parseInt(v.slice(x,x+1)) * parseInt(m[t].slice(x,x+1)) );
			};
			d[t] = (d[t] * 10) % 11;
			if (d[t] == 10) d[t] = 0;
		};
		return (d[0] == parseInt(v.slice(12,13)) && d[1] == parseInt(v.slice(13,14)));
	}
	
	
	
	
	/***********************************************
	* Check characters
	***********************************************/
	private static function only($str:String, $type:String, requiredField:Boolean):Boolean{
		
		if(!requiredField && $str == "") return true;
		
		var S:String="";
		
		if ($type == "alnum"){
			S ="[a-z0-9áàãâäéèêëíìîïóòõôöúùûüç\\s-]";
		} else if ($type == "let"){
			S ="[a-záàãâäéèêëíìîïóòõôöúùûüç\\s-]";
		} else if ($type == "rest"){
			S ="[a-z0-9-_]";
		} else {
			S = $type;
		}
		
		var z:Number = 0;
		var re:RegExp = new RegExp(S,"i");
		
		
		
		/***********************************************
		* Check if the field is a valid e-mail
		***********************************************/
		if ($type == "email"){
			re = new RegExp("^([\\w\-\\.]+)@(([\\w\\-]+\\.)+[\\w\\-]+)$","i");
			return re.test($str);
		} else {
			
			
			/***********************************************
			* Other Tests
			***********************************************/
			while(z<$str.length){
				var str:String = $str.slice(z,z+1);
				if(re.test(str) == false) 
					return false;
				z++;
			}
			delete z;
		}

		return true;
	}
	
	/***********************************************
	* Check radioButtons
	***********************************************/
	private static function checkRadio($fld:String):Boolean{
		var g:String = eval($fld).$value;
		if(g == undefined){
			trace("ERROR: Value is not defined for: " + eval($fld));
			return false;
		}
		if(g == 0 || g == "" || g == undefined)
			return false;
		return true;
	}
	
	/***********************************************
	* Check CheckBox
	***********************************************/
	private static function checkCheckBox($fld:String):Boolean{
		var g:String = eval($fld).$value;
		if(g == undefined){
			trace("ERROR: Value is not defined for: " + eval($fld));
			return false;
		}
		if(g == 0 || g == "" || g == undefined)
			return false;
		return true;
	}
	
	/***********************************************
	* Check comboBox
	***********************************************/
	private static function checkCombo($fld:String):Boolean{
		if(eval($fld).selectedIndex == 0){
			return false;
		}
		return true;
	}
}