import as2classes.util.Delegate;

class as2classes.form.CheckBox extends MovieClip{
	
	private var mc:MovieClip;
	private var mcState:MovieClip;
	
	private var label:String;
	private var value:String;
	private var selected:Boolean;
	private var enabled:Boolean;
	
	public var required:Boolean;

	function CheckBox(){
		mc = this;
		mcState = mc.mcCheckBoxState;
		mc.useHandCursor = false;
		
		mc.onRelease =
		mc.onReleaseOutside = Delegate.create(this, swapSelected, true);
		
		required = false;
	}
	
	public function init(obj:Object):Void{
		// Label
		if(!obj.label) trace("ERROR on CheckBox: " + mc + " parameter \"label\" not defined.");
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
		if(!obj.value) trace("ERROR on CheckBox: " + mc + " parameter \"value\" not defined.");
		value = obj.value.toString() || mc._name;
		
		// Selection
		setSelected(obj.selected);
	}
	
	public function swapSelected():Void{
		if(selected) setSelected(false);
		else setSelected(true);
	}
	
	public function setSelected(val:Boolean):Void{
		if(val){ // Select = TRUE
			mcState.gotoAndStop("selected");
			mc.selected = true;
		} else { // Select = FALSE
			mcState.gotoAndStop("default");
			mc.selected = false;
		}
		if(mc.onChanged) mc.onChanged([mc, selected]);
	}
	
	public function getSelected():Boolean{
		return selected;
	}

	public function enable(avoidAlpha:Boolean):Void{
		mc.enabled = true;
		if(avoidAlpha !== false) mc._alpha = 100;
	}
	
	public function disable(avoidAlpha:Boolean):Void{
		mc.enabled = false;
		if(avoidAlpha !== false) mc._alpha = 50;
	}
	
}