mypss
====

My Powershell Scripts

* [Get-Logger](#get-logger)
* [Get-Draw](#get-draw)


## Get-Logger

This module is logger object.

```ps1
### Example: Output display only

# Get object
$logger = Get-Logger

# Output log
$logger.info.Invoke("Information message")
```

### How to use

1. Object generate

   * Output display only
   ```ps1
   $logger = Get-Logger
   ```

   * Output display and logfile
   ```ps1
   # Set logfile
   $logger = Get-Logger -Logfile "C:\hoge\hoge.log"
   ```

   * Output logfile only
   ```ps1
   # Set logfile and NoDisplay Switch
   $logger = Get-Logger -Logfile "C:\hoge\hoge.log" -NoDisplay
   ```

2. Output log

   * Information message on display
   ```ps1
   $logger.info.Invoke("Information Message")
   ```

   * Warning message on display
   ```ps1
   $logger.warn.Invoke("Warning Message")
   ```

   * Error message on display
   ```ps1
   $logger.error.Invoke("Error Message")
   ```

---

## Get-Draw

This module is image drawing & simple image processing object.

```ps1
### Example: resize & rotate image

# Get object
$draw = Get-Draw -File "C:\hoge.jpg"

# Resize
$draw.resize.Invoke("30%")

# Rotate (right-hand turn)
$draw.rotate.Invoke('90')

# Save
$draw.save.Invoke("C:\hoge-resize.png")

# Object dispse
$draw.dispose.Invoke()
```

### How to use

1. Object generate
   the one way
     * Param:  
       -File filepath
     * Example
       ```ps1
       $draw = Get-Draw -File "C:\hoge.jpg"
       ```

2. Image processing

   Image rotate

     * Method: rotate
     * Param: rotate angle  
       [ 90 | 180 | 270 | NONE ]
     * Example
       ```ps1
       # no turn 
       $draw.rotate.Invoke('NONE')

       # right-hand turn 90
       $draw.rotate.Invoke('90')

       # right-hand turn 180
       $draw.rotate.Invoke('180')

       # right-hand turn 270
       $draw.rotate.Invoke('270')
       ```

   Image flip

     * Method: flip
     * Param: flip pattern  
       [ X | Y | XY ]
     * Example: 
       ```ps1
       # no flip
       $draw.flip.Invoke('NONE')

       # horizontal flip
       $draw.flip.Invoke('X')

       # virtical flip
       $draw.flip.Invoke('Y')

       # horizontal and virtical flip
       $draw.flip.Invoke('XY')
       ```

   Image resize

     * Method: resize
     * Param1: image width  
       [ [int]pixcel | [string]percent ]
     * Param2: image height  
       [ [int]pixcel | [string]percent ]
     * Example: 
       ```ps1
       # width = 640, height = auto
       $draw.resize.Invoke(640)

       # width = auto, height = 320
       $draw.resize.Invoke($null, 320)

       # resize 40%
       $draw.resize.Invoke("40%")

       # width = 150%, height = 200%
       $draw.resize.Invoke("150%", "200%")
       ```

   Image format

     * Method: format
     * Param: image format  
       [ bmp | emf | exif | gif | ico | jpg | png | tiff | wmf ]
     * Note: without using this method , it's automatically determined to see an extension to the time of the save
     * See: [https://msdn.microsoft.com/en-us/library/system.drawing.imaging.imageformat(v=vs.110).aspx](https://msdn.microsoft.com/en-us/library/system.drawing.imaging.imageformat(v=vs.110).aspx)
     * Example: 
       ```ps1
       # convert png
       $draw.format.Invoke('png')

       # convert jpeg
       $draw.format.Invoke('jpg')
       ```

    Interpolation mode

     * Method: mode
     * Param: interpolation mode  
       [ Bicubic | Bilinear | Default | High | HighQualityBicubic | HighQualityBilinear | Low | NearestNeighbor ]
     * Note: default is NearestNeighbor
     * See: [https://msdn.microsoft.com/en-us/library/system.drawing.drawing2d.interpolationmode%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396](https://msdn.microsoft.com/en-us/library/system.drawing.drawing2d.interpolationmode%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396)
     * Example: 
       ```ps1
       # mode Bicubic
       $draw.mode.Invoke('Bicubic')

       # mode HighQualityBicubic
       $draw.mode.Invoke('HighQualityBicubic')
       ```

3. Save
     * Method: save
     * Param: save filepath
     * Example:
   ```ps1
   # Image save
   $draw.save.Invoke("C:\hoge-resize.png")
   ```

4. Object dispose
     * Method: dispose
     * Example:
    ```ps1
    # Object dispose
    $draw.dispose.Invoke()
      ```

