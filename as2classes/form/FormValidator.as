
import as2classes.form.TextfieldComponent;
import as2classes.form.TextareaComponent;
import as2classes.form.ComboBoxComponent;
import as2classes.form.RadiobuttonComponent;
import as2classes.form.CheckboxComponent;
import as2classes.util.StringUtil;

class as2classes.form.FormValidator extends MovieClip{
	private static var language:String;
	
	private var mc:MovieClip;
	private var arrToValidate:Array;
	private var arrButtons:Array;
	
	public var onError:Function;
	public var onOk:Function;
	
	function FormValidator($mc:MovieClip){
		mc = $mc;
		arrButtons = [];
		arrToValidate = [];
		
		setLanguage();
	}
	
	public function validate(validateAllFields:Boolean){
		
		if(validateAllFields === false) { // Used to avoid validation and skip to onOk method.
			return onOk();;
		}
		
		Selection.setFocus("");
		for (var i:Number = 0; i < arrToValidate.length; i++) {
			
			var fld = arrToValidate[i];
			var t:String = fld._type;
			var tmp;
			
			if(t === "textfield" || t === "textarea"){ // textfield  or textarea validation
				
				/* ---------------------------------------------------------------------- Required */
				if(fld.required === true) {
					tmp = checkRequired(fld);
					if(tmp !== true) return onError(tmp);
				}
				
				/* ---------------------------------------------------------------------- Min */
				if(!fld.isEmpty){
					tmp = checkMinChars(fld);
					if(tmp !== true) return onError(tmp);
				}
				
				/* ---------------------------------------------------------------------- Max */
				if(!fld.isEmpty){
					tmp = checkMaxChars(fld);
					if(tmp !== true) return onError(tmp);
				}
				
				/* ---------------------------------------------------------------------- Email */
				if((fld.restrict == "email" || fld.restrict == "mail") && !fld.isEmpty) {
					tmp = checkEmail(fld);
					if(tmp !== true) return onError(tmp);
				}
				
				/* ---------------------------------------------------------------------- CPF */
				if(fld.restrict == "cpf" && !fld.isEmpty) {
					tmp = checkCpf(fld);
					if(tmp !== true) return onError(tmp);
				}
				
				/* ---------------------------------------------------------------------- Equal */
				if(fld.equal && !fld.isEmpty) {
					tmp = checkEqual(fld, fld.equal);
					if(tmp !== true) return onError(tmp);
				}
				
			} else if(t === "combobox"){
				/* ---------------------------------------------------------------------- Combo */
				if(fld.required === true) {
					tmp = checkCombo(fld);
					if(tmp !== true) return onError(tmp);
				}
				
			} else if(t === "radiobutton"){
				/* ---------------------------------------------------------------------- Radio */
				if(fld.required === true) {
					tmp = checkRadio(fld);
					if(tmp !== true) return onError(tmp);
				}
			} else if(t === "checkbox"){
				/* ---------------------------------------------------------------------- Check */
				if(fld.required === true) {
					tmp = checkCheck(fld);
					if(tmp !== true) return onError(tmp);
				}
			}
			
			delete tmp;
		}
		trace("------------ Validation \"" + mc._name + "\" done ------------");
		onOk();
	}
	
	public function disable():Void{
		for (var i:Number = 0; i < arrToValidate.length; i++) {
			if(!arrToValidate[i].disable) arrToValidate[i].disableGroup();
			else arrToValidate[i].disable();
		}
		for (var i:Number = 0; i < arrButtons.length; i++) {
			arrButtons[i].enabled = false;
			arrButtons[i]._alpha = 50;
		}
		//trace("Fields \"" + mc._name + "\" disabled.");
	}
	
	public function enable():Void{
		for (var i:Number = 0; i < arrToValidate.length; i++) {
			if(!arrToValidate[i].enable) arrToValidate[i].enableGroup();
			else arrToValidate[i].enable();
		}
		for (var i:Number = 0; i < arrButtons.length; i++) {
			arrButtons[i].enabled = true;
			arrButtons[i]._alpha = 100;
		}
		//trace("Fields \"" + mc._name + "\" enabled.");
	}
	
	public function addField(field):Void{
		if(typeof(field) == "movieclip"){
			trace("addField ERROR: \"field\" must be a Object Class (TextfieldComponent, TextAreaComponent...)");
		}else{
			arrToValidate.push(field);
		}
	}
	
	public function addButton(field):Void{
		arrButtons.push(field);
	}
	
	public function removeField(field):Void{
		var t:Array = [];
		for (var i:Number = 0; i < arrToValidate.length; i++) {
			if(arrToValidate[i].mc != field.mc) {
				t.push(arrToValidate[i]);
			}
		}
		arrToValidate = t;
	}
	
	public function setLanguage(lang:String):Void{
		language = lang || "br";
	}
	
	public function getLanguage():String{
		return language;
	}
	
	public function reset():Void{
		for (var i:Number = 0; i < arrToValidate.length; i++) {
			arrToValidate[i].reset();
		}
		enable();
	}
	
	/**
		Return an Array with all elements used in the validation
		
		@return Return Array width FormValidator elements.
	*/
	public function getAllValElms():Array{
		return arrToValidate;
	}
	
	
	/* Textfield validations */
//{
	/* ---------------------------------------------------------------------- Required */
	public function checkRequired(fld){
		if(fld.getText().length === 0){
			if(fld.customErrorMessage)
				return {fld:fld, message:fld.customErrorMessage};
			else
				if(language == "en")
					return {fld:fld, message:"The field \"" + fld.title + "\" is required."};
				else
					return {fld:fld, message:"O campo \"" + fld.title + "\" deve ser preenchido."};
		}
		return true;
	}
	/* ---------------------------------------------------------------------- Min */
	public function checkMinChars(fld){
		if(fld.getText().length < fld.getMinChars()) {
			if(fld.customErrorMessage)
				return {fld:fld, message:fld.customErrorMessage};
			else
				if(language == "en")
					return {fld:fld, message:"The field \"" + fld.title + "\" must have at least  " + fld.getMinChars() + " characters."};
				else
					return {fld:fld, message:"O campo \"" + fld.title + "\" deve conter no m�nimo " + fld.getMinChars() + " caracteres."};
		}
		return true;
	}
	/* ---------------------------------------------------------------------- Max */
	public function checkMaxChars(fld){
		if(fld.getText().length > fld.getMaxChars()) {
			if(fld.customErrorMessage)
				return {fld:fld, message:fld.customErrorMessage};
			else
				if(language == "en")
					return {fld:fld, message:"The field \"" + fld.title + "\" must have al maximum " + fld.getMaxChars() + " characters."};
				else
					return {fld:fld, message:"O campo \"" + fld.title + "\" deve conter no m�ximo " + fld.getMaxChars() + " caracteres."};
		}
		return true;
	}
	/* ---------------------------------------------------------------------- Equal */
	public function checkEqual(fld1, fld2){
		if(fld1.getText() !=  fld2.getText()) {
			if(fld2.customErrorMessage)
				return {fld:fld2, message:fld2.customErrorMessage};
			else
				if(language == "en")
					return {fld:fld2, message:"The field \"" + fld1.title + "\" should be equalt to the \"" + fld2.title + "\" field."};
				else
					return {fld:fld2, message:"O campo \"" + fld1.title + "\" deve ser igual ao campo \"" + fld2.title + "\"."};
		}
		return true;
	}
	/* ---------------------------------------------------------------------- Email */
	public function checkEmail(fld){
		if(!isEmail(fld.getText())) {
			if(fld.customErrorMessage)
				return {fld:fld, message:fld.customErrorMessage};
			else
				if(language == "en")
					return {fld:fld, message: "\"" + fld.getText() + "\" isn't a valid e-mail for \"" + fld.title + "\" field."};
				else
					return {fld:fld, message: "\"" + fld.getText() + "\" n�o � considerado um endere�o v�lido para o campo \"" + fld.title + "\"."};
		}
		return true;
	}
	/* ---------------------------------------------------------------------- Cpf */
	public function checkCpf(fld){
		var onlyNumbers:String = StringUtil.replace(fld.getText(), ".", "");
		onlyNumbers = StringUtil.replace(onlyNumbers, "-", "");
		if(!isCpf(onlyNumbers)) {
			if(fld.customErrorMessage)
				return {fld:fld, message:fld.customErrorMessage};
			else
				if(language == "en")
					return {fld:fld, message: "\"" + fld.getText() + "\" isn't a valid CPF for \"" + fld.title + "\" field."};
				else
					return {fld:fld, message: "\"" + fld.getText() + "\" n�o � considerado um valor v�lido de CPF para o campo \"" + fld.title + "\"."};
		}
		return true;
	}
//}
	
	/* Combobox validation */
//{
	public static function checkCombo(fld:ComboBoxComponent){
		if(fld.getSelectedIndex() == 0) {
			if(fld.customErrorMessage)
				return {fld:fld, message:fld.customErrorMessage};
			else
				if(language == "en")
					return {fld:fld, message:"You must select an option for \"" + fld.title + "\" field."};
				else
					return {fld:fld, message:"Selecione uma das op��es para o campo \"" + fld.title + "\"."};
		}
		return true;
	}
//}
	
	/* Radiobutton validation */
//{
	public static function checkRadio(fld:RadiobuttonComponent){
		if(fld.getSelected() == undefined) {
			if(fld.customErrorMessage)
				return {fld:fld, message:fld.customErrorMessage};
			else
				if(language== "en")
					return {fld:fld, message:"You must select an option for \"" + fld.title + "\" field."};
				else
					return {fld:fld, message:"Selecione uma das op��es para o campo \"" + fld.title + "\"."};
		}
		return true;
	}
//}

	/* Checkbox validation */
//{
	public static function checkCheck(fld:CheckboxComponent){
		if(fld.getSelected() == false) {
			if(fld.customErrorMessage)
				return {fld:fld, message:fld.customErrorMessage};
			else
				if(language== "en")
					return {fld:fld, message:"You must select the \"" + fld.title + "\" field."};
				else
					return {fld:fld, message:"Voc� deve selecionar o campo \"" + fld.title + "\"."};
		}
		return true;
	}
//}
	
	/* static funcions */
	public static function isEmail(str:String):Boolean{ // very basic validation
		var arrobas:Array = str.split("@");
		if(arrobas.length != 2) return false;
		
		var antes:String = arrobas[0];
		var depois:String = arrobas[1];
		if(antes.length == 0 || depois.length == 0) return false;
		var ponto:Array = depois.split(".");
		
		if(ponto.length < 2) return false;
		if(ponto[0].length == 0 || ponto[1].length == 0) return false;
		
		return true;
	}
	
	public static function isCpf(cpf:String):Boolean{
		if (cpf.length != 11 || cpf == "00000000000" || cpf == "11111111111" || cpf == "22222222222" || cpf == "33333333333" || cpf == "44444444444" || cpf == "55555555555" || cpf == "66666666666" || cpf == "77777777777" || cpf == "88888888888" || cpf == "99999999999")return false;
		var soma = 0;
		for (var i = 0; i < 9; i++) soma += parseInt(cpf.charAt(i)) * (10 - i);
		var resto = 11 - (soma % 11);
		if (resto == 10 || resto == 11) resto = 0;
		if (resto != parseInt(cpf.charAt(9)))return false;
		soma = 0;
		for (var i = 0; i < 10; i++)soma += parseInt(cpf.charAt(i)) * (11 - i);
		resto = 11 - (soma % 11);
		if (resto == 10 || resto == 11)resto = 0;
		if (resto != parseInt(cpf.charAt(10))) return false;
		return true;
	}
}























