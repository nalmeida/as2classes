// original: http://www.flashdevelop.org/community/viewtopic.php?t=458

// usage: var mc:Test = Test( Library.attachWithClass(Test, _root, "library.test.jpg", "test", 1) );

class as2classes.util.Library{
   /**
   * Attach a library item and assimilate it to a given class
   * @param classRef Wanted class
   * @param target   Parent MovieClip
   * @param id       Library ID
   * @param name     Instance name
   * @param depth     Instance depth
   * @param params    Instance parameters
   * @return Reference to the created object
   */
   static public function attachWithClass(
      classRef:Function,
      target:MovieClip,
      id:String,
      name:String,
      depth:Number,
      params:Object
      ):Object
   {
      var mc:MovieClip = target.attachMovie(id, name, depth, params);
      mc.__proto__ = classRef.prototype;
      classRef.apply(mc);
      return mc;
   }
   /**
   * Creates a Class extends MovieClip on the stage in given context
   * @param   classRef Class to create
   * @param   target Scope where to create
   * @param   name Instance name
   * @param   depth Instance depth
   * @param   params Initialize paramters
   * @return Reference to the created object
   * @author maZe - www.web-specials.net
   */
   static public function createWithClass(
      classRef:Function,
      target:MovieClip,
      name:String,
      depth:Number,
      params:Object
   ):Object
   {
      var mc:MovieClip=target.createEmptyMovieClip(name,depth);
      mc.__proto__ = classRef.prototype;
      if (params != undefined) //Filling with given parameters like attachMovie
      {
         for (var i in params)
         {
            mc[i]=params[i];
         }
      }
      classRef.apply(mc);
      return mc;
   }
} 