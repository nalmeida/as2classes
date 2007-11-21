/**
 * SWFAddress 2.0: Deep linking for Flash and Ajax - http://www.asual.com/swfaddress/
 * 
 * SWFAddress is (c) 2006-2007 Rostislav Hristov and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

import flash.external.ExternalInterface;
import mx.events.EventDispatcher;

class as2classes.util.SWFAddress {

    private static var _init:Boolean = false;
    private static var _strict:Boolean = true;
    private static var _value:String = '';
    private static var _interval:Number;
    private static var _availability:Boolean = ExternalInterface.available;
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    private static var _initializer:Boolean = _initialize();

    public static var onInit:Function;
    public static var onChange:Function;

    private static function _initialize():Boolean {
        if (_availability) {
            ExternalInterface.addCallback('getSWFAddressValue', SWFAddress, 
                function():String {return this._value});
            ExternalInterface.addCallback('setSWFAddressValue', SWFAddress, 
                SWFAddress._setValue);
        }
        if (typeof _level0.$swfaddress != 'undefined') 
            SWFAddress._value = _level0.$swfaddress;
        _interval = setInterval(SWFAddress._check, 10);
        return true;
    }

    private static function _check():Void {
        if ((typeof SWFAddress.onInit == 'function' || typeof _dispatcher['__q_init'] != 'undefined') && !_init) {
            _dispatchEvent('init');
        }
        if (typeof SWFAddress.onChange == 'function' || typeof _dispatcher['__q_change'] != 'undefined') {
            clearInterval(_interval);
            SWFAddress._setValue(_getValue());
        }
    }

    private static function _strictCheck(value:String, force:Boolean):String {
        if (_strict) {
            if (force) {
                if (value.substr(0, 1) != '/') value = '/' + value;
                var qi:Number = value.indexOf('?');
                if (qi != -1) {
                    value = value.substr(qi - 1, 1) != '/' ? value.substr(0, qi) + '/' + value.substr(qi) : value;
                } else {
                    if (value.substr(value.length - 1) != '/') value += '/';
                }
            } else {
                if (value == '') value = '/';
            }
        }
        return value;
    }

    private static function _getValue():String {
        var value:String, id:String = 'null';
        if (_availability) {
            value = String(ExternalInterface.call('SWFAddress.getValue'));
            id = String(ExternalInterface.call('SWFAddress.getId'));
        }
        if (id == 'undefined' || id == 'null' || !_availability) {
            value = SWFAddress._value;
        } else {
            if (value == 'undefined' || value == 'null') value = '';
        }
        return _strictCheck(value, false);
    }

    private static function _setValue(value:String):Void {
        if (value == 'undefined' || value == 'null') value = '';
        if (SWFAddress._value == value && SWFAddress._init) return;
        SWFAddress._value = value;
        SWFAddress._init = true;
        _dispatchEvent('change');
    }
    
    private static function _dispatchEvent(type:String):Void {    
        if (typeof _dispatcher['__q_' + type] != 'undefined') {
            _dispatcher.dispatchEvent(new as2classes.util.SWFAddressEvent(type));
        }
        type = type.substr(0, 1).toUpperCase() + type.substring(1);
        if (typeof SWFAddress['on' + type] == 'function') {
            SWFAddress['on' + type]();
        }
    }

    public static function toString():String {
        return '[class SWFAddress]';
    }

    public static function back():Void {
        if (_availability)
            ExternalInterface.call('SWFAddress.back');
    }

    public static function forward():Void {
        if (_availability)
            ExternalInterface.call('SWFAddress.forward');
    }
    
    public static function go(delta:Number):Void {
        if (_availability)
            ExternalInterface.call('SWFAddress.go', delta);
    }

    public static function href(url:String, target:String):Void {
        if (_availability) {
            ExternalInterface.call('SWFAddress.href', url, target);
        } else {
            getURL(url, target);
        }
    }

    public static function popup(url:String, name:String, options:String, handler:String):Void {
        if (_availability) {
            ExternalInterface.call('SWFAddress.popup', url, name, options, handler);
        } else {
            getURL('javascript:window.open("' + url + '","' + name + '","' + options + '");');
        }
    }

    public static function addEventListener(type:String, listener:Function):Void {
        _dispatcher.addEventListener(type, listener);
    }

    public static function removeEventListener(type:String, listener:Function):Void {
        _dispatcher.removeEventListener(type, listener);
    }

    public static function dispatchEvent(event:Object):Void {
        _dispatcher.dispatchEvent(event);
    }
    
    public static function hasEventListener(type:String):Boolean {
        return (typeof _dispatcher['__q_' + type] != 'undefined');
    }

    public static function getStrict():Boolean {
        return Boolean((_availability) ? 
            ExternalInterface.call('SWFAddress.getStrict') : _strict);
    }

    public static function setStrict(strict:Boolean):Void {
        if (_availability)
            ExternalInterface.call('SWFAddress.setStrict', strict);
        _strict = strict;
    }

    public static function getHistory():Boolean {
        return Boolean((_availability) ? 
            ExternalInterface.call('SWFAddress.getHistory') : false);
    }

    public static function setHistory(history:Boolean):Void {
        if (_availability)
            ExternalInterface.call('SWFAddress.setHistory', history);
    }

    public static function getTracker():String {
        return (_availability) ? 
            String(ExternalInterface.call('SWFAddress.getTracker')) : '';
    }

    public static function setTracker(tracker:String):Void {
        if (_availability)
            ExternalInterface.call('SWFAddress.setTracker', tracker);
    }

    public static function getTitle():String {
        var title:String = (_availability) ? 
            String(ExternalInterface.call('SWFAddress.getTitle')) : '';
        if (title == 'undefined' || title == 'null') title = '';
        return title;
    }

    public static function setTitle(title:String):Void {
        if (_availability) ExternalInterface.call('SWFAddress.setTitle', title);
    }
    
    public static function getStatus():String {
        var status:String = (_availability) ? 
            String(ExternalInterface.call('SWFAddress.getStatus')) : '';
        if (status == 'undefined' || status == 'null') status = '';
        return status;
    }

    public static function setStatus(status:String):Void {
        if (_availability) ExternalInterface.call('SWFAddress.setStatus', status);
    }
    
    public static function resetStatus():Void {
        if (_availability) ExternalInterface.call('SWFAddress.resetStatus');
    }

    public static function getValue():String {
        if (_init)
            return _strictCheck(_value, false);
        else
            return _strictCheck(_availability ? String(ExternalInterface.call('SWFAddress.getValue')) : '', false);
    }

    public static function setValue(value:String):Void {
        if (value == 'undefined' || value == 'null') value = '';
        value = _strictCheck(value, true);
        if (SWFAddress._value == value) return;
        SWFAddress._value = value;
        if (_availability) ExternalInterface.call('SWFAddress.setValue', value);
        _dispatchEvent('change');
		trace("SWFAddress.setValue(\"" + value + "\")");
    }
    
    public static function getPath():String {
        var value:String = SWFAddress.getValue();
        if (value.indexOf('?') != -1) {
            return value.split('?')[0];
        } else {
            return value;
        }
    }

    public static function getQueryString():String {
        var value:String = SWFAddress.getValue();
        var index:Number = value.indexOf('?');
        if (index != -1 && index < value.length) {
            return value.substr(index + 1);
        }
        return '';
    }

    public static function getParameter(param:String):String {
        var value:String = SWFAddress.getValue();
        var index:Number = value.indexOf('?');
        if (index != -1) {
            value = value.substr(index + 1);
            var params:Array = value.split('&');
            var p:Array;
            var i:Number = params.length;
            while(i--) {
                p = params[i].split('=');
                if (p[0] == param) {
                    return p[1];
                }
            }
        }
        return '';
    }

    public static function getParameterNames():Array {
        var value:String = SWFAddress.getValue();
        var index:Number = value.indexOf('?');
        var names:Array = new Array();
        if (index != -1) {
            value = value.substr(index + 1);
            if (value != '' && value.indexOf('=') != -1) {
                var params:Array = value.split('&');
                var i:Number = 0;
                while(i < params.length) {
                    names.push(params[i].split('=')[0]);
                    i++;
                }
            }
        }
        return names;
    }
}