param (
    [Parameter(Mandatory=$false, Position=0)]
    [int] $Aufgaben = 10,
    [Parameter(Mandatory=$false)]
    [string] $ExercisesPath = "./Exercises.csv",
    [Parameter(Mandatory=$false)]
    [string] $SolutionPath = "./Solution.csv"
)

Begin {
    $dt = New-Object System.Data.DataTable
    $dt.Columns.Add("NumberA", [System.Int32]) | Out-Null
    $dt.Columns.Add("Opp", [System.String]) | Out-Null
    $dt.Columns.Add("NumberB", [System.Int32]) | Out-Null

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
        $max = 50
        $c = Get-Random -Maximum $max -Minimum $min
        $b = Get-Random -Maximum $max -Minimum 2
        $a = $c * $b 

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
            switch ($opp) {
                "-" { return $($a - $b) }
                "*" { return $($a * $b) }
                "+" { return $($a + $b) }
                ":" { return $($a / $b) }
                default { return 0 }
            }
        }

        End {}
    }

    function AddRow {
        param (
            [Parameter(Mandatory=$true, Position=0)]
            [int]$a,
            [Parameter(Mandatory=$true, Position=1)]
            [ValidateSet('+', '-', '*', ':')]
            [string]$opp,
            [Parameter(Mandatory=$true, Position=2)]
            [int]$b
        )

        Process {
            $r = $dt.NewRow()
            [int]$r[0] = $a
            $r[1] = $opp
            [int]$r[2] = $b
            $dt.Rows.Add($r)
        }
    }
}

Process {
    for ($i = 1; $i -le $Aufgaben; $i++) {
        ($a, $b) = Addition
        AddRow $a '+' $b
    }

    for ($i = 1; $i -le $Aufgaben; $i++) {
        ($a, $b) = Subtratktion
        AddRow $a '-' $b
    }

    for ($i = 1; $i -le $Aufgaben; $i++) {
        ($a, $b) = Mulitplikation
        AddRow $a '*' $b
    }

    for ($i = 1; $i -le $Aufgaben; $i++) {
        ($a, $b) = Division
        AddRow $a ':' $b
    }

    $dt | Sort-Object -Property NumberA |Select-Object -Property `
        @{ name = "a"; expr = { $_."NumberA" } }, `
        "Opp", `
        @{ name = "b"; expr = { $_."NumberB" } }, `
        @{ name = '='; expr = { "=" } } `
        | Export-Csv -Path $ExercisesPath -Force -NoTypeInformation -Delimiter ";"


    $dt | Sort-Object -Property NumberA | Select-Object -Property `
        @{ name = "a"; expr = { $_.NumberA } }, `
        "Opp", `
        @{ name = "b"; expr = { $_.NumberB } }, `
        @{ name = '='; expr = { "=" } }, `
        @{ name = "Result"; expr = { Get-Result -a $_.NumberA -b $_.NumberB -opp $_.Opp }} `
        | Export-Csv -Path $SolutionPath -Force -NoTypeInformation -Delimiter ";"
}

End {}
