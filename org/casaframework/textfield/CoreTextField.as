/*
	CASA Framework for ActionScript 2.0
	Copyright (C) 2007  CASA Framework
	http://casaframework.org
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

import org.casaframework.movieclip.CoreMovieClip;
import org.casaframework.util.MovieClipUtil;
import TextField.StyleSheet;

/**
	CoreTextField is actually a CoreMovieClip class that uses composition to emulate the standard Flash TextField class. By doing this, it is now possible to extend TextFields where it would otherwise be impossible due to the limitations of TextField instantiation in AS 2.0. All TextField classes should extend from here.
	
	@author Aaron Clinger
	@author Mike Creighton
	@version 04/09/07
	@example
		<code>
			var myText_mc:CoreTextField = CoreTextField.create(this, "text_mc", null, 250, 50);
			this.myText_mc.border = this.myText_mc.background = true;
			this.myText_mc.text = "Hello World!";
		</code>
*/

class org.casaframework.textfield.CoreTextField extends CoreMovieClip {
	public  var field_txt:TextField; /**< @exclude */
	
	
	/**
		Creates an empty instance of the CoreTextField class. Use this instead of a traditional <code>new</code> constructor statement due to limitations of ActionScript 2.0.
		
		@param target: Location where the TextField should be attached.
		@param instanceName: A unique instance name for the TextField.
		@param depth: <strong>[optional]</strong> The depth level where the TextField is placed; defaults to next highest open depth.
		@param width: A positive integer that specifies the width of the new text field.
		@param height: A positive integer that specifies the height of the new text field.
		@return Returns a reference to the created instance.
		@example <code>var myText_mc:CoreTextField = CoreTextField.create(this, "text_mc", null, 250, 50);</code>
	*/
	public static function create(target:MovieClip, instanceName:String, depth:Number, width:Number, height:Number):CoreTextField {
		var tf:CoreTextField = CoreTextField(MovieClipUtil.createMovieRegisterClass('org.casaframework.textfield.CoreTextField', target, instanceName, depth));
		
		tf._width  = width;
		tf._height = height;
		
		return tf;
	}
	
	
	private function CoreTextField() {
		super();
		
		this.createTextField('field_txt', 1, 0, 0, 200, 100);
		
		var context:CoreTextField = this;
		
		this.field_txt.onChanged = function(changedField:TextField):Void {
			context.onChanged(changedField);
		};
		
		this.field_txt.onKillFocus = function(newFocus:Object):Void {
			context.onKillFocus(newFocus);
		};
		
		this.field_txt.onScroller = function(scrolledField:TextField):Void {
			context.onScroller(scrolledField);
		};
		
		this.field_txt.onSetFocus = function(oldFocus:Object):Void {
			context.onSetFocus(oldFocus);
		};
		
		this.$setClassDescription('org.casaframework.textfield.CoreTextField');
	}
	
	/**
		@exclude 
	*/
	public static function getFontList():Array {
		return TextField.getFontList();
	}
	
	/**
		@exclude
	*/
	public function addListener(listener:Object):Boolean {
		return this.field_txt.addListener(listener);
	}
	
	/**
		@exclude
	*/
	public function getNewTextFormat():TextFormat {
		return this.field_txt.getNewTextFormat();
	}
	
	/**
		@exclude
	*/
	public function getTextFormat(beginIndex:Number, endIndex:Number):TextFormat {
		return this.field_txt.getTextFormat(beginIndex, endIndex);
	}
	
	/**
		@exclude
	*/
	public function onChanged(changedField:TextField):Void {}
	
	/**
		@exclude
	*/
	public function onKillFocus(newFocus:Object):Void {}
	
	/**
		@exclude
	*/
	public function onScroller(scrolledField:TextField):Void {}
	
	/**
		@exclude
	*/
	public function onSetFocus(oldFocus:Object):Void {}
	
	/**
		@exclude
	*/
	public function removeListener(listener:Object):Boolean {
		return this.field_txt.removeListener(listener);
	}
	
	/**
		@exclude
	*/
	public function replaceSel(newText:String):Void {
		this.field_txt.replaceSel(newText);
	}
	
	/**
		@exclude
	*/
	public function replaceText(beginIndex:Number, endIndex:Number, newText:String):Void {
		this.field_txt.replaceText(beginIndex, endIndex, newText);
	}
	
	/**
		@exclude
	*/
	public function setNewTextFormat(tf:TextFormat):Void {
		this.field_txt.setNexTextFormat(tf);
	}
	
	/**
		@exclude
	*/
	public function setTextFormat():Void {
		this.field_txt.setTextFormat.apply(this.field_txt, arguments);
	}
	
	/**
		@exclude
	*/
	public function get menu():ContextMenu {
		return this.field_txt.menu;
	}
	
	/**
		@exclude
	*/
	public function set menu(m:ContextMenu):Void {
		this.field_txt.menu = m;
	}
	
	/**
		@exclude
	*/
	public function get antiAliasType():String {
		return this.field_txt.antiAliasType;
	}
	
	/**
		@exclude
	*/
	public function set antiAliasType(a:String):Void {
		this.field_txt.antiAliasType = a;
	}
	
	/**
		@exclude
	*/
	public function get autoSize():Object {
		return this.field_txt.autoSize;
	}
	
	/**
		@exclude
	*/
	public function set autoSize(s:Object):Void {
		this.field_txt.autoSize = s;
	}
	
	/**
		@exclude
	*/
	public function get background():Boolean {
		return this.field_txt.background;
	}
	
	/**
		@exclude
	*/
	public function set background(b:Boolean):Void {
		this.field_txt.background = b;
	}
	
	/**
		@exclude
	*/
	public function get backgroundColor():Number {
		return this.field_txt.backgroundColor;
	}
	
	/**
		@exclude
	*/
	public function set backgroundColor(c:Number):Void {
		this.field_txt.backgroundColor = c;
	}
	
	/**
		@exclude
	*/
	public function get border():Boolean {
		return this.field_txt.border;
	}
	
	/**
		@exclude
	*/
	public function set border(b:Boolean):Void {
		this.field_txt.border = b;
	}
	
	/**
		@exclude
	*/
	public function get borderColor():Number {
		return this.field_txt.borderColor;
	}
	
	/**
		@exclude
	*/
	public function set borderColor(c:Number):Void {
		this.field_txt.borderColor = c;
	}
	
	/**
		@exclude
	*/
	public function get bottomScroll():Number {
		return this.field_txt.bottomScroll;
	}
	
	/**
		@exclude
	*/
	public function set bottomScroll(s:Number):Void {
		this.field_txt.bottomScroll = s;
	}
	
	/**
		@exclude
	*/
	public function get condensWhite():Boolean {
		return this.field_txt.condensWhite;
	}
	
	/**
		@exclude
	*/
	public function set condensWhite(c:Boolean):Void {
		this.field_txt.condensWhite = c;
	}
	
	/**
		@exclude
	*/
	public function get embedFonts():Boolean {
		return this.field_txt.embedFonts;
	}
	
	/**
		@exclude
	*/
	public function set embedFonts(e:Boolean):Void {
		this.field_txt.embedFonts = e;
	}
	
	/**
		@exclude
	*/
	public function get gridFitType():String {
		return this.field_txt.gridFitType;
	}
	
	/**
		@exclude
	*/
	public function set gridFitType(t:String):Void {
		this.field_txt.gridFitType = t;
	}
	
	/**
		@exclude
	*/
	public function get hscroll():Number {
		return this.field_txt.hscroll;
	}
	
	/**
		@exclude
	*/
	public function set hscroll(s:Number):Void {
		this.field_txt.hscroll = s;
	}
	
	/**
		@exclude
	*/
	public function get html():Boolean {
		return this.field_txt.html;
	}
	
	/**
		@exclude
	*/
	public function set html(h:Boolean):Void {
		this.field_txt.html = h;
	}
	
	/**
		@exclude
	*/
	public function get htmlText():String {
		return this.field_txt.htmlText;
	}
	
	/**
		@exclude
	*/
	public function set htmlText(t:String):Void {
		this.field_txt.htmlText = t;
	}
	
	/**
		@exclude
	*/
	public function get length():Number {
		return this.field_txt.length;
	}
	
	/**
		@exclude
	*/
	public function set length(l:Number):Void {
		this.field_txt.length = l;
	}
	
	/**
		@exclude
	*/
	public function get maxChars():Number {
		return this.field_txt.maxChars;
	}
	
	/**
		@exclude
	*/
	public function set maxChars(m:Number):Void {
		this.field_txt.maxChars = m;
	}
	
	/**
		@exclude
	*/
	public function get maxhscroll():Number {
		return this.field_txt.maxhscroll;
	}
	
	/**
		@exclude
	*/
	public function set maxhscroll(m:Number):Void {
		this.field_txt.maxhscroll = m;
	}
	
	/**
		@exclude
	*/
	public function get maxscroll():Number {
		return this.field_txt.maxscroll;
	}
	
	/**
		@exclude
	*/
	public function set maxscroll(m:Number):Void {
		this.field_txt.maxscroll = m;
	}
	
	/**
		@exclude
	*/
	public function get mouseWheelEnabled():Boolean {
		return this.field_txt.mouseWheelEnabled;
	}
	
	/**
		@exclude
	*/
	public function set mouseWheelEnabled(e:Boolean):Void {
		this.field_txt.mouseWheelEnabled = e;
	}
	
	/**
		@exclude
	*/
	public function get multiline():Boolean {
		return this.field_txt.multiline;
	}
	
	/**
		@exclude
	*/
	public function set multiline(m:Boolean):Void {
		this.field_txt.multiline = m;
	}
	
	/**
		@exclude
	*/
	public function get password():Boolean {
		return this.field_txt.password;
	}
	
	/**
		@exclude
	*/
	public function set password(p:Boolean):Void {
		this.field_txt.password = p;
	}
	
	/**
		@exclude
	*/
	public function get restrict():String {
		return this.field_txt.restrict;
	}
	
	/**
		@exclude
	*/
	public function set restrict(r:String):Void {
		this.field_txt.restrict = r;
	}
	
	/**
		@exclude
	*/
	public function get scroll():Number {
		return this.field_txt.scroll;
	}
	
	/**
		@exclude
	*/
	public function set scroll(s:Number):Void {
		this.field_txt.scroll = s;
	}
	
	/**
		@exclude
	*/
	public function get selectable():Boolean {
		return this.field_txt.selectable;
	}
	
	/**
		@exclude
	*/
	public function set selectable(s:Boolean):Void {
		this.field_txt.selectable = s;
	}
	
	/**
		@exclude
	*/
	public function get sharpness():Number {
		return this.field_txt.sharpness;
	}
	
	/**
		@exclude
	*/
	public function set sharpness(s:Number):Void {
		this.field_txt.sharpness = s;
	}
	
	/**
		@exclude
	*/
	public function get styleSheet():StyleSheet {
		return this.field_txt.styleSheet;
	}
	
	/**
		@exclude
	*/
	public function set styleSheet(s:StyleSheet):Void {
		this.field_txt.styleSheet = s;
	}
	
	/**
		@exclude
	*/
	public function get tabEnabled():Boolean {
		return this.field_txt.tabEnabled;
	}
	
	/**		@exclude
	*/
	public function set tabEnabled(e:Boolean):Void {
		this.field_txt.tabEnabled = e;
	}
	
	/**
		@exclude
	*/
	public function get tabIndex():Number {
		return this.field_txt.tabIndex;
	}
	
	/**
		@exclude
	*/
	public function set tabIndex(i:Number):Void {
		this.field_txt.tabIndex = i;
	}
	
	/**
		@exclude
	*/
	public function get text():String {
		return this.field_txt.text;
	}
	
	/**
		@exclude
	*/
	public function set text(t:String):Void {
		this.field_txt.text = t;
	}
	
	/**
		@exclude
	*/
	public function get textColor():Number {
		return this.field_txt.textColor;
	}
	
	/**
		@exclude
	*/
	public function set textColor(c:Number):Void {
		this.field_txt.textColor = c;
	}
	
	/**
		@exclude
	*/
	public function get textHeight():Number {
		return this.field_txt.textHeight;
	}
	
	/**
		@exclude
	*/
	public function set textHeight(h:Number):Void {
		this.field_txt.textHeight = h;
	}
	
	/**
		@exclude
	*/
	public function get textWidth():Number {
		return this.field_txt.textWidth;
	}
	
	/**
		@exclude
	*/
	public function set textWidth(w:Number):Void {
		this.field_txt.textWidth = w;
	}
	
	/**
		@exclude
	*/
	public function get thickness():Number {
		return this.field_txt.thickness;
	}
	
	/**
		@exclude
	*/
	public function set thickness(t:Number):Void {
		this.field_txt.thickness = t;
	}
	
	/**
		@exclude
	*/
	public function get type():String {
		return this.field_txt.type;
	}
	
	/**
		@exclude
	*/
	public function set type(t:String):Void {
		this.field_txt.type = t;
	}
	
	/**
		@exclude
	*/
	public function get variable():String {
		return this.field_txt.variable;
	}
	
	/**
		@exclude
	*/
	public function set variable(v:String):Void {
		this.field_txt.variable = v;
	}
	
	/**
		@exclude
	*/
	public function get wordWrap():Boolean {
		return this.field_txt.wordWrap;
	}
	
	/**
		@exclude
	*/
	public function set wordWrap(w:Boolean):Void {
		this.field_txt.wordWrap = w;
	}
	
	/**
		@exclude
	*/
	public function get _width():Number {
		return this.field_txt._width;
	}
	
	/**
		@exclude
	*/
	public function set _width(w:Number):Void {
		this.field_txt._width = w;
	}
	
	/**
		@exclude
	*/
	public function get _height():Number {
		return this.field_txt._height;
	}
	
	/**
		@exclude
	*/
	public function set _height(h:Number):Void {
		this.field_txt._height = h;
	}
	
	/**
		Removes the TextField after automatically calling {@link #destroy}.
		
		@usageNote <code>removeTextField</code> and {@link #destroy} work identically; you can call either method to destory and remove the TextField.
	*/
	public function removeTextField():Void {
		this.destroy();
	}
	
	public function destroy():Void {
		this.field_txt.removeTextField();
		
		super.destroy();
	}	
}
