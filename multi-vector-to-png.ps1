$sourceFolder = "C:\convert"
$outputFolder = "C:\convert\png"
$inkscapeBinary = "C:\apps\inkscape\inkscape.exe"
$imagemagickBinary = "C:\apps\imagemagick\convert.exe"

$squareImages = @("logo-vertical-square.svg","logo-no-text-square.svg")
$wideImages = @("logo-standard.svg", "logo-vertical.svg", "logo-horizontal.svg", "logo-no-text.svg")

$squareSizes = @(50,62,98,100,110,150,152,165,192,200,250,300,350,400,450,500,550,600)
$wideSizes = @(7680,4096,3840,2048,1920,1440,1280,960,480,240,500,400,300,200)

$commandList = @()

foreach ($image in $squareImages) {
  
   $sourceImage = "$sourceFolder\$image"
   $imageBaseName = (Get-Item $sourceImage).basename

   foreach ($size in $squareSizes) {
   
		$inkscapeResultPath = "`"$outputFolder\$imageBaseName-$size.png`""
		$inkscapeArgs = "--export-png $inkscapeResultPath -w $size `"$sourceImage`""
		$inkskcapeCmd = [pscustomobject]@{
			BinaryPath = $inkscapeBinary
			BinaryArgs = $inkscapeArgs
		}

		$commandList += $inkskcapeCmd

		$imagemagickResultPath = "`"$outputFolder\$imageBaseName-$size-optimized.png`""
		$imagemagickArgs = "$inkscapeResultPath -strip -alpha Remove $imagemagickResultPath"
		$imagemagickCmd = [pscustomobject]@{
			BinaryPath = $imagemagickBinary
			BinaryArgs = $imagemagickArgs
		}
		$commandList += $imagemagickCmd

		}
}

foreach ($image in $wideImages) {
  
   $sourceImage = "$sourceFolder\$image"
   $imageBaseName = (Get-Item $sourceImage).basename

   foreach ($size in $wideSizes) {
   
		$inkscapeResultPath = "`"$outputFolder\$imageBaseName-$size.png`""
		$inkscapeArgs = "--export-png $inkscapeResultPath -w $size `"$sourceImage`""
		$inkskcapeCmd = [pscustomobject]@{
			BinaryPath = $inkscapeBinary
			BinaryArgs = $inkscapeArgs
		}

		$commandList += $inkskcapeCmd

		$imagemagickResultPath = "`"$outputFolder\$imageBaseName-$size-optimized.png`""
		$imagemagickArgs = "$inkscapeResultPath -strip -alpha Remove $imagemagickResultPath"
		$imagemagickCmd = [pscustomobject]@{
			BinaryPath = $imagemagickBinary
			BinaryArgs = $imagemagickArgs
		}
		$commandList += $imagemagickCmd
		
   }
}

foreach ($cmd in $commandList) { 
 "Calling: $($cmd.BinaryPath) $($cmd.BinaryArgs)"
 Start-Process $cmd.BinaryPath -ArgumentList $cmd.BinaryArgs -NoNewWindow -Wait 
}