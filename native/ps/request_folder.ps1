Add-Type -AssemblyName System.Windows.Forms
$FolderDialog = New-Object -Typename System.Windows.Forms.FolderBrowserDialog
[void]$FolderDialog.ShowDialog()
$FolderDialog.SelectedPath
