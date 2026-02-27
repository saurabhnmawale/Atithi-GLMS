Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('C:\Users\saura\IdeaProjects\untitled\Atithi_GLMS_Tech_Spec.docx')
$entry = $zip.Entries | Where-Object { $_.FullName -eq 'word/document.xml' }
$reader = New-Object System.IO.StreamReader($entry.Open())
$xml = $reader.ReadToEnd()
$reader.Close()
$zip.Dispose()
[xml]$doc = $xml
$ns = @{w='http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
$paras = Select-Xml -Xml $doc -XPath '//w:p' -Namespace $ns
$output = @()
foreach($p in $paras){
    $text = (Select-Xml -Xml $p.Node -XPath './/w:t' -Namespace $ns | ForEach-Object { $_.Node.InnerText }) -join ''
    if($text.Trim()) { $output += $text }
}
$output | Out-File -FilePath 'C:\Users\saura\IdeaProjects\untitled\tech_spec_extracted.txt' -Encoding UTF8
