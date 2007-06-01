/*
* Basic Sound   ---------------------- B E T A ---------------------- 
*
* @author		Nicholas Almeida
* @version		2.0
* @history		MTASC Compatible.
*
* @usage		
	import as2classes.sound.SimpleSound;
	
	var geral:SimpleSound = new SimpleSound();
		geral.attachSound("loop");
		geral.startFadeIn();
	
*/

import caurina.transitions.Tweener;
import as2classes.util.Delegate;

class as2classes.sound.SimpleSound {
	
	public var mc:MovieClip;
	public var soundId:String;
	
	public var soundObj:Sound;
	
	public var isPaused:Boolean;
	
	private var repeat:Boolean;
	private var fadeTime:Number;
	private var volMax:Number;
	private var volMin:Number;
	private var soundPosition:Number;
	
	function SimpleSound($mc:MovieClip){
		var d = new Date();
		mc = $mc || _root.createEmptyMovieClip("mcSimpleSound_" + d.getMilliseconds(), _root.getNextHighestDepth());
		delete d;
		
		soundObj = new Sound(mc);
	
		isPaused = false;
		fadeTime = 2;
		volMax = 100;
		volMin = 0;
		repeat = true;
		
		/*
		* DEBUG
		* 
		as2classes.util.Global.setVar("soundObj", soundObj)
		var tmp = setInterval(function(){
			trace("-> " + as2classes.util.Global.getVar("soundObj").position);
		}, 100);
		*/
	}
	
	public function attachSound($soundId:String):Void{
		soundId = $soundId;
		soundObj.attachSound(soundId);
	}
	
	public function startFadeIn($volMax:Number, $fadeTime:Number, $loop:Boolean):Void{
		trace("Sound \"" + soundId + "\" started with fade in.");
		
		if($volMax) volMax = $volMax;
		if($fadeTime) fadeTime = $fadeTime;
		if($loop != undefined) repeat = $loop;
		
		
		soundObj.setVolume(0);
		start(0, repeat);
		fadeIn();
	}
	
	public function pauseFadeOut($volMin:Number, $fadeTime:Number, $onComplete:Function):Void{
		
		if($fadeTime) fadeTime = $fadeTime;
		if($volMin) volMin = $volMin;
		
		Tweener.removeTweens(soundObj);
		Tweener.addTween(soundObj, {_sound_volume:volMin, time:fadeTime, onComplete: Delegate.create(this, pause, $onComplete)});
	}
	
	public function resumeFadeIn($volMax:Number, $fadeTime:Number, $onComplete:Function):Void{
	
		if($fadeTime) fadeTime = $fadeTime;
		if($volMax) volMax = $volMax;
		
		resume();
		fadeIn(volMax, fadeTime, $onComplete);
	}	
	
	public function fadeIn($volMax:Number, $fadeTime:Number, $onComplete:Function):Void{
		Tweener.removeTweens(soundObj);
		Tweener.addTween(soundObj, {_sound_volume:($volMax ? $volMax : volMax), time:($fadeTime ? $fadeTime : fadeTime), onComplete:Delegate.create(this, function(){$onComplete()})});
	}
	
	public function fadeOut($volMin:Number, $fadeTime:Number, $onComplete:Function):Void{
		Tweener.removeTweens(soundObj);
		Tweener.addTween(soundObj, {_sound_volume:($volMin ? $volMin : volMin), time:($fadeTime ? $fadeTime : fadeTime), onComplete: Delegate.create(this, pause)});
	}	
	
	public function pause($onComplete:Function):Void{
		$onComplete();
		
		soundObj.stop();
		
		soundPosition = soundObj.position;
		isPaused = true;
		
		trace("Sound \"" + soundId + "\" paused.");		
	}
	
	public function resume():Void{
		if(isPaused) {
			soundObj.start(soundPosition/1000 || 0);
			isPaused = false;
			
			trace("Sound \"" + soundId + "\" resumed.");
		} else {
			trace("Sound \"" + soundId + "\" already playing.");
		}
	}
	
	public function start($position:Number, $loop:Boolean):Void{
		trace("Sound \"" + soundId + "\" started.");
		repeat = $loop
		soundPosition = $position || 0;
		
		soundObj.start(soundPosition);
		
		soundObj.onSoundComplete = Delegate.create(this, doLoop);
	}
	
	public function stop():Void{
		trace("Sound \"" + soundId + "\" stoped.");
		soundObj.stop();
		soundPosition = 0;
	}
	
	private function doLoop():Void{
		if(repeat) soundObj.start();
		else stop();
	}
	
}

















