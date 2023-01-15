Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

param(
    [Parameter(Mandatory)]
    [string] $Path ='.'
)

function Get-TreeSizeBytes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    try {
        #here could occurr an I/O error
        $list = Get-ChildItem -Path $path
    }
    catch {
        # there is an error: output 0 and quit the function
        return 0
    }

    $dim = 0
    foreach ($item in $list){
        # write-host $item
        if ($item -is [System.IO.DirectoryInfo]){
            $dim = $dim + (Get-TreeSizeBytes -Path $item.FullName)
        }
        elseif ($item -is [System.IO.FileInfo]){
            #is not a directory
            $dim = $dim + $item.Length
        }
        else {
            Write-Debug "Unknown $item.FullName"
        }
    }
    return $dim
}

$dim = Get-TreeSizeBytes -Path $Path

Write-Host {0:n0} -f $dim
