# Windows Server Enterprise Infrastructure
# Prepare Disk 1 for the File Server.
#
# WARNING:
# This operation initializes and formats the selected disk.
# Verify the disk number before execution.

$DiskNumber = 1

Initialize-Disk `
    -Number $DiskNumber `
    -PartitionStyle GPT

New-Partition `
    -DiskNumber $DiskNumber `
    -UseMaximumSize `
    -DriveLetter "D"

Format-Volume `
    -DriveLetter "D" `
    -FileSystem NTFS `
    -NewFileSystemLabel "FileServer" `
    -Confirm:$false

Write-Host "File Server volume prepared successfully." -ForegroundColor Green
