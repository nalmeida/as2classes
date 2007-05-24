/**
* Connects a flash movie from the ActiveX component to the FlashDevelop program.
* @author Nick Farina
* @version 1.0
*/

class org.flashdevelop.utils.FlashOut
{
	static function trace(msg:Object)
	{
		fscommand("trace", msg.toString());
	}
}
