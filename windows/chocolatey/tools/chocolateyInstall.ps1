$packageName = 'biicode'
$installerType = 'exe'
$url = 'https://s3.amazonaws.com/biibinaries/release/2.0.1/bii-win_2_0_1.exe' # download url
$silentArgs = '/VERYSILENT'
$validExitCodes = @(0)

Function Cmake-Path
{
	$chococmake_path = "C:\ProgramData\chocolatey\lib\cmake.3.0.2\content\cmake-3.0.2-win32-x86\bin"
	$path = $env:Path

    $replaced = $path.Replace("CMake 2.8\bin","") + ";" + $chococmake_path
    $do_replace = -not $path.Contains($chococmake_path)
	
    Write-Host "Checking CMake on PATH..."
    Write-Host ">>> Current path '$path'"

	if($do_replace)
	{
        Write-Host "Replacing PATH entries..."
        Write-Host "Updating PATH to $replaced"

		Install-ChocolateyPath "$replaced"
        $env:Path = "$($env:Path);$replaced"
	}
}

Function InstallExtras
{
	$extras = @{vs12         = "visualstudiocommunity2013";
	            mingw        = "mingw";
				sublimetext2 = "sublimetext2"}
	
    Write-Host "Installing extra tools:"


    if($env:chocolateyPackageParameters -ne $null)
    {
    	foreach($extra in $env:chocolateyPackageParameters.Split(" "))
    	{
    		if($extras.ContainsKey($extra))
    		{
                $package = $extras[$extra]
                Write-Host " - Installing '$extra' extra tool (Package '$package')..."

    			Invoke-Expression "choco install $package"
    		}
            else {
                Write-Host " - '$extra' tool not known. Skipping"
            }
    	}
    }
}

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes
Cmake-Path
InstallExtras

