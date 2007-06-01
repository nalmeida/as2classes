/**
* RadioButton Component
* @author Nicholas Almeida
* @version 0.1
*/

import as2classes.util.Delegate;

class as2classes.form.RadioButton extends MovieClip{
	
	private var mc:MovieClip;
	private var mcState:MovieClip;
	
	private var label:String;
	private var value:String;
	private var selected:Boolean;
	private var enabled:Boolean;
	private var groupName:String;
	private var arrGroupName:Array = [];
	
	public var required:Boolean;

	function RadioButton(){
		mc = this;
		mcState = mc.mcRadioButtonState;
		mc.useHandCursor = false;
		
		mc.onRelease =
		mc.onReleaseOutside = Delegate.create(this, setSelected, true);
		
		required = false;
	}
	
	public function init(obj:Object):Void{
		// Group name
		if(!obj.groupName) trace("ERROR on RadioButton: " + mc + " parameter \"groupName\" not defined.");
		groupName = obj.groupName;
		arrGroupName.push({mc:mc, groupName:groupName});
		
		// Label
		if(!obj.label) trace("ERROR on RadioButton: " + mc + " parameter \"label\" not defined.");
		mc.fld_label.text = label = obj.label;
		
			// Width
			if(obj.width){
				mc.fld_label.wordWrap = true;
				mc.fld_label.multiline = true;
				mc.fld_label._width = obj.width;
				mc.fld_label._width = 150;
			} 
			mc.fld_label.autoSize = true;
			
			// Align
			if(obj.align == "left"){
				var format:TextFormat = new TextFormat();
					format.align = "right";
	
				mc.fld_label._x = -(mc.fld_label._width+2);
				mc.fld_label.setTextFormat(format);
				delete format;
			}
		
		// Value
		if(!obj.value) trace("ERROR on RadioButton: " + mc + " parameter \"value\" not defined.");
		value = obj.value.toString() || mc._name;
		
		// Selection
		setSelected(obj.selected, true);
	}
	
	public function setSelected(val:Boolean, avoidOnChangeEvent:Boolean):Void{
		if(val){ // Select = TRUE
			reset();
			mcState.gotoAndStop("selected");
			mc.selected = true;
		} else { // Select = FALSE
			mcState.gotoAndStop("default");
			mc.selected = false;
		}
		
		if(!avoidOnChangeEvent){
			var tmpArr:Array = getMyGroup();
			for(var i=0; i<tmpArr.length; i++){
				if(tmpArr[i].mc.selected){
					getHandler("onGroupChanged").onGroupChanged([tmpArr[i].mc, tmpArr[i].mc.value]);
				}
			}
			delete tmpArr;
		}
	}
	
	public function getSelected(){
		var tmpArr:Array = getMyGroup();
		for(var i=0; i<tmpArr.length; i++){
			if(tmpArr[i].mc.selected){
				return [tmpArr[i].mc, tmpArr[i].mc.value];
			}
		}
	}
	
	public function reset():Void{
		for(var i=0; i<arrGroupName.length; i++){
			if(arrGroupName[i].groupName == groupName){
				arrGroupName[i].mc.setSelected(false, true);
			}
		}
	}
	
	public function enableGroup(avoidAlpha:Boolean):Void{
		var tmpArr:Array = getMyGroup();
		for(var i=0; i<tmpArr.length; i++){
			tmpArr[i].mc.enabled = true;
			if(avoidAlpha !== false) tmpArr[i].mc._alpha = 100;
		}
		delete tmpArr;	
	}
	
	public function disableGroup(avoidAlpha:Boolean):Void{
		var tmpArr:Array = getMyGroup();
		for(var i=0; i<tmpArr.length; i++){
			tmpArr[i].mc.enabled = false;
			if(avoidAlpha !== false) tmpArr[i].mc._alpha = 50;
		}
		delete tmpArr;		
	}
	
	public function getMyGroup():Array{
		var tmpArr:Array = [];
		for(var i=0; i<arrGroupName.length; i++){
			if(arrGroupName[i].groupName == groupName){
				tmpArr.push(arrGroupName[i]);
			}
		}
		return tmpArr;
	}

	
	// Private Methods
	private function getHandler(functionName:String):MovieClip{
		var tmpArr:Array = getMyGroup();
		for(var i=0; i<tmpArr.length; i++){
			if(tmpArr[i].mc[functionName]){
				return tmpArr[i].mc;
			}
		}
	}

}