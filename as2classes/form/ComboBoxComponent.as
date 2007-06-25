/**
* ComboBox Component
* @author Nicholas Almeida
* @version 0.1
* @history 	25/07/2007 : Some bugs fixed when it's compiled by MTASC
* 			18/07/2007 : Created
*/

import as2classes.util.Delegate;
import as2classes.form.ScrollMovieclipComponent;

class as2classes.form.ComboBoxComponent extends MovieClip{
	
	private var mc:MovieClip;
	
	private var mcBt:Button;
	private var mcComboItens:MovieClip;
		private var mcComboItensHolder:MovieClip;
			private var mcItem:MovieClip
		private var mcMask:MovieClip;
	private var mcBg:MovieClip;

	private var mcArrow:MovieClip;
	private var mcComboText:MovieClip;
		private var mcComboTextBg:MovieClip;
	
	private var textField:TextField;
	private var mcScroll:MovieClip;
	private var scroll:ScrollMovieclipComponent;
	private var maxWidth:Number;
	private var rows:Number;
	public var  onChanged:Function;
	private var initSize:Object;
	private var index:Number;
	
	public var required:Boolean;
	public var title:Boolean;
	public var value;
	public var width:Number;
	public var direction:String;
	
	private var arrData:Array;
	private var arrItens:Array;
	private var isOpened:Boolean;
		
	function ComboBoxComponent($mc:MovieClip){
		mc = $mc || this;
		mc.isFormField = true;
		mcBt = mc.mcBt;
		mcComboItens = mc.mcComboItens;
			mcComboItensHolder = mc.mcComboItens.mcComboItensHolder;
				mcItem = mc.mcComboItens.mcComboItensHolder.mcItem;
			mcMask = mc.mcComboItens.mcMask;
		
		mcArrow = mc.mcArrow;
		mcComboText = mc.mcComboText;
			mcComboTextBg = mcComboText.mcComboTextBackground;
			textField = mcComboText.fld_text;
		mcScroll = mc.mcScroll
		scroll = new ScrollMovieclipComponent(mcScroll);
		mcBg = mc.mcBg
		
		
		mcBt.onPress = Delegate.create(this, pressArrow);
		mcBt.onRelease = 
		mcBt.onReleaseOutside = Delegate.create(this, releaseArrow);
		
		mcBt.useHandCursor = false;
				
		mc.onMouseDown = Delegate.create(this, checkOpenClose);
		
		initSize = {};
			initSize.w = mc._width;
			initSize.h = mc._height;
		
		maxWidth = 0;
		
		direction = "down";
		
		arrData = [];
		arrItens = [];
		
		close();
	}
	
	public function init(obj:Object):Void{
		
		// Title
		if(!obj.title) trace("WARNING on ComboBox: " + mc + " parameter \"title\" not defined.");
		title = obj.title || mc._name;
		
		rows = (obj.rows) ? obj.rows : 3;
		if(rows<3) rows = 2; // min = 2
		
		if(obj.width) width = obj.width;
		
		if(obj.direction.toLowerCase() === "up") direction = "up";
	
		if(obj.required != undefined) required = obj.required;
		
		close();

		// Data
		if(!obj.data) trace("ERROR on ComboBox: " + mc + " parameter \"data\" not defined.");
		arrData = obj.data;
		setData(arrData);
		
		// Tab
		mcBt.tabEnabled = true;
		mcBt.tabIndex = obj.tabIndex || 1;
	}
	
	public function setData($arrData:Array):Void{
		arrData = $arrData;
		arrItens = [];
		var selectedItem:Number;
		
		// removing existend MovieClips
		for (var i in mcComboItensHolder) {
			if(mcComboItensHolder[i]._name != "mcItem") {
				mcComboItensHolder[i].removeMovieClip();
			}
		}
		
		for (var i:Number = 0; i<arrData.length; i++) {
			var newItem:MovieClip = mcItem.duplicateMovieClip("mcItem_"+i, i, {_y:mcItem._height*i});
				newItem.fld_text.autoSize = false;

				newItem.onRollOver = Delegate.create(this, overItem, newItem);
				
				newItem.onDragOut = 
				newItem.onRollOut = Delegate.create(this, outItem, newItem);
				
				newItem.onRelease = Delegate.create(this, setSelected, i);
				
				newItem.useHandCursor = false;
		
			if(arrData[i].selected === true) selectedItem = i;
			
			arrItens.push(newItem);
		}

		setSize(initSize.w);
		
		if(selectedItem != undefined) setSelected(selectedItem); // select
		delete selectedItem;
		
		sliceItens();
		
		mcItem._visible = false;
	}
	
	public function setSelected($index:Number):Void{
		index = $index;
		sliceText(textField, arrData[index].label);
		value = arrData[index].value;
		if(onChanged) onChanged([mc, value, arrData[index].label]);
		close();
	}
	
	public function getSelected():Array{
		return [mc, value, arrData[index].label];
	}
	
	public function getSelectedIndex():Number{
		return index;
	}
	
	public function getData():Array{
		return arrData;
	}
	
	public function getItens():Array{
		return arrItens;
	}
	
	public function enable():Void{
		scroll.enable();
		mcBt.enabled = true;
		mcArrow._alpha = 
		mcComboText._alpha = 100;
	}
	
	public function disable():Void{
		close();
		scroll.disable();
		mcBt.enabled = false;
		mcArrow._alpha = 
		mcComboText._alpha = 50;
	}
	
	public function setSize(width:Number):Void{
		
		maxWidth = width - mcArrow._width;

		ajustSize();
		
		mcBg._height = mcMask._height = arrItens[0]._height * rows;
		
		scroll.init({mcMask:mcMask, mcMasked:mcComboItensHolder});
		scroll.setHeight(mcMask._height);
	}
	
	public function ajustSize():Void{
		mc._xscale = mc._yscale = 100;

		mcScroll._x = 
		mcMask._width = 
		mcBg._width = 
		textField._width = 
		mcComboTextBg._width = maxWidth;

		mcBt._width = initSize.w;
		
		mcArrow._x = textField._width;
		
		mcBg._x = mcComboItens._x = textField._x;
		mcBg._y = mcComboItens._y = textField._height;
		
		mcBt._width = maxWidth + mcArrow._width;
		
		for (var i:Number = 0; i<arrItens.length; i++) {
			arrItens[i].fld_text._width = 
			arrItens[i].mcBase._width = maxWidth+1;
		}
		
		if(direction == "up"){
			mcBg._y = -(arrItens[0]._height * rows)+1;
			mcComboItens._y = mcBg._y;
			mcScroll._y = mcBg._y+1;
		}
		
	}
	
	public function open():Void{
		mcScroll._visible = 
		mcBg._visible = 
		mcComboItens._visible = true;
		
		isOpened = true;
	}
	
	public function close():Void{
		mcScroll._visible = 
		mcBg._visible = 
		mcComboItens._visible = false;
		
		isOpened = false;
	}
	
	public function openClose():Void{
		if(isOpened) close();
		else open();
	}
	
	private function checkOpenClose():Void{
		if(direction === "up"){
			if(mc._xmouse < 0 || mc._xmouse > mc._width || mc._ymouse < mcBg._y || mc._ymouse  > textField._height){
				close();
			}
		} else {
			if(mc._xmouse < 0 || mc._xmouse > mc._width || mc._ymouse<0 || mc._ymouse > mcMask._height + textField._height){
				close();
			}
		}
	}
	
	private function sliceText(fld:TextField, text:String):Void{
		fld.text = text;
	
		var tmpText:Array;
		var newText:String = "";
		
		if(fld.textWidth > fld._width){
			tmpText = text.split("");
			for (var i:Number = 0; i<tmpText.length; i++) {
				newText += tmpText[i];
				fld.text = newText;
				if(fld.textWidth >= fld._width) {
					newText = newText.slice(0,-3) + "...";
					fld.text = newText;
					break;
				}
			}
		} 
	}
	
	private function sliceItens():Void{
		for (var i:Number = 0; i<arrItens.length; i++) {
			sliceText(arrItens[i].fld_text, arrData[i].label);
		}
	}
	
	/*
	* Item Stuff
	*/
	//{
	private function overItem(item:MovieClip):Void{
		item.mcBase.gotoAndStop("over");
	}
	
	private function outItem(item:MovieClip):Void{
		item.mcBase.gotoAndStop("out");
	}
	//}
	
	/*
	* Arrows Stuff
	*/
	//{
	private function pressArrow():Void{
		mcArrow.gotoAndStop("release");
		openClose();
	}
	
	private function releaseArrow():Void{
		mcArrow.gotoAndStop("out");
	}
	//}
}
