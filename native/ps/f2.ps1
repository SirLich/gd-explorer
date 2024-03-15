Function Select-FolderDialog($Description="Select Folder", $RootFolder="MyComputer"){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null     

    $objForm = New-Object System.Windows.Forms.OpenFileDialog
    $objForm.DereferenceLinks = $true
    $objForm.CheckPathExists = $true
    $objForm.FileName = "[Select this folder]"
    $objForm.Filter = "Folders|`n"
    $objForm.AddExtension = $false
    $objForm.ValidateNames = $false
    $objForm.CheckFileExists = $false
    $Show = $objForm.ShowDialog()
    If ($Show -eq "OK")
    {
        Return $objForm.FileName
    }
    Else
    {
        Write-Error "Operation cancelled by user."
    }
}

$folder = Select-FolderDialog
write-host $folder