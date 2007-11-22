/*
	AS2classes Framework for ActionScript 2.0
	Copyright (C) 2007  Nicholas Almeida
	http://nicholasalmeida.com
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	http://www.gnu.org/licenses/lgpl.html
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
*/

import as2classes.util.Delegate;
import as2classes.form.ScrollMovieclipComponent;

/**
	ComboBox Component. A lightweight combobox component.
	
	@author Nicholas Almeida
	@version 27/06/07
	@since Flash Player 8
	@example
		<code>
			mcCombo:ComboBoxComponent = new ComboBoxComponent(mcCombo);
			
			var arrData:Array = [
									{value:0, label:"Select", selected: true},
									{value:1, label:"Option 1"},
									{value:2, label:"Option 2"},
									{value:3, label:"Option 3"},
									{value:4, label:"Option 4"}
								]
			
			mcCombo.init({
				title: "Combo Test",
				data: arrData,
				rows: 5, 
				direction: "up"
			});
			
			mcCombo.onChanged = function(arr:Array){
				trace("mc: " + arr[0] + " -- value: " + arr[1] + " -- label: " + arr[2]);
			}
			
			testButton.onRelease = function(){
				trace("getSelected mc: " + mcCombo.getSelected()[0] + " -- value: " + mcCombo.getSelected()[1] + " -- label: " + mcCombo.getSelected()[2]);
				trace("selectedIndex: " + mcCombo.getSelectedIndex());
			}
		</code>
*/

class as2classes.form.ComboBoxComponent extends MovieClip{
	
	public var mc:MovieClip;
	
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
	private var rows_old:Number;
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
	
	public var _type:String;
	public var customErrorMessage:String;
	
	/**
		ComboBox Component constructor.
		
		@param $mc:MovieClip - Movieclip to be used as the component.
		@return Return none.
	*/
	function ComboBoxComponent($mc:MovieClip, objectSetup:Object){
		this._type = "combobox";
		
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
		
		if(objectSetup) init(objectSetup);
	}
	
	/**
		Initialize the Combobox Component.
		
		@param obj:Object - Object notation to get the real parameters.
		@param obj.title:String - Title used to validade the form.
		@param obj.required:Boolean - Used on form validation to set the field as required.
		@param obj.tabIndex:Number or Booblean - Number represents the tabIndex value. To disable the tabIndex, set it to false. Default value 1.
		
		@param obj.rows:Number - Determine visible portion of Combobox. Minimum 2.
		@param obj.width:Number - Combobox width.
		@param obj.direction:String - Determines if Combobox will open above or under. Valid values "up" or "down". Defalut "".
		@param obj.data:Array - Initial Combobox data.
		@param obj.customErrorMessage:String - Custom message to use with FormValidator class .
		@return Return none.
	*/
	public function init(obj:Object):Void{
		
		// Title
		if(!obj.title) trace("WARNING on ComboBox: " + mc + " parameter \"title\" not defined.");
		title = obj.title || mc._name;
		
		rows = (obj.rows) ? obj.rows : 3;
		if(rows<3) rows = 2; // min = 2
		rows_old = rows;
		
		if(obj.width) width = obj.width;
		
		if(obj.direction.toLowerCase() === "up") direction = "up";
	
		if(obj.required != undefined) required = obj.required;
		
		close();

		// Data
		if(!obj.data) trace("ERROR on ComboBox: " + mc + " parameter \"data\" not defined.");
		arrData = obj.data;
		setData(arrData);
		
		// Tab
		if(obj.tabIndex === false){
			mcBt.tabEnabled = false;
		} else {
			mcBt.tabEnabled = true;
			mcBt.tabIndex = obj.tabIndex || 1;
		}
		
		if(obj.customErrorMessage) customErrorMessage = obj.customErrorMessage;
	}
	
	/**
		Set Combobox data.
		
		@param $arrData:Array - Data array. Each array value MUST be an object with "label" and "value" paramenters. Eg.: [{value: 1, label: "test 1"}]
		@return Return none.
	*/
	public function setData($arrData:Array):Void{
		arrData = $arrData;
		var selectedItem:Number;
		
		clear();
		
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
			
			enable();
		}

		setSize(initSize.w);
		
		if(selectedItem != undefined) setSelected(selectedItem); // select
		delete selectedItem;
		
		sliceItens();
		
		scroll.reset();
		
		mcItem._visible = false;
	}
	
	/**
		Clear Combobox data, remove the internal Movieclips and sets the value to undefined;
		
		@return Return none.
	*/
	public function clear():Void{
		arrItens = [];
		
		for (var i in mcComboItensHolder) {
			if(mcComboItensHolder[i]._name != "mcItem") {
				mcComboItensHolder[i].removeMovieClip();
			}
		}
		
		value = undefined;
		disable();
	}
	
	/**
		Select an Combobox item.
		
		@param $index:Number - Combobox item index. If you have 5 items and want to select de 2nd, $index should be 1.
		@return Return none.
	*/	
	public function setSelected($index:Number):Void{
		index = $index;
		sliceText(textField, arrData[index].label);
		value = arrData[index].value;
		if(onChanged) onChanged([mc, value, arrData[index].label]);
		close();
	}
	
	/**
		Get the Combobox item.
		
		@return Return Array - [Movieclip, Value, Label]. 
	*/
	public function getSelected():Array{
		return [mc, value, arrData[index].label];
	}
	
	/**
		Get the current index of the Combobox selected item.
		
		@return Return Number - Combobox selected item .
	*/
	public function getSelectedIndex():Number{
		return index;
	}
	
	/**
		Get all Combobox data.
		
		@return Return Array - All Combobox data.
	*/
	public function getData():Array{
		return arrData;
	}
	
	/**
		Get all Combobox internal Movieclips.
		
		@return Return Array - Combobox internal Movieclips.
	*/
	public function getItens():Array{
		return arrItens;
	}
	
	/**
		Enable Combobox.
		
		@return Return none
	*/
	public function enable():Void{
		scroll.enable();
		mcBt.enabled = true;
		mcArrow._alpha = 
		mcComboText._alpha = 100;
	}
	
	/**
		Disable Combobox.
		
		@return Return none
	*/
	public function disable():Void{
		close();
		scroll.disable();
		mcBt.enabled = false;
		mcArrow._alpha = 
		mcComboText._alpha = 50;
	}
	
	/**
		Set the Combobox width.
		
		@param width:Number - Width.
		@return Return none
	*/
	public function setSize(width:Number):Void{
		
		maxWidth = width - mcArrow._width;

		if(rows_old >= arrItens.length) {
			rows = arrItens.length;
			hideScroll();
		} else {
			rows = rows_old;
			scroll.visibleStatus = "visible";
		}
		
		mcBg._height = mcMask._height = arrItens[0]._height * rows;
		
		ajustSize();
		
		scroll.init({mcMask:mcMask, mcMasked:mcComboItensHolder});
		scroll.setHeight(mcMask._height);
	}
	
	/**
		Ajust the Scroll size avoiding the Movieclip deformation.
		
		@return Return none.
	*/
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
	
	/**
		Hide the Combobox scroll.
		
		@return Return none.
	*/
	public function hideScroll():Void{
		scroll.hide();
	}
	
	/**
		Hide the Combobox scroll.
		
		@return Return none.
	*/
	public function showScroll():Void{
		scroll.show();
	}
	
	/**
		Open Combobox.
		
		@return Return none.
	*/
	public function open():Void{
		if(scroll.visibleStatus != "hidden") mcScroll._visible = true;
		
		mcBg._visible = 
		mcComboItens._visible = true;
		
		isOpened = true;
		
		scroll.reset();
	}
	
	/**
		Close Combobox.
		
		@return Return none.
	*/
	public function close():Void{
		if(scroll.visibleStatus != "hidden") mcScroll._visible = false;
		
		mcBg._visible = 
		mcComboItens._visible = false;
		
		isOpened = false;
	}
	
	/**
		If the Combobox is opened, close else open it.
		
		@return Return none.
	*/
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
	
	/**
		Set Combobox to the 0 index.
		
		@return Return none
	*/
	public function reset():Void{
		setSelected(0);
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
