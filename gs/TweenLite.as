﻿/*
VERSION: 4.0
DATE: 8/3/2007
ACTIONSCRIPT VERSION: 2.0 (AS3 version is also available)
UPDATES AT: http://www.TweenLite.com 
DESCRIPTION:
	TweenLite provides a lightweight (about 3k), easy way to tween almost any property of any object over time including 
	a MovieClip's volume and color. You can easily tween multiple properties at the same time. You can even tween arrays. 
	There are advanced features that allow you to build in a delay, call any function when the tween has completed (even 
	passing any number of parameters you define), automatically kill other tweens that are affecting the same object 
	(to avoid conflicts), etc. One of the big benefits of this class (and the reason "Lite" is in the name) is that it was 
	carefully built to minimize file size. There are several other Tweening engines out there, but in my experience, they 
	required more than triple the file size which was unacceptable when dealing with strict file size requirements 
	(like banner ads). I haven't been able to find a faster tween engine either. The syntax is simple and the class doesn't 
	rely on complicated prototype alterations that can cause problems with certain compilers. TweenLite is simple, very fast, 
	and more lightweight than any other popular tweening engine.

PARAMETERS:
	1) t: Target MovieClip (or other object) whose properties we're tweening
	2) d: Duration (in seconds) of the tween
	3) v: An object containing the end values of all the properties you'd like to have tweened (or if you're using the 
	      TweenLite.from() method, these variables would define the BEGINNING values). For example:
					  _alpha: The alpha (opacity level) that the target object should finish at (or begin at if you're 
							  using TweenLite.from()). For example, if the target_obj._alpha is 100 when this script is 
					  		  called, and you specify this argument to be 50, it'll transition from 100 to 50.
					  _x: To change a MovieClip's x position, just set this to the value you'd like the MovieClip to 
					      end up at (or begin at if you're using TweenLite.from()). 
				  SPECIAL PROPERTIES:
				  	  delay: Amount of delay before the tween should begin (in seconds).
					  volume: To change a MovieClip's volume, just set this to the value you'd like the MovieClip to
					          end up at (or begin at if you're using TweenLite.from()).
					  mcColor: To change a MovieClip's color, set this to the hex value of the color you'd like the MovieClip
					  		   to end up at(or begin at if you're using TweenLite.from()). An example hex value would be 0xFF0000
					  ease: You can specify a function to use for the easing with this variable. For example, 
					        mx.transitions.easing.Elastic.easeOut. The Default is Regular.easeOut (and Linear.easeNone for volume).
					  onStart: If you'd like to call a function as soon as the tween begins, pass in a reference to it here.
					  		   This is useful for when there's a delay. 
					  onStartParams: An array of parameters to pass the onStart function. (this is optional)
					  onComplete: If you'd like to call a function when the tween has finished, use this. 
					  onCompleteParams: An array of parameters to pass the onComplete function (this is optional)
					  overwrite: If you do NOT want the tween to automatically overwrite any other tweens that are 
					             affecting the same target, make sure this value is false.
	4) dl: **DEPRECATED** [optional] Amount of delay before the tween should begin (in seconds). As of version 3.0, this 
						  has been deprecated - use the "delay" property of v like TweenLite.to(mc, 1, {_x:20, delay:3.5});
	5) oc: **DEPRECATED** [optional] A reference to a function that you'd like to call as soon as this tween is complete.
						  As of version 3.0, this has been deprecated - use the "onComplete" property of v like 
						  TweenLite.to(mc, 1, {_x:20, onComplete:onFinishTween});
	6) oca: **DEPRECATED** [optional] An array of parameters to pass the oc function when this tween is finished.
						   As of version 3.0, this has been deprecated - use the "onCompleteParams" property of v like 
						   TweenLite.to(mc, 1, {_x:20, onComplete:onFinishTween, onCompleteParams:[1, mc]});
	7) ao: **DEPRECATED** [optional] If true or undefined, all other tweens that are affecting the target are deleted. You can use it to
					  	  prevent collisions with other tweens. If you know there won't be any collisions, you can pass false 
					  	  in order to speed things up slightly. As of version 3.0, this has been deprecated - use the 
						  "overwrite" property of v like TweenLite.to(mc, 1, {_x:20, overwrite:false});
	

EXAMPLES: 
	As a simple example, you could tween the _alpha to 50% and move the _x position of a MovieClip named "clip_mc" 
	to 120 and fade the volume to 0 over the course of 1.5 seconds like so:
	
		gs.TweenLite.to(clip_mc, 1.5, {_alpha:50, _x:120, volume:0});
		
	To set up a sequence where we fade a MovieClip to 50% opacity over the course of 2 seconds, and then slide it down
	to _y coordinate 300 over the course of 1 second:
	
		import gs.TweenFilterLite;
		TweenFilterLite.to(clip_mc, 2, {_alpha:50});
		TweenFilterLite.to(clip_mc, 1, {_y:300, delay:2, overwrite:false});
	
	If you want to get more advanced and tween the clip_mc MovieClip over 5 seconds, changing the _alpha to 50%, 
	the _x to 120 using the "easeOutBack" easing function, delay starting the whole tween by 2 seconds, and then call
	a function named "onFinishTween" when it has completed and pass in a few parameters to that function (a value of
	5 and a reference to the clip_mc), you'd do so like:
		
		import gs.TweenLite;
		import mx.transitions.easing.Back;
		TweenLite.to(clip_mc, 5, {_alpha:50, _x:120, ease:Back.easeOut, delay:2, onComplete:onFinishTween, onCompleteParams:[5, clip_mc]});
		function onFinishTween(argument1_num:Number, argument2_mc:MovieClip):Void {
			trace("The tween has finished! argument1_num = " + argument1_num + ", and argument2_mc = " + argument2_mc);
		}
	
	If you have a MovieClip on the stage that is already in it's end position and you just want to animate it into 
	place over 5 seconds (drop it into place by changing its _y property to 100 pixels higher on the screen and 
	dropping it from there), you could:
		
		import gs.TweenLite;
		import mx.transitions.easing.Elastic;
		TweenLite.from(clip_mc, 5, {_y:clip_mc._y - 100, ease:Elastic.easeOut});		
	

NOTES:
	- This class will add about 2kb to your Flash file.
	- You can tween the volume of any MovieClip using the tween property "volume", like:
	  TweenLite.to(myClip_mc, 1.5, {volume:0});
	- You can tween the color of a MovieClip using the tween property "mcColor", like:
	  TweenLite.to(myClip_mc, 1.5, {mcColor:0xFF0000});
	- To tween an array, just pass in an array as a property (it doesn't matter what you name it) like:
	  var myArray_array = [1,2,3,4];
	  TweenLite.to(myArray_array, 1.5, {end_array:[10,20,30,40]});
	- You can kill all tweens for a particular object (usually a MovieClip) anytime with the 
	  TweenLite.killTweensOf(myClip_mc); function.
	- You can kill all delayedCalls to a particular function using TweenLite.killDelayedCallsTo(myFunction_func);
	  This can be helpful if you want to preempt a call.
	- Use the TweenLite.from() method to animate things into place. For example, if you have things set up on 
	  the stage in the spot where they should end up, and you just want to animate them into place, you can 
	  pass in the beginning _x and/or _y and/or _alpha (or whatever properties you want).

CODED BY: Jack Doyle, jack@greensock.com
Copyright 2007, GreenSock (This work is subject to the terms in http://www.greensock.com/terms_of_use.html.)
*/

class gs.TweenLite {
	private static var _e:MovieClip; //A reference to the empty MovieClip that we use to drive all our onEnterFrame actions.
	private static var _all:Array = new Array(); //Holds references to all our tweens.
	static var deleteFor:Function = killTweensOf; //For backwards compatibility.
	
	var _d:Number; //Duration (in seconds)
	var _v:Object; //Variables (holds things like _alpha or _y or whatever we're tweening)
	var _dl:Number; //Delay (in seconds)
	var _oc:Function; //The function that should be triggered when this tween has completed
	var _oca:Array; //An array containing the parameters that should be passed to the oc function when this tween has finished.
	var _os:Function; //The function that should be triggered when this tween starts (useful for when there's a delay)
	var _osa:Array; //An array containing the parameters that should be passed to the _os function
	var _ts:Number; //Start time
	var _ti:Number; //Time of initialization. Remember, we can build in delays so this property tells us when the frame action was born, not when it actually started doing anything.
	var _twa:Array; //Contains parsed data for each property that's being tweened (each has to have a taget_obj, endTarget_obj, start_num, a change_num, and an ease).
	var _act:Boolean; //If true, this tween is active. 
	var _snd:Sound; //We only use this in cases where the user wants to change the volume of a MovieClip (they pass in a "volume" property in the v)
	var _dead:Boolean; //If true, this TweenLite is marked for destruction, so don't hijack it.
	var _tg:Object; //Target object (usually a MovieClip)
	var _etg:Object; //End target. It's almost always the same as _tg except for volume and color tweens. It helps us to see what object or MovieClip the tween really pertains to (so that we can killTweensOf() properly and hijack auto-overwritten ones)
	var _color:Color;
	var _colorParts:Object; //rb, gb, and bb
	
	public function TweenLite(t:Object, d:Number, v:Object, dl:Number, oc:Function, oca:Array, ao:Boolean) {
		var tl = this; //Default value. We swap this out if we the auto-overwrite is true and we find another TweenLite that's controling the same target object.
		var found = false;
		if (v.overwrite != false && ao != false && t != undefined) { //ao stands for Auto-Overwrite. We used to just call killTweensOf(tween_obj), but rewrote slightly lengthier code here to basically hijack the first existing tween we find for the object because it runs much faster and avoids extra loops later.
			var fa = _all.slice();
			for (var i = fa.length - 1; i >= 0; i--) {
				if (fa[i]._etg == t && !fa[i]._dead) {
					if (!found) {
						tl = this = fa[i];		
						found = true;
					} else {
						removeTween(fa[i]);
					}
				}
			}
		}
		tl._dead = false;
		tl._tg = tl._etg = t;
		tl._d = d;
		tl._v = v;
		tl._oc = v.onComplete || oc;
		tl._oca = v.onCompleteParams || oca;
		tl._os = v.onStart;
		tl._osa = v.onStartParams;
		tl._dl = v.delay || dl || 0;
		if (tl._v.ease == undefined) {
			tl._v.ease = easeOut;
		} else if (typeof(tl._v.ease) != "function") {
			trace("ERROR: You cannot use '"+tl._v.ease+"' for the TweenLite ease property. Only functions are accepted.");
		}
		tl._twa = [];
		tl._ti = getTimer();
		if (tl._v.runBackwards == true) {
			tl.initTweenVals();
		}
		tl._act = false;
		var a = this.act; //Just to trigger the onStart() if necessary.
		if (!found) {
			_all.push(tl);
			if (_e._visible != false) { //We were running into strange issues in nested SWFs where _e was defined but wasn't valid. As a workaround, we had to test its _visible property to find out if it's really valid. This empty MovieClip will have the onEnterFrame handler attached to it which will call all our actions.
				initEmptyMC();
			}
			_e.onEnterFrame = executeAll;
		}
	}
	
	public function initTweenVals():Void {
		var ndl = _dl - ((getTimer() - _ti) / 1000); //new delay. We need this because reversed (TweenLite.from() calls) need to maintain the delay in any sub-tweens (like for color or volume tweens) but normal TweenLite.to() tweens should have no delay because this function gets called only when the begin!
		if (_tg instanceof Array) {
			var endArray = [];
			for (var p in _v) { //First find an instance of an array in the _v to match up with. There should never be more than one.
				if (_v[p] instanceof Array) {
					endArray = _v[p];
					break;
				}
			}
			var l = endArray.length;
			for (var i = 0; i < l; i++) {
				if (_tg[i] != endArray[i] && _tg[i] != undefined) {
					_twa.push({o:_tg, p:i.toString(), s:_tg[i], c:endArray[i] - _tg[i], e:_v.ease}); //o: object, p:property, s:starting value, c:change in value, e: easing function
				}
			}
		} else {
			for (var p in _v) {
				if (p == "volume" && typeof(_tg) == "movieclip") { //If we're trying to change the volume of a MovieClip, then set up a quasai proxy using an instance of a TweenLite to control the volume.
					_snd = new Sound(_tg);
					var volTween = new TweenLite(this, _d, {volumeProxy:_v[p], ease:easeNone, delay:ndl, overwrite:false, runBackwards:_v.runBackwards});
					volTween._etg = _tg;
				} else if (p.toLowerCase() == "mccolor" && typeof(_tg) == "movieclip") { //If we're trying to change the color of a MovieClip, then set up a quasai proxy using an instance of a TweenLite to control the color.
					_color = new Color(_tg);
					_colorParts = _color.getTransform();
					var c = _colorParts;
					var endColor_obj;
					if (_v[p] == null || _v[p] == "") { //In case they're actually trying to remove the colorization, they should pass in null or "" for the mcColor
						endColor_obj = {rb:0, gb:0, bb:0, ra:100, ga:100, ba:100, ease:_v.ease, delay:ndl, overwrite:false, runBackwards:_v.runBackwards};
					} else {
						endColor_obj = {rb:(_v[p] >> 16), gb:(_v[p] >> 8) & 0xff, bb:(_v[p] & 0xff), ra:0, ga:0, ba:0, ease:_v.ease, delay:ndl, overwrite:false, runBackwards:_v.runBackwards};
					}
					var partsTween = new TweenLite(c, _d, endColor_obj);
					var colorTween = new TweenLite(this, _d, {colorProxy:1, delay:ndl, overwrite:false, runBackwards:_v.runBackwards}); 
					partsTween._etg = colorTween._etg = _tg;
				} else if (!isNaN(_v[p]) && p != "delay" && p != "overwrite" && p != "runBackwards") {
					_twa.push({o:_tg, p:p, s:_tg[p], c:_v[p] - _tg[p], e:_v.ease}); //o: object, p:property, s:starting value, c:change in value, e: easing function
				}
			}
		}
		if (_v.runBackwards == true) {
			var tp;
			for (var i = 0; i < _twa.length; i++) {
				tp = _twa[i];
				tp.s += tp.c;
				tp.c *= -1;
				tp.o[tp.p] = tp.e(0, tp.s, tp.c, _d);
			}
		}
	}
	
	public static function to(t:Object, d:Number, v:Object, dl:Number, oc:Function, oca:Array, ao:Boolean):TweenLite {
		return new TweenLite(t, d, v, dl, oc, oca, ao);
	}
	
	//This function really helps if there are objects (usually MovieClips) that we just want to animate into place (they are already at their end position on the stage for example). 
	public static function from(t:Object, d:Number, v:Object, dl:Number, oc:Function, oca:Array, ao:Boolean):TweenLite {
		v.runBackwards = true;
		return new TweenLite(t, d, v, dl, oc, oca, ao);;
	}
	
	public static function delayedCall(dl:Number, oc:Function, oca:Array):TweenLite {
		return new TweenLite(null, null, null, dl, oc, oca);
	}
	
	public function render():Void {
		var time = (getTimer() - _ts) / 1000;
		if (time > _d) {
			time = _d;
		}
		for (var i = 0; i < _twa.length; i++) {
			var tp = _twa[i];
			tp.o[tp.p] = tp.e(time, tp.s, tp.c, _d);
		}
		if (time >= _d) { //Check to see if we're done
			_dead = true; //This is necessary in cases where the _oc function we're about to call spawns a new TweenLite with the same _tg (target object) in which case it would try to hijack it and then when we call removeTween() below, it kills that next TweenLite. This allows us to keep track of when a TweenLite is marked for destruction and we check for this variable before hijacking (we won't hijack one that's marked for destruction).
			if (_oc) {
				_oc.apply(null, _oca);
			}
			removeTween(this);
		}
	}
	
	public static function removeTween(t:TweenLite):Void {
		for (var i = _all.length - 1; i >= 0; i--) {
			if (_all[i] == t) {
				killTweenAt(i);
				break;
			}
		}
	}
	
	public static function killDelayedCallsTo(f:Object):Void {
		for (var i = _all.length - 1; i >= 0 ; i--) {
			if ((_all[i]._oc == f && _all[i]._tg == null) || _all[i]._tg == f) { //Oddly enough, when you pass the killTweensOf a reference to a class, it's percieved as a function.
				killTweenAt(i);
			}
		}
	}
	
	public static function killTweensOf(tg:Object):Void {
		if (typeof(tg) == "function") {
			killDelayedCallsTo(tg);
		} else {
			for (var i = _all.length - 1; i >= 0 ; i--) {
				if (_all[i]._etg == tg) {
					killTweenAt(i);
				}
			}
		}
	}
	
	private static function killTweenAt(i:Number):Void {
		delete _all[i];
		_all.splice(i, 1);
		if (_all.length == 0) {
			_e.onEnterFrame = null; //Frees up resources.
		}
	}
	
	public static function executeAll():Void {
		var fa = _all.slice(); //Another tween may get added to the _all array during the time it takes to complete this function in which case the new ones may get fired immediately. So we slice the array to ensure that we're just working with a copy of the original array that was in tact at the beginning of this function.
		var l = fa.length;
		for (var i = 0; i < l; i++) {
			if (fa[i].act) {
				fa[i].render();
			}
		}
	}
	
	public static function initEmptyMC():MovieClip {
		if (!_root.tweenLite_mc) { //If this MovieClip is being loaded inside another, there may already be a tweenLite_mc set up in which case we should use that one. Otherwise, set up a new one.
			var l = _root.getNextHighestDepth();
			if (!l) {
				l = 9999; //In case we're publishing to Flash 6 and the getNextHighestDepth() doesn't work, just use this really high level number. We could use the gs.utils.LevelsManager, but in the interest of minimizing file size and bloat, we're using this technique.
			}
			_e = _root.createEmptyMovieClip("tweenLite_mc", l);
			_e.swapDepths(-1); //We shoot this down to level -1 because sometimes developers assume levels at 0 and above are open and just hard-code new MovieClips into those levels without doing a getNextHighestDepth(). We swapDepths just in case there is already a MovieClip on level -1 - that way we don't kill it (replace it).
		} else {
			_e = _root.tweenLite_mc;
		}
		_e._visible = false;
		return _e;
	}
	
	//Default ease function for tweens other than _alpha (Regular.easeOut)
	private static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
		return -c * (t /= d) * (t - 2) + b;
	}
	//Default ease function for volume tweens
	private static function easeNone(t:Number, b:Number, c:Number, d:Number):Number {
		return c * t / d + b;
	}
	
//---- GETTERS / SETTERS -----------------------------------------------------------------------
	
	public function get act():Boolean {
		if (_act) {
			return true;
		} else if ((getTimer() - _ti) / 1000 > _dl) {
			_act = true;
			_ts = getTimer();
			if (_v.runBackwards != true) {
				initTweenVals();
			}
			if (_os != undefined) {
				_os.apply(null, _osa);
			}
			if (_d == 0) { //We can't pass 0 to the easing function, otherwise it won't return the final value, so we pad it ever so slightly here and also adjust the startTime to compensate so that things are precise. We could do this in the render() function, but that would slow things down slightly since it's called on every frame. This way, we only evaluate this once and keep things speedy.
				_d = 0.001;
				_ts -= 1;
			}
			return true;
		} else {
			return false;
		}
	}
	public function set volumeProxy(n:Number):Void { //Used as a proxy of sorts to control the volume of the target MovieClip.
		_snd.setVolume(n);
	}
	public function get volumeProxy():Number { //Used as a proxy of sorts to get the volume of the target MovieClip.
		return _snd.getVolume();
	}
	public function set colorProxy(n:Number):Void { //It doesn't matter what value is passed in - this is just a way of forcing the color to update itself
		_color.setTransform(_colorParts);
	}
	public static function get all():Array {
		return _all;
	}
}