<#
.SYNOPSIS
 Print or check md5 checksum.

.description
 Print or check md5 checksum.

.PARAMETER Path
 File or Directory Path

.PARAMETER Check
  checksum file. format is this module output.

.EXAMPLE
  Get-Md5sum -Path hoge.txt
  # Example: file check

.EXAMPLE
  Get-Md5sum -Path foo/
  # Example: directory check

.EXAMPLE
  Get-Md5sum -Check checksum.txt
  # Example: check md5 checksum

.EXAMPLE
  md5sum -Check checksum.txt
  # Use alias

.LINK
  https://github.com/miyamiya/mypss/blob/master/README.md

#>
function Get-Md5sum
{
    param(
        [CmdletBinding()]
        [Parameter()]
        [String]$Path,
        [Parameter()]
        [ValidateScript({Test-Path -LiteralPath $_})]
        [String]$Check
    )

    $md5 = {
        param($file)
        $hash = ''
        [System.Security.Cryptography.MD5]::Create().ComputeHash((New-Object IO.StreamReader $file).BaseStream) | % {
            $hash += $_.Tostring("x2")
        }
        Write-Output $hash
    }


    if(![string]::IsNullOrEmpty($Path)){
        # WebDav
        $Path = ($Path -replace '^http[s]:(\/\/.*)$', '$1')

        # Check $Path
        $files = Get-ChildItem -Path $Path | Where-Object {!$_.PSIsContainer} | Sort-Object Name
        $parent = ((Split-Path $Path -Parent) + '\')
        if($parent -eq '\'){
            $parent = ''
        }

        foreach($file in $files) {
            $hash = $md5.Invoke($file.FullName)
            Write-Output ('{0}  {1}' -f [string]$hash, ($parent + $file.Name))
        }
    }

    if(![string]::IsNullOrEmpty($Check)){
        $log = @{noline = 0; nofile = 0; failed = 0}
        $txt = Get-Content -Path $Check
        
        foreach($line in $txt) {
            if(!($line -match "^([0-9a-z]{32})\s*(.*)$")){
                $log.noline++
                continue
            }
            if(!(Test-Path -LiteralPath $Matches[2] -PathType Leaf)){
                $log.nofile++
                Write-Output ('{0}: {1}' -f $Matches[2], 'FAILED open or read')
                continue
            }

            $judge = 'OK'
            $hash = $md5.Invoke($Matches[2])
            if($Matches[1] -ne $hash) {
                $log.failed++
                $judge = 'FAILED'
            }
            Write-Output ('{0}: {1}' -f $Matches[2], $judge)
        }
        
        # Output warning
        if ($log.noline -ne 0) {
            Write-Output ('WARNING: {0} line is illigal format.' -f $log.noline)
        }
        if ($log.nofile -ne 0) {
            Write-Output ('WARNING: {0} file could not open or read.' -f $log.nofile)
        }
        if ($log.failed -ne 0) {
            Write-Output ('WARNING: {0} checksum did not match.' -f $log.failed)
        }
    }
}

New-Alias -Name md5sum -Value Get-Md5sum
Export-ModuleMember -Function Get-Md5sum -Alias md5sum
