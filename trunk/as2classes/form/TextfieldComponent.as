/**
* Textfield Component
* @author Nicholas Almeida
* @version 0.1
*/

import as2classes.util.Delegate;
import as2classes.form.TextfieldUtil;

class as2classes.form.TextfieldComponent extends MovieClip{
	
	private var mc:MovieClip;
	private var textField:TextField;
	
	private var initSize:Object;
	private var initText:String;
	
	public var required:Boolean;
	public var maxChars:Number;
	public var minChars:Number;
	public var value:String;
	public var title:String;
	public var isEmpty:Boolean;
	public var type:String;
	public var restrict:String;
	public var border:Boolean;
	
	function TextfieldComponent(){
		mc = this;
		textField = mc.fld_text;
		
		initSize = {};
			initSize.w = mc._width;
			initSize.h = mc._height;
			
		required = false;
		border = true;
		
	}
	
	
	/**
	* @param type:String. Values: "input"(default) or "dynamic" or "password"
	* @param maxChars:Number. Default = ""
	* @param minChars:Number. Default = ""
	* @param text:String. Default = ""
	* @param initText:String. Default = ""
	* @param restrict:String. Default = ""
	* @param title:String. Default = ""
	*/
	public function init(obj:Object):Void{
		
		type = obj.type || "input";
		
		if(type == "password" && !obj.initText)
			textField.password = true;
		else 
			textField.type = type;

		border = (obj.border == false ? false : true);
		if(border == false){
			textField.border = false;
		}
			
		if(obj.restrict) {
			restrict = obj.restrict;
			TextfieldUtil.aplyRestriction(textField, restrict);
		}
		
		if(obj.maxChars) setMaxChars(obj.maxChars);
		if(obj.minChars) setMinChars(obj.minChars);
		if(obj.text) {
			setText(obj.text);
			isEmpty = false;
		}
		
		if(obj.initText && (type == "input" || type == "password")) {
			setInitText(obj.initText);
			value = "";
			isEmpty = true;
		}
	}
	
	public function setSize(width:Number, height:Number):Void{
		initSize.w = width;
		initSize.h = height;
		
		ajustSize();
	}
	
	public function ajustSize():Void{
		mc._xscale = mc._yscale = 100;
		textField._width = initSize.w;
		textField._height = initSize.h;
	}
	
	public function setMaxChars(n:Number):Void{
		textField.maxChars = maxChars = n;
	}
	
	public function getMaxChars():Number{
		return maxChars;
	}
	
	public function setMinChars(n:Number):Void{
		minChars = n;
	}
	
	public function getMinChars():Number{
		return minChars;
	}
	
	public function setText(txt):Void{
		textField.text = value = txt;
	}
	
	public function setInitText(txt:String):Void{
		if(txt) textField.text = initText = txt;
		textField.onSetFocus = Delegate.create(this, clearField);
		textField.onKillFocus = Delegate.create(this, checkIfIsEmpty);
	}
	
	public function getText():String{
		value = textField.text;
		return value;
	}
	
	public function enable():Void{
		TextfieldUtil.aplyRestriction(textField, restrict);
		textField.selectable = true;
		setInitText();
		mc._alpha = 100;
	}
	
	public function disable():Void{
		TextfieldUtil.aplyRestriction(textField, "disable");
		textField.onSetFocus = function(){};
		textField.onKillFocus = function(){};
		textField.selectable = false;
		if(mc._alpha != 50) mc._alpha = 50;
	}
	
	
	private function clearField():Void{
		if(getText() == initText || getText().length == 0){
			if(type == "password") textField.password = true;
			textField.text = "";
			isEmpty = true;
			value = "";
		}
	}
	
	private function checkIfIsEmpty():Void{
		if(getText() == "") {
			if(type == "password") textField.password = false;
			textField.text = initText;
			isEmpty = true;
			value = "";
		} else {
			isEmpty = false;
			value = textField.text;
		}
	}

	
}










