/**
 * SWFAddress 2.0: Deep linking for Flash and Ajax - http://www.asual.com/swfaddress/
 * 
 * SWFAddress is (c) 2006-2007 Rostislav Hristov and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

class as2classes.util.SWFAddressEvent {

    public static var INIT:String = 'init';
    public static var CHANGE:String = 'change';
        
    private var _type:String;
    private var _value:String;
    private var _path:String;
    private var _parameters:Object;
    
    public function SWFAddressEvent(type:String) {
        _type = type;
        _value = as2classes.util.SWFAddress.getValue();
        _path = as2classes.util.SWFAddress.getPath();
        _parameters = new Array();
        var names:Array = as2classes.util.SWFAddress.getParameterNames();
        for (var i:Number = 0, n:String; n = names[i]; i++) {
            _parameters[n] = as2classes.util.SWFAddress.getParameter(n);
        }
    }

    public function get type():String {
        return _type;
    }

    public function get target():Object {
        return as2classes.util.SWFAddress;
    }

    public function get value():String {
        return _value;
    }

    public function get path():String {
        return _path;
    }

    public function get parameters():Object {
        return _parameters;
    }
}