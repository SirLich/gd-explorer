Add-Type -AssemblyName System.Windows.Forms
$FolderDialog = New-Object -Typename System.Windows.Forms.OpenFileDialog
[void]$FolderDialog.ShowDialog()
$FolderDialog.SelectedPath
