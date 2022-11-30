$Aufgaben = 10

function Addition {
    [OutputType([System.Int32[]])]
    $min = 10
    $max = 5000
    $a = Get-Random -Maximum $max -Minimum $min
    $b = Get-Random -Maximum $max -Minimum $min 
    
    return @($a, $b)
}

function Subtratktion {
    [OutputType([System.Int32[]])]
    $min = 10
    $max = 5000
    $a = Get-Random -Maximum $max -Minimum $min
    $b = Get-Random -Maximum $max -Minimum $min
    
    if ($a -ge $b) {
        return @($a, $b)
    }
    else {
        return ($b, $a)
    }
}

function Mulitplikation {
    [OutputType([System.Int32[]])]
    $min = 10
    $max = 500
    $a = Get-Random -Maximum $max -Minimum $min
    $b = Get-Random -Maximum $($max / 10) -Minimum 3
    return @($a, $b)
}

function Division {
    [OutputType([System.Int32[]])]
    $min = 10
    $max = 500
    do {
        $a = Get-Random -Maximum $max -Minimum $min
        $b = Get-Random -Maximum $($max / 10) -Minimum 2

        if ($b -gt $a) {
            $c = $a
            $a = $b
            $b = $c
        }

    } while ($($a % $b) -ne 0)
    return @($a, $b)
}

function Get-Result {
    param (
        [Parameter(Mandatory=$true, Position=1)] [int] $a,
        [Parameter(Mandatory=$true, Position=2)] [int] $b,
        [Parameter(Mandatory=$true, Position=3)] [string] $opp
    )

    Begin {}

    Process {
        Write-Host "$($a) $($opp) $($b)"
        switch ($opp) {
            "+" { Write-Host "+"; return $($a + $b) }
            "-" { Write-Host "-"; return $($a - $b) }
            "*" { Write-Host "*"; return $($a * $b) }
            ":" { Write-Host "/"; return $($a / $b) }
            default { return 0 }
        }

        throw "Kacke"
    }

    End {}
}

$dt = New-Object System.Data.DataTable
$dt.Columns.Add("NumberA", [System.Int32]) | Out-Null
$dt.Columns.Add("Opp", [System.String]) | Out-Null
$dt.Columns.Add("NumberB", [System.Int32]) | Out-Null

for ($i = 1; $i -le $Aufgaben; $i++) {
    ($a, $b) = Addition
    $r = $dt.NewRow()
    [int]$r[0] = $a
    $r[1] = '+'
    [int]$r[2] = $b
    $dt.Rows.Add($r)
}

for ($i = 1; $i -le $Aufgaben; $i++) {
    ($a, $b) = Subtratktion
    $r = $dt.NewRow()
    [int]$r[0] = $a
    $r[1] = '-'
    [int]$r[2] = $b
    $dt.Rows.Add($r)
}

for ($i = 1; $i -le $Aufgaben; $i++) {
    ($a, $b) = Mulitplikation
    $r = $dt.NewRow()
    [int]$r[0] = $a
    $r[1] = '*'
    [int]$r[2] = $b
    $dt.Rows.Add($r)
}

for ($i = 1; $i -le $Aufgaben; $i++) {
    ($a, $b) = Division
    $r = $dt.NewRow()
    [int]$r[0] = $a
    $r[1] = ':'
    [int]$r[2] = $b
    $dt.Rows.Add($r)
}

$dt | Select-Object -Property `
    @{ name = "a"; expr = { $_."NumberA" } }, `
    "Opp", `
    @{ name = "b"; expr = { $_."NumberB" } }, `
    @{ name = '='; expr = { "=" } } `
    | Export-Csv -Path "Exercises.csv" -Force -NoTypeInformation -Delimiter ";"


$dt | Select-Object -Property `
    @{ name = "a"; expr = { $_.NumberA } }, `
    "Opp", `
    @{ name = "b"; expr = { $_.NumberB } }, `
    @{ name = '='; expr = { "=" } }, `
    @{ name = "Result"; expr = { Get-Result -a $_.NumberA -b $_.NumberB -opp $_.Opp }} `
    | Export-Csv -Path "Solution.csv" -Force -NoTypeInformation -Delimiter ";"


foreach($r in $dt) {
    Get-Result $r.NumberA $r.NumberB $r.Opp
}
