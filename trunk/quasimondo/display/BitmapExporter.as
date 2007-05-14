	
	//------------------------------------------------------------	
	//
	// BitmapExporter Class v1.6
	//
	// Author:  Mario Klingemann
	// Contact: mario@quasimondo.com
	// Site: 	http://www.quasimondo.com
	//
	//
	// Simple Usage:
	//
	// BitmapExporter.gatewayURL = "http://www.yourserver.com/yourscripts/BitmapExporter.php";
	// BitmapExporter.saveBitmap( bitmapDataObject, "test.jpg" );
	//
	// Options:
	// 
	// BitmapExporter.timeslice = 2000;
	// This will set the maximum allowed time for each Bitmap Scanning pass to
	// 2000 milliseconds. This is in order to avoid the "Flash is running slow"
	// warning message. You can experiment with higher values.
	//
	//
	//
	// BitmapExporter.blocksize = 100000;
	// Only applies to palette modes. This will set the maximum data chunk size that is sent 
	// in on pass to 100000 bytes.
	// A value to experiment with - I have experienced some strange supposedly flash initiated
	// timeouts with high values in the standalone player. 
	//
	//
	// BitmapExporter.connectionTimeout = 5000;
	// The amount of milliseconds after which the connection will be reset if the server
	// does not answer.
	//
	//
	// Events:
	// 
	//  BitmapExporter.addEventListener("progress", this);
	//	BitmapExporter.addEventListener("status", this);
	//	BitmapExporter.addEventListener("complete", this);
	//	BitmapExporter.addEventListener("error", this);
	//  BitmapExporter.addEventListener("saved", this);
	//
	//
	//  Syntax:
	//  BitmapExporter.saveBitmap( bitmap:BitmapData, filename:String, [mode:String], [lossBits:Number], [jpegQuality:Number], [dontRetrieve:Boolean] );
	//
	//  bitmap: accepts transparent and non-transparent BitmapData objects, but currenty
	//  the transparency information is ignored and a opaque white background is applied
	//  to transparent images. This might change in a later version.
	//
	//
	//  filename: The suffix of the filename automatically decides which output format you get, possible values are:
	//  "yourfilename.jpg" or "yourfilename.jpeg" for JPEG format
	//  "yourfilename.png" for PNG format
	//  "yourfilename.bmp" for BMP format
	//
	//
	//  mode: currently supported values for "mode" are:
	//
	//  "turboscan":  pixels are converted to base10 - no timeout checking, no bitmask. Fastest scan, but biggest data size.
	//  "fastscan":   pixels are converted to base36 - with timer check, 
	//  "default":    pixels are converted to base128 
	//  "lzw":        pixels are converted to base128, then lzw compressed
	//  "palette":    a lookup table is created and the pixels are run length encoded
	//  ("palettelzw": a lookup table is created and the pixels are run length encoded then both get lzw compressed)
	//  NOTE: "palettelzw" is currently not non-functional. There seems to be a bug in the encoding
	//
	//
	// lossbits: is a bitmask that strips away least significant bits in order to
	// get a better compression rate by having more equal bytes in succession possible
	// for the price of reduced quality. Possible values come between 0 and 7.
	//
	//
	//  jpegquality: is a value between 0 and 100 and sets the jpeg compression rate.
	//
	//
	//  Version History:
	//  v1.1: - fixed Timeout bug that occured when cancelling a save
	//
	//  v1.2: - changed the temporaty file handling: data chunks are now stored
	//		    as strings in a tempory file on the server (instead of partial
	//	        PNGs and converted to bitmaps at the retrieval stage.
	//        - improved the timeout handling. In earlier versions the
	//		    the system warning could sometims get triggered with very wide bitmaps
	//		  - slightly reduced the data overhead with "turbscan", "fastscan",
	//          "default","lzw" modes
	//		  - an clone of the to be saved bitmap is created in order to 
	//          avoid that the data gets changed or deleted during the saving
	//          process
	//        - made a tiny change to the onAddPixelBlock error handling
	//        - added httpStatus event handling
	//
	//  v1.3: - added the dontRetrieve option which allows to just save a
	//			bitmap on the server without automatically popping up the
	//			download window
	//        - added deleteImage() function to delete an uploaded image from
	//			the server manually
	//
	//  v1.4  - made several changes to ensure MTASC compatibility
	//        - added optional mx.utils.Delegate class for net.hiddenresource.util.Delegate
	//
	//  v1.5  - changed the target of all events from "this" to "BitmapExporter" 
	//        - made several optimizations on the server side which greatly reduce memory requirements
	//
	// v1.6   - fixed a bug in the BMP encoding on the server side
	//
	//   License:
	//   
	//   NON-COMMERCIAL/PRIVATE USE:
	//   The use of the BitmapExporter package is free for all non-commercial
	//   work if PROPER ATTRIBUTION is given. "non-commercial" means that you
	//   do not get paid for this work or you do not intend to sell it. 
	//   "proper attribution" is a credit line somewhere visible along your
	//   piece of work which reads like this: 
	//   
	//   "[Insert your work title here] uses BitmapExporter by <a href="http://www.quasimondo.com">Mario Klingemann</a>"
	//
	//   If you cannot comply to this rule please contact me for a special
	//   permission at mario@quasimondo.com
	//
	//   COMMERCIAL USE:
	//   The use of the BitmapExporter package is NOT AUTOMATICALLY FREE for 
	//   all commercial works or services.
	//   
	//   If you are able to show the follwing attribution line along with the work:
	//   "[Insert your product title here] uses BitmapExporter by <a href="http://www.quasimondo.com">Mario Klingemann</a>"
	//   there is no license fee though it would be better for your karma if
	//	 you shared a tiny amount of the money you get paid for this job with me.
	//   
	//   If you do not want to or are not able to show the credit line
	//   the one time license fee is US$300.- per site/product
	//
	//   Please contact me for special agency/studio conditions regarding licensing for 
	//   multiple sites/products/clients: mario@quasimondo.com
	//
	//---------------------------------------------------------------------
	
	
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import mx.events.EventDispatcher;
	
	//import mx.utils.Delegate;
	import net.hiddenresource.util.Delegate
	// exchange the Delegate class if you intend to compile
	// with MTASC
	
	class com.quasimondo.display.BitmapExporter 
	{
		
		public  static var gatewayURL:String        = "http://localhost/BitmapExporter.php";
		public  static var timeslice:Number         = 1000;
		public  static var blocksize:Number         = 50000;
		public  static var connectionTimeout:Number = 5000;
		
		private static var instance:BitmapExporter;
		
   	  	public  static var addEventListener:Function;
	    public  static var removeEventListener:Function;
		private static var dispatchEvent:Function;
		
		private static var emptycount:Array;
		private static var lookup:Array;
		
		private var connectionTimeoutID:Number;
		private var timeoutID:Number;
		
		
		private var initialized:Boolean    = false;
		private var busy:Boolean           = false;
		private var dontRetrieve:Boolean   = false;
		private var saveMode:String;
		private var fileRef:FileReference;
		private var originalCodepageSetting:Boolean;
		private var status:String = "idle";
		private var lastY:Number;
		private var lastX:Number;
		private var pixels:Array;
		private var palette:Array;
		
		private var getpixel:String;
		private var uniqueID:String;
		private var filename:String;
		private var jpegQuality:Number;
		private var bitmap:BitmapData;
		private var bitmapWidth:Number;
		private var bitmapHeight:Number;
		private var sentBytes:Number;
		private var bitmask:Number;
		private var service:LoadVars;
		private var dct:Object;
		private var charlist:String;
		private var chars:Array;
		private var encodeBase:Number = 128;
		private var LZWbuffer:Array;
		private var nextLZWIndex:Number;
		private var lastHTTPStatus:Number;
		
		private function BitmapExporter()
		{
			EventDispatcher.initialize ( BitmapExporter ) ;
			initArrays();
		}
		
		static public function init():Void
		{
			if ( instance == undefined )
			{
				instance = new BitmapExporter();
			}
		}
		
		static public function saveBitmap( bitmap:BitmapData, filename:String, mode:String, lossBits:Number, jpegQuality:Number, dontRetrieve:Boolean ):Boolean
		{
			// currently supported modes are:
			//
			// "turboscan":  pixels are converted to base10 - no timeout checking, no bitmask. Fastest scan, but biggest data size.
			// "fastscan":   pixels are converted to base36 - with timer check, 
			// "default":    pixels are converted to base128 
			// "lzw":        pixels are converted to base128, then lzw compressed
			// "palette":    a lookup table is created and the pixels are run length encoded
			// "palettelzw": a lookup table is created and the pixels are run length encoded then both get lzw compressed
			
			return BitmapExporter.getInstance()._saveBitmap( bitmap, filename, mode, lossBits, jpegQuality, dontRetrieve );
		}
		
		static public function getStatus():String
		{
			return BitmapExporter.getInstance().status;
		}
		static public function getService():LoadVars
		{
			return BitmapExporter.getInstance().service;
		}
		
		static public function resetStatus():Void
		{
			BitmapExporter.getInstance().reset();
		}
		
		static public function cancel():Void
		{
			if ( BitmapExporter.getStatus() != "idle" )
			{
				BitmapExporter.getInstance().dropImageHandle();
				BitmapExporter.getInstance().setStatus( "cancelled" );
			}
		}
		
		static public function getInstance():BitmapExporter
		{
			if ( instance == undefined )
			{
				instance = new BitmapExporter();
			}
			return instance;
		}
		
		static public function deleteImage( externalID:String ):Void
		{
			BitmapExporter.getInstance().dropImageHandle( externalID );
		}
		
		private function _saveBitmap( _bitmap:BitmapData, _filename:String, mode:String, lossBits:Number, _jpegQuality:Number, _dontRetrieve:Boolean ):Boolean
		{
			if ( status == "idle" && _bitmap != null && _bitmap.height > 0 && _bitmap.width > 0 && _filename!=null )
			{
				originalCodepageSetting = System.useCodepage;
				System.useCodepage      = true;
				bitmap                  = _bitmap.clone();
				filename                = _filename;
				jpegQuality             = _jpegQuality;
				bitmapWidth             = bitmap.width;
				bitmapHeight            = bitmap.height;
				getpixel                = new String( bitmap.transparent ? "getPixel32" :  "getPixel" );
				dontRetrieve            = ( _dontRetrieve == true );
				
				if ( mode == undefined ) mode = "default";
				saveMode                = mode.toLowerCase()
				
				lossBits = Math.floor( Number( lossBits ) );
				if ( isNaN ( lossBits ) ) lossBits = 0;
				if ( lossBits < 0)        lossBits = 0;
				if ( lossBits > 7)        lossBits = 7;
				bitmask = 0xff - ( Math.pow( 2, lossBits ) - 1 );
				bitmask = ( bitmask << 16 ) | ( bitmask << 8 ) | bitmask; 
				
				if ( filename.split(".").pop().toLowerCase() == "bmp" )
				{
					flipBMP();
				}
				
				getImageHandle();
				
				onScanProgress ( 0, "initializing" );
				
				return true;
				
			} else {
				error( "saveBitmap Arguments are not correct" );
				return false;
				
			}
		}
		
		private function reset( keepImage:Boolean ):Void
		{
			if ( !keepImage && uniqueID != null ) dropImageHandle();
			
			setStatus( "idle" );
			busy = false;
			
			bitmap.dispose();
			
			_global.clearTimeout( timeoutID );
			
			System.useCodepage = originalCodepageSetting;
				
			delete uniqueID;
			delete saveMode;
			delete filename;
			delete jpegQuality;
			delete pixels;
			delete palette;
			delete bitmapWidth;
			delete bitmapHeight;
		}
		
		private function initArrays():Void
		{
			emptycount = [];
			
			for ( var i:Number = 0; i < 256; emptycount[ i++ ] = 0 ){}
			
			lookup = [];
			
			for ( var i:Number = 2; i < 256; lookup[i] = String.fromCharCode( i++ ) ){}
			
			var char1:String =  String.fromCharCode(1);
			
			lookup[0]    = char1 + char1;
			lookup[1]    = char1 + String.fromCharCode(2);
			lookup[0x80] = char1 + String.fromCharCode(3);
			lookup[0x82] = char1 + String.fromCharCode(4);
			lookup[0x83] = char1 + String.fromCharCode(5);
			lookup[0x84] = char1 + String.fromCharCode(6);
			lookup[0x85] = char1 + String.fromCharCode(7);
			lookup[0x86] = char1 + String.fromCharCode(8);
			lookup[0x87] = char1 + String.fromCharCode(9);
			lookup[0x88] = char1 + String.fromCharCode(10);
			lookup[0x89] = char1 + String.fromCharCode(11);
			lookup[0x8a] = char1 + String.fromCharCode(12);
			lookup[0x8b] = char1 + String.fromCharCode(13);
			lookup[0x8c] = char1 + String.fromCharCode(14);
			lookup[0x8e] = char1 + String.fromCharCode(15);
			lookup[0x91] = char1 + String.fromCharCode(16);
			lookup[0x92] = char1 + String.fromCharCode(17);
			lookup[0x93] = char1 + String.fromCharCode(18);
			lookup[0x94] = char1 + String.fromCharCode(19);
			lookup[0x95] = char1 + String.fromCharCode(20);
			lookup[0x96] = char1 + String.fromCharCode(21);
			lookup[0x97] = char1 + String.fromCharCode(22);
			lookup[0x98] = char1 + String.fromCharCode(23);
			lookup[0x99] = char1 + String.fromCharCode(24);
			lookup[0x9a] = char1 + String.fromCharCode(25);
			lookup[0x9b] = char1 + String.fromCharCode(26);
			lookup[0x9c] = char1 + String.fromCharCode(27);
			lookup[0x9e] = char1 + String.fromCharCode(28);
			lookup[0x9f] = char1 + String.fromCharCode(29);
			lookup[0x22] = char1 + String.fromCharCode(30);
			lookup[0x27] = char1 + String.fromCharCode(31);
			lookup[0x5c] = char1 + String.fromCharCode(32);
			
			// Lookup Table for Base128 encoding
			charlist = new String();
 			for ( var i:Number = 0; i < encodeBase ; i++ )
			{
	 			charlist += String.fromCharCode( i + 128 );
 			}
 			chars = charlist.split("");
 			
		}
		
		private function getImageHandle():Void
		{
			//trace("Delegate "+Delegate);
			
			setStatus( "contacting server" );
				
			connectionTimeoutID = _global.setTimeout( this, "onConnectionTimeout", connectionTimeout );
			
			initService();
			service.mode    = "getImageHandle";
			service.width   = bitmapWidth;
			service.height  = bitmapHeight;
			service.onLoad  = Delegate.create( this, onImageHandle );
			service.sendAndLoad( gatewayURL, service, "POST" );
			
			
		}
		
		private function scanBitmap():Void
		{
			var pixel:Number;
			
			if ( status == "contacting server" )
			{
				setStatus( "sending" );
				lastX     = 0;
				lastY     = 0;
				sentBytes = 0;
				busy      = false;
				
			} else if ( lastY == bitmapHeight )
			{
				if ( !busy )
				{
					onScanProgress ( 0.95, "retrieving" );
					save();
				} else 
				{
					timeoutID = _global.setTimeout( this, "scanBitmap", 50 );
				}
				return;
			}
			
			var x:Number;
			var y:Number      = lastY;
			var timer:Number  = getTimer();
			var lines:Number  = 0;
			var firstX:Number = lastX;
					
			onScanProgress ( 0.05 + 0.9 * ( lastY / bitmapHeight ), "reading pixels" );
			
			pixels = [];
			
			var tempPixels:Array    = new Array();
			switch ( saveMode ){
				
				case "turboscan":
				
					var i:Number = bitmapWidth * bitmapHeight;
					y            = bitmapHeight - 1;
					if ( bitmap.transparent )
					{
						do {
							x = bitmapWidth;
							do {
								pixels[ --i ] = bitmap.getPixel32( --x, y );
							} while ( x > 0 )
						}  while ( --y > -1 )
					} else 
					{
						do {
							x = bitmapWidth;
							do {
								pixels[ --i ] = bitmap.getPixel( --x, y );
							} while ( x > 0 )
						}  while (  --y > -1 )
					}
					lines = y = bitmapHeight;
					x = bitmapWidth;
					break;
					
				case "fastscan":
				
					do {
						x = lastX;
						lastX = 0;
						do {
							pixels.push( ( bitmap[ getpixel ]( x, y ) & bitmask ).toString(36) );
						} while ( ++x < bitmapWidth  && ( getTimer() - timer < timeslice ))
						if ( x == bitmapWidth )
						{
							lines++;
						} else {
							lastX = x;
							break;
						}
					}  while ( ( ++y < bitmapHeight ) && ( getTimer() - timer < timeslice ) )
				
				break;
				
				case "default":
				
					do {
						x = lastX;
						lastX = 0;
						do {
							pixels.push( bitmap[ getpixel ]( x, y ) & bitmask );
						} while ( ++x  < bitmapWidth && ( getTimer() - timer < timeslice ) )
						if ( x == bitmapWidth )
						{
							lines++;
						} else {
							lastX = x;
							break;
						}
					}  while ( ( ++y  < bitmapHeight ) && ( getTimer() - timer < timeslice ))
				
				break;
				
				case "lzw":
				
					initLZW();
					do {
						x = lastX;
						lastX = 0;
						do {
							addLZWNumber( pixels, bitmap[ getpixel ]( x, y ) & bitmask );
						} while ( ++x  < bitmapWidth && ( getTimer() - timer < timeslice ) )
						
						if ( x == bitmapWidth )
						{
							lines++;
						} else {
							lastX = x;
							break;
						}
						
					}  while ( ( ++y  < bitmapHeight ) && ( getTimer() - timer < timeslice ) && ( nextLZWIndex + bitmapWidth < 0xffff ) )
					
					closeLZW( pixels );	
					
				break;
				
				case "palette":
				
					palette = [];
					var idxLookup:Object    = new Object();
					var lastIdx:Number      = 0;
					var offsetLimit:Boolean = false;
					var bytePointer:Number  = 16;
					var currentByte:Number  = 0;
					var offset:Number;
					var lookup:Number;
					
					do {
						x     = lastX;
						lastX = 0;
						do {
							pixel = bitmap[ getpixel ]( x, y ) & bitmask;
							if ( idxLookup[ pixel ] == null )
							{
								 idxLookup[ pixel ] = palette.push( pixel ) - 1;
							}
							
							lookup  = idxLookup[ pixel ];
							offset  = lookup - lastIdx;
							lastIdx = lookup;
							
							if ( offset < -0x7fff || offset > 0x7fff )
							{
								offsetLimit = true;
								lastX = x;
								if ( bytePointer < 16 )
								{
									tempPixels.push( currentByte );
								}
							} else 
							{
								if ( offset < 0 ) 
								{
									offset += 0x10000;
								}
								currentByte |=  offset << bytePointer;
								bytePointer -= 16;
								if ( bytePointer < 0 )
								{
									tempPixels.push( currentByte );
									bytePointer = 16;
									currentByte = 0;
								}
							}
						} 
						while ( !offsetLimit && ++x  < bitmapWidth )
						lines++;
					}  
					while ( !offsetLimit && ( ++y  < bitmapHeight ) && ( tempPixels.length + palette.length < blocksize ) && ( getTimer() - timer < timeslice ))
				
					if ( !offsetLimit )
					{
						lastX = bitmapWidth;
						if ( bytePointer < 16 )
						{
							tempPixels.push( currentByte );
						}
					}
					
					var lastPixel:Number = tempPixels[ 0 ];
					var c:Number  = 1;
					var tl:Number = tempPixels.length; 
					for ( var i:Number = 1; i < tl; i++ )
					{
						if ( lastPixel == tempPixels[i] )
						{
							c++;
							if ( c == 0x10000 )
							{
								pixels.push( 0x8000ffff, lastPixel );
								c = 1;
							}
						} else {
							if ( c > 1 )
							{
								if ( c > 2 )
								{
									pixels.push( 0x80000000 | c );
								} else 
								{
									pixels.push( lastPixel );
								}
							}
							pixels.push( lastPixel );
							c = 1;
							lastPixel = tempPixels[ i ];
						}
					}
					if ( c > 1 )
					{
						if ( c > 2 )
						{
							pixels.push( 0x80000000 | c );
						} else 
						{
							pixels.push( lastPixel );
						}
					}
					pixels.push( lastPixel );
							
					delete tempPixels;
					delete idxLookup;
					
				break;
				
				case "palettelzw":
				
					palette = [];
					var idxLookup:Object    = new Object();
					var lastIdx:Number      = 0;
					var offsetLimit:Boolean = false;
					var bytePointer:Number  = 16;
					var currentByte:Number  = 0;
					var pIdx:Number         = 0;
					
					var offset:Number;
					var lookup:Number;
				    
					initLZW();
				
					do {
						x     = lastX;
						lastX = 0;
						do {
							pixel = bitmap[ getpixel ]( x, y ) & bitmask;
							if ( idxLookup[ pixel ] == null )
							{
								addLZWNumber( palette, pixel );
								idxLookup[ pixel ] = pIdx++;
							}
							
							lookup = idxLookup[ pixel ];
							offset = lookup - lastIdx;
							
							lastIdx = lookup;
							
							if ( offset < -0x7fff || offset > 0x7fff )
							{
								offsetLimit = true;
								lastX       = x;
								if ( bytePointer < 16 )
								{
									tempPixels.push( currentByte );
								}
								
							} else 
							{
								if ( offset < 0 ) 
								{
									offset += 0x10000;
								}
								currentByte |=  offset << bytePointer;
								bytePointer -= 16;
								if ( bytePointer < 0 )
								{
									tempPixels.push( currentByte );
									bytePointer = 16;
									currentByte = 0;
								}
								
							}
							
						} while ( ( !offsetLimit && ++x  < bitmapWidth ) && ( nextLZWIndex + bitmapWidth < 0xffff ) )
						lines++;
					}  while ( !offsetLimit && ( ++y  < bitmapHeight ) && ( tempPixels.length + palette.length < blocksize ) && ( getTimer() - timer < timeslice ) )
				
					closeLZW( palette );
				
					if ( !offsetLimit )
					{
						lastX =  bitmapWidth;
						if ( bytePointer < 16 )
						{
							tempPixels.push( currentByte );
						}
					}
					
					initLZW();
					var lastPixel:Number = tempPixels[ 0 ];
					var c:Number         = 1;
					var tl:Number        = tempPixels.length;
					
					for ( var i:Number = 1; i < tl; i++ )
					{
						if ( lastPixel == tempPixels[i] )
						{
							c++;
							if ( c == 0x10000 )
							{
								addLZWNumber( pixels, 0x8000ffff );
								addLZWNumber( pixels, lastPixel );
								c=1;
							}
						} else 
						{
							if ( c > 1 )
							{
								if ( c > 2 )
								{
									addLZWNumber( pixels,  0x80000000 | c  );
								} else 
								{
									addLZWNumber( pixels, lastPixel );
									
								}
							}
							addLZWNumber( pixels, lastPixel );
							c = 1;
							lastPixel = tempPixels[i];
						}
					}
					if (c>1)
					{
						if (c>2)
						{
							addLZWNumber( pixels, 0x80000000 | c  );
						} else 
						{
							addLZWNumber( pixels, lastPixel );
						}
					}
					addLZWNumber( pixels, lastPixel );
					closeLZW( pixels );	
					
					delete tempPixels;
					delete idxLookup;
					
				break;
				
				case "rgb_rle":
				
					// in development - not active yet
					
					var pixels_r:Array = [];
					var pixels_g:Array = [];
					var pixels_b:Array = [];
					
					pixel = bitmap[ getpixel ]( lastX, y ) & bitmask;
					
					var pixel_r:Number;
					var pixel_g:Number;
					var pixel_b:Number;
					
					var last_r:Number = (( pixel & 0xff0000 ) >> 16 );
					var last_g:Number = (( pixel & 0x00ff00 ) >> 8 );
					var last_b:Number = (( pixel & 0x00ff00 ) );
					
					pixels_r.push ( last_r );
					pixels_g.push ( last_r );
					pixels_b.push ( last_r );
					
					var r:Number;
					var g:Number;
					var b:Number;
					
					var count_r:Number = 0;
					var count_g:Number = 0;
					var count_b:Number = 0;
					
					var last_rd:Number = 0;
					var last_gd:Number = 0;
					var last_bd:Number = 0;
					
					lastX++;
					if ( lastX == bitmapWidth){
						lastX = 0;
						y++
						lines++;
					}

					do {
						x     = lastX;
						lastX = 0;
						do {
							pixel = bitmap[ getpixel ](  x, y ) & bitmask;
							pixel_r = (( pixel & 0xff0000) >> 16);
					
							r = pixel_r - last_r;
							
							
							if ( r == last_rd && count_r < 0xffff ) 
							{
								count_r++;
							} else {
								if (count_r == 0 ) {
									if (last_rd != r && last_rd!=null){
										pixels_r.push( ( last_rd + 256 ) % 256);
									} else {
										pixels_r.push( ( r + 256 ) % 256);
									}
								} else {
									count_r++;
									pixels_r.push(0);
									for (var i:Number = Math.ceil(count_r/256); --i>-1; ) {
										pixels_r.push(0);
									}
									
									while (count_r>0) {
										pixels_r.push(count_r & 0xff);
										count_r >>= 8;
									}
									
									pixels_r.push(( last_rd + 256 ) % 256);
									
								}
								
							}
							last_r = pixel_r;
							last_rd = r;
							
							pixel_g = ( pixel & 0x00ff00) >> 8;
							g = pixel_g - last_g;
							if ( g == last_gd && count_g < 0xffff ) 
							{
								count_g++;
							} else {
								if (count_g == 0 ) {
									if (last_gd != r && last_gd!=null){
										pixels_g.push( ( last_gd + 256 ) % 256);
									} else {
										pixels_g.push( ( g + 256 ) % 256);
									}
								} else {
									count_g++;
									pixels_g.push(0);
									for (var i:Number = Math.ceil(count_g/256); --i>-1; ) {
										pixels_g.push(0);
									}
									
									while (count_g>0) {
										pixels_g.push(count_g & 0xff);
										count_g >>= 8;
									}
									
									pixels_g.push(( last_gd + 256 ) % 256);
									
								}
								
							}
							last_g = pixel_g;
							last_gd = g;
							
							
							pixel_b = ( pixel & 0x0000ff);
							
							b = pixel_b - last_b;
							if ( b == last_bd && count_b < 0xffff ) 
							{
								count_b++;
							} else {
								if (count_b == 0 ) {
									if (last_bd != r && last_bd!=null){
										pixels_b.push( ( last_bd + 256 ) % 256);
									} else {
										pixels_b.push( ( b + 256 ) % 256);
									}
								} else {
									count_b++;
									pixels_b.push(0);
									for (var i:Number = Math.ceil(count_b/256); --i>-1; ) {
										pixels_b.push(0);
									}
									
									while (count_b>0) {
										pixels_b.push(count_b & 0xff);
										count_b >>= 8;
									}
									
									pixels_b.push(( last_bd + 256 ) % 256);
									
								}
								
							}
							last_b = pixel_b;
							last_bd = b;
							
							
						} while ( ++x  < bitmapWidth  )
						lines++;
					}  while ( ( ++y  < bitmapHeight ) && ( tempPixels.length < blocksize ) && ( getTimer() - timer < timeslice ) )
				
				
				break;
				
			}
			
			addPixelBlock( firstX, lastX, lastY, lines );
			
			lastY  = y;
			lastX %= bitmapWidth;
		}
		
		private function dropImageHandle( externalID:String ):Void
		{
			
			initService();
			service.mode         = "dropImageHandle";
			service.uniqueID     = ( externalID != null ? externalID : uniqueID );
			service.onLoad       = Delegate.create( this, onDropImageHandle );

			service.sendAndLoad( gatewayURL, service, "POST" );
			
		}
			
		private function addPixelBlock( xStart:Number, xEnd:Number, top:Number, lines:Number ):Void
		{
			if (!busy)
			{
				onScanProgress ( 0.05 + 0.9 * ( ( top + lines ) / bitmapHeight ), "sending" );
			
				busy = true;
				
				initService();
				service.mode      = saveMode;
				service.sentBytes = 0;
				service.uniqueID  = uniqueID;
				
				switch ( saveMode ){
					
					case "turboscan":
					case "fastscan":
					 	service.bitmapString  = pixels.join( "," );
					break;
					
					case "default":
						service.bitmapString  = arrayToString( pixels, 24 );
					break;
					
					case "lzw":
						service.bitmapString  = arrayToString( pixels, 16 );
					break;
					
					case "palette":
						service.top           = top;
						service.width         = bitmapWidth;
						service.lines         = lines;
						service.xStart        = xStart;
						service.xEnd          = xEnd;
						service.paletteString = arrayToString( palette, 24 );
						service.bitmapString  = arrayToString( pixels, 32 );
					break;
					
					case "palettelzw":
						service.top           = top;
						service.width         = bitmapWidth;
						service.lines         = lines;
						service.xStart        = xStart;
						service.xEnd          = xEnd;
						service.paletteString = arrayToString( palette, 16 );
						service.bitmapString  = arrayToString( pixels, 16 );
					break;
				}
				
				service.onHTTPStatus = Delegate.create( this, onHTTPStatus );
				service.onLoad       = Delegate.create( this, onAddPixelBlock );
				service.sendAndLoad( gatewayURL, service, "POST" );
				
				timeoutID = _global.setTimeout( this, "scanBitmap", 50 );
				
			} else 
			{
				onScanProgress ( 0.05 + 0.9 * ( ( top + lines ) / bitmapHeight ), "Waiting for Server..." );
				timeoutID = _global.setTimeout( this, "addPixelBlock" , 100, xStart, xEnd, top, lines );
			}
		}
		
		private function save():Void
		{
			if ( status == "sending" )
			{
				delete pixels;
				delete palette;
				
				setStatus( "retrieving" );
				
				initService();
				service.mode         = "save";
				service.width        = bitmapWidth;
				service.height       = bitmapHeight;
				service.uniqueID     = uniqueID;
				service.filename     = filename;
				service.quality      = jpegQuality;
				service.onLoad       = Delegate.create( this, onSave );
				
				service.sendAndLoad( gatewayURL, service, "POST" );
			}
		}
			
		private function arrayToString( data:Array, bits:Number ):String
		{
			var ct:Array = emptycount.slice();
			
			var i:Number = data.length;
			var l:Number = i;
			var n:Number;
			
			do {
				var j:Number = bits;
				n = data[ i ];
				do{
					ct[ n >> j & 0xff ]++;
				} while ( ( j -= 8 )  > -1 )
			}  while ( --i  > -1  )
			
			var xor:Number = 2;
			var lc:Number  = ct[ 2 ] + ct[ 3 ];
			
			for ( i = 3; i < 256 && lc > 0; i++ )
			{
				if ( lookup[ i ].length == 1 && ct[ i ] + ct[ 1 ^ i ] < lc )
				{
					lc = ct[ i ] + ct[ 1 ^ i ];
					xor = i;
				}
			}
			
			
			var a:String = lookup[ xor ];
			i = 0;
			
			// As this part is a long loop I decided to unroll it
			// instead of using if statements
			
			switch ( bits )
			{
				case 8:
					do {
						n = data[ i++ ];
						a += lookup[ ( n & 0xff ) ^ xor ];
					}  while ( --l  > 0 )
				break;
				
				case 16:
					do {
						n = data[ i++ ];
						a += lookup[ ( n >> 8  & 0xff ) ^ xor ];
						a += lookup[ ( n & 0xff ) ^ xor ];
					}  while ( --l  > 0 )
				break;
				
				case 24:
					do {
						n = data[ i++ ];
						a += lookup[ ( n >> 16 & 0xff ) ^ xor ];
						a += lookup[ ( n >> 8  & 0xff ) ^ xor ];
						a += lookup[ ( n       & 0xff ) ^ xor ];
					}  while ( --l  > 0 )
				break;
				
				case 32:
					do {
						n = data[ i++ ];
						a += lookup[ ( n >> 24 & 0xff ) ^ xor ]; 
						a += lookup[ ( n >> 16 & 0xff ) ^ xor ];
						a += lookup[ ( n >> 8  & 0xff ) ^ xor ];
						a += lookup[ ( n       & 0xff ) ^ xor ];
					}  while ( --l  > 0 )
				break;
			}
			
			return a;
		}

		private function initLZW():Void
		{
			dct = new Object();
			for ( var i:Number = 0; i < 256; i++ )
			{
				dct[ String.fromCharCode( i ) ] = i;
			}
			nextLZWIndex = 256;
			LZWbuffer    = [];
			
		}

		private function closeLZW( data:Array ):Void
		{
			data.push( dct[ LZWbuffer.join( "-" ) ] );
		}
		
		private function addLZWNumber( data:Array, n:Number ):Void
		{
			var items:Array = [];
			var nn:Number;
			if ( ( n >> 31 ) & 0x01 == 1)
			{
				nn = 0x800000 >> 6;
				n &= 0x7fffffff;
			} else 
			{
				nn = 0;
			}
			
			var input_length:Number = 2;
			var m:Number = n % encodeBase;
			
			
			n = ( n - m ) >> 7;
			
			items.push( chars[ m ], "," );
			
			
			while ( n > 0 || nn > 0 )
			{
				m = n % encodeBase;
				n = ( n - m ) >> 7;
				if ( nn != 0 )
				{
					n |= nn;
					nn = 0;
				}
				items.unshift( chars[ m ] );
				input_length++;
			}
			
			var xstr:String;
			
			for ( var i:Number = 0; i < input_length; i++ )
			{
				var cc:String = items[ i ];
				var bj:String = new String();
				
				if ( LZWbuffer.length == 0 ) 
				{
					xstr = cc;
				} else 
				{
					bj = LZWbuffer.join( "-" );
					xstr = bj + "-" + cc;
				}
	
				if ( dct[ xstr ] != undefined )
				{
					LZWbuffer.push( cc );
				} else
				{
					data.push( dct[ bj ] );
					dct[ xstr ] = nextLZWIndex++;
					delete LZWbuffer;
					LZWbuffer = [ cc ];
				}
			}
		}	
		
		private function initService():Void
		{
			service              = new LoadVars();
			service.success      = 0;
			service.onHTTPStatus = Delegate.create( this, onHTTPStatus );
			lastHTTPStatus       = null;
		}
			
		private function error( message:String ):Void
		{
			trace( message );		
			
			BitmapExporter.dispatchEvent({
										 type:    "error", 
										 target:  this, 
										 message: "ERROR: " + message
										 });
		
			reset();
		}
		
		private function flipBMP():Void
		{
			var temp_bitmap:BitmapData = bitmap.clone();
			bitmap.fillRect( bitmap.rectangle, 0 );
			bitmap.draw( temp_bitmap, new flash.geom.Matrix( -1, 0, 0, 1, bitmap.width, 0 ) );
			temp_bitmap.dispose();
		}
		
		/*----------------------------------------------------------
								EVENTS
		----------------------------------------------------------*/
			
		private function onImageHandle( success:Boolean ):Void
		{
			_global.clearTimeout( connectionTimeoutID );
			
			if (!success)
			{
				error( "[onImageHandle] HTTP Error " + lastHTTPStatus );
				return;
			}
			
			if  ( status == "cancelled" )
			{
				reset();
				return;
			}
			
			if ( service.success == "1" )
			{
					uniqueID = service.uniqueID;
					onScanProgress( 0.05, "Analysing Bitmap" );
					timeoutID = _global.setTimeout( this, "scanBitmap" ,50 );
			} else 
			{
				error( "[onImageHandle] " + service.error );
			}
		}
		
		private function onHTTPStatus( httpStatus:Number ):Void
		{
			lastHTTPStatus = httpStatus;
			
			if ( httpStatus >= 400 )
			{
				error( "HTTP error " + httpStatus );
			}
		}
			
		private function onAddPixelBlock( success:Boolean ):Void
		{
			busy = false;
			
			if ( !success )
			{
				error( "[onAddPixelBlock] HTTP error " + lastHTTPStatus );
				return;
			} 
			
			if  ( status == "cancelled" )
			{
				reset();
				return;
			}
			
			if ( service.success == "1" )
			{
				sentBytes += Number( service.sentBytes );
			} else if ( service.success == "0" )
			{
				error( "[onAddPixelBlock] " + service.error );
			} else {
				error( "[onAddPixelBlock] No Server Response (possible silent PHP crash)");
			}
			
		}
		
		private function onSave( success:Boolean ):Void
		{
			if (!success)
			{
				error( "[onSave] HTTP error "+lastHTTPStatus );
				return;
			}
			
			if  ( status == "cancelled" )
			{
				reset();
				return;
			}
			
			if ( service.success=="1" )
			{
				if ( !dontRetrieve )
				{
					setStatus( "downloading" );
					
					fileRef = new FileReference();
					fileRef.addListener( this );
					
					onProgress( fileRef, 0 , 0 );
					
					if( !fileRef.download( service.url, filename ) ) 
					{
						error( "[onSave] Dialog box failed to open." );
					}
				} else {
					onSaved( service.url, service.filename );
				}
			} else 
			{
				error( "[onSave] " + service.error );
			}
		}
		
		private function onDropImageHandle( success:Boolean ):Void
		{
			if (!success)
			{
				error( "[onDropImageHandle] HTTP error "+ lastHTTPStatus );
			}
		}
		
		
		private function onScanProgress( progress:Number, message:String ):Void {
			BitmapExporter.dispatchEvent({
										 type:    "progress", 
										 target:  BitmapExporter, 
										 current: progress, 
										 total:   1, 
										 message: message 
										 })
		}
		
		private function onSelect( file:FileReference ):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:   "select", 
										 target: BitmapExporter 
										 })
		}

		private function onCancel( file:FileReference ):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:   "cancel", 
										 target: BitmapExporter 
										 })
			reset();
		}

		private function onOpen(file:FileReference):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:     "open", 
										 target:   BitmapExporter, 
										 filename: file.name 
										 })
		}

		private function onProgress( file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:    "progress", 
										 target:  BitmapExporter, 
										 current: bytesLoaded, 
										 total:   bytesTotal, 
										 message: "downloading" 
										 })
		}

		private function onComplete( file:FileReference ):Void 
		{
			BitmapExporter.dispatchEvent({
										 type:             "complete", 
										 target:           BitmapExporter, 
										 filename:         file.name, 
										 compressionRatio: sentBytes / (bitmapWidth * bitmapHeight * 4)
										 });
			reset();
		}
		
		private function onSaved( serviceUrl:String, fileName:String ):Void 
		{
			BitmapExporter.dispatchEvent({
										 type:             "saved", 
										 target:           BitmapExporter, 
										 url:              serviceUrl,
										 fileName:		   fileName,
										 uniqueID:		   uniqueID,
										 compressionRatio: sentBytes / (bitmapWidth * bitmapHeight * 4)
										 });
			reset( true );
		}

		private function onIOError( file:FileReference ):Void 
		{
			error ( "IO error with file " + file.name);
		}
		
		private function onConnectionTimeout():Void {
			error ( "Connection Timeout - no response from server" );
		}

		private function setStatus( _status:String ):Void
		{
			status = _status;
			BitmapExporter.dispatchEvent({
										 type:   "status", 
										 target: BitmapExporter, 
										 status: status
										 });
			
		}
		
	}
