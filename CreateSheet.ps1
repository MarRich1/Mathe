$Aufgaben = 10

function Addition {
    $min = 10
    $max = 5000
    $a = Get-Random -Maximum $max -Minimum $min
    $b = Get-Random -Maximum $max -Minimum $min 
    
    return @($a, $b)
}

function Subtratktion {
    $min = 10
    $max = 5000
    $a = Get-Random -Maximum $max -Minimum $min
    $b = Get-Random -Maximum $max -Minimum $min
    
    if($a -ge $b) {
        return @($a, $b)
    } else {
        return ($b, $a)
    }
}

function Mulitplikation {
    $min = 10
    $max = 500
    $a = Get-Random -Maximum $max -Minimum $min
    $b = Get-Random -Maximum $($max/10) -Minimum 3
    return @($a, $b)
}

function Division {
    $min = 10
    $max = 500
    do {
        $a = Get-Random -Maximum $max -Minimum $min
        $b = Get-Random -Maximum $($max/10) -Minimum 2

        if($b -gt $a) {
            $c = $a
            $a = $b
            $b = $c
        }

    } while ($($a % $b) -ne 0)
    return @($a, $b)
}

$dt = New-Object System.Data.DataTable
$dt.Columns.Add("Zahl 1") | Out-Null
$dt.Columns.Add("opp") | Out-Null
$dt.Columns.Add("Zahl 2") | Out-Null
$dt.Columns.Add("Ist gleich") | Out-Null

for($i=1; $i -le $Aufgaben; $i++) {
    ($a, $b) = Addition
    $r = $dt.NewRow()
    $r[0] = $a
    $r[1] = "+"
    $r[2] = $b
    $r[3] = "="
    $dt.Rows.Add($r);
}

for($i=1; $i -le $Aufgaben; $i++) {
    ($a, $b) = Subtratktion
    $r = $dt.NewRow()
    $r[0] = $a
    $r[1] = "-"
    $r[2] = $b
    $r[3] = "="
    $dt.Rows.Add($r);
}

for($i=1; $i -le $Aufgaben; $i++) {
    ($a, $b) = Mulitplikation
    $r = $dt.NewRow()
    $r[0] = $a
    $r[1] = "*"
    $r[2] = $b
    $r[3] = "="
    $dt.Rows.Add($r);
}

for($i=1; $i -le $Aufgaben; $i++) {
    ($a, $b) = Division
    $r = $dt.NewRow()
    $r[0] = $a
    $r[1] = ":"
    $r[2] = $b
    $r[3] = "="
    $dt.Rows.Add($r);
}

$dt | Export-Csv -Path "Übungsblatt.csv" -Force -NoTypeInformation -Delimiter ";"


