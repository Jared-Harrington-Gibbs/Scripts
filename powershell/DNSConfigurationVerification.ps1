
$domains = @("digitalgibbs.com")

foreach ($item in $domains) {
    Resolve-DnsName -Type TXT -Name $item |ft -AutoSize
}



foreach ($item in $domains) {
    Resolve-DnsName -Type TXT -Name _dmarc.$($item);
}
