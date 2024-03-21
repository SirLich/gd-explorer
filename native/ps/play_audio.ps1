 param (
    [string]$path = ""
 )

Add-Type -AssemblyName presentationCore
$mediaPlayer = New-Object system.windows.media.mediaplayer
$mediaPlayer.open("$path")
$mediaPlayer.Play()
