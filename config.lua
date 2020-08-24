local aspectRatio = display.pixelHeight / display.pixelWidth

application = {
   content = {
      width  = aspectRatio > 1.5 and 800 or math.ceil( 1200 / aspectRatio ),
      height = aspectRatio < 1.5 and 1200 or math.ceil( 800 * aspectRatio ),
      --scale = "letterbox",
      fps = 30,

      imageSuffix = {
         ["@2x"] = 1.5,
         ["@4x"] = 3.0,
      },
   },
   notification =
   {
       iphone =
       {
           types =
           {
              "badge", "sound", "alert"
           }
       },
   },
    license =
    {
        google =
        {
            key = "Your key",
        },
    },

}