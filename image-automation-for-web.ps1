$sourceFolder = "C:\src image"
$outputFolder = "C:\web image"


$imagemagickBinary = "C:\apps\imagemagick\convert.exe"

$sourceFolders = Get-ChildItem -Directory $sourceFolder

$commandList = @()

foreach ($folder in $sourceFolders) {

	$currentFolder = $folder.Name.Replace(" ", "-")

	$sourceImages = Get-ChildItem -File $folder.FullName
    $i=1
    foreach ($image in $sourceImages) {
        

        
        $imagemagickResultPath = "`"$outputFolder\$currentFolder-$i.jpg`""
        $imagemagickArgs = "`"$($image.FullName)`" -auto-orient -resize 1024 -sampling-factor 4:2:0 -strip -quality 79 -interlace JPEG -colorspace sRGB $imagemagickResultPath"
        $imagemagickCmd = [pscustomobject]@{
			BinaryPath = $imagemagickBinary
			BinaryArgs = $imagemagickArgs
		}
        $commandList += $imagemagickCmd
        $i++
    }

}
foreach ($cmd in $commandList) { 
 "Calling: $($cmd.BinaryPath) $($cmd.BinaryArgs)"
 Start-Process $cmd.BinaryPath -ArgumentList $cmd.BinaryArgs -NoNewWindow -Wait 
}