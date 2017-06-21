param (
    [string]$filename = "downloadconfigfile.conf",
    [string]$output = "output.xml"
 )
 # Seravy
 # Decrypt a backed up configuration file from a HG659.
$ErrorActionPreference = "Stop"

if(![System.IO.File]::Exists($filename)){
    write-output "The file $filename does not exist."
    return
}

$fileContent = [System.IO.File]::ReadAllBytes($filename);
# Keys from https://pastebin.com/JbZjygY3  https://hg658c.wordpress.com/
[byte[]] $aesKeyBytes = 26, 170, 180, 167, 48, 178, 62, 31, 200, 161, 213, 156, 121, 40, 58, 34, 139, 120, 65, 14, 204, 70, 250, 79, 72, 235, 20, 86, 226, 76, 91, 137
[byte[]] $aesIvBytes = 209, 254, 117, 18, 50, 92, 87, 19, 211, 98, 211, 50, 175, 163, 100, 76

$symmetricKey = New-Object System.Security.Cryptography.RijndaelManaged
$symmetricKey.set_Padding([System.Security.Cryptography.PaddingMode]::None);
$symmetricKey.set_Mode([System.Security.Cryptography.CipherMode]::CBC);

[byte[]] $result = New-Object byte[] $fileContent.Length
$byteLength = 0;

[System.Security.Cryptography.ICryptoTransform] $decryptor = $symmetricKey.CreateDecryptor($aesKeyBytes, $aesIvBytes)
$memStream = New-Object System.IO.MemoryStream -ArgumentList @(,$fileContent)
$cryptoStream = New-Object System.Security.Cryptography.CryptoStream -ArgumentList $memStream, $decryptor, Read
$byteLength = $cryptoStream.Read($result, 0, $result.Length);
$memStream.Close();
$cryptoStream.Close();
$symmetricKey.Clear();
$cryptoStream.Dispose();
$memStream.Dispose();
$decryptor.Dispose();


$fileStringBuilder = New-Object System.Text.StringBuilder
$memStreamFile = New-Object System.IO.MemoryStream -ArgumentList @(,$result)
$deflate = New-Object System.IO.Compression.DeflateStream($memStreamFile, [System.IO.Compression.CompressionMode]::Decompress)
[void]$memStreamFile.ReadByte();
[void]$memStreamFile.ReadByte();
$destStream = New-Object System.IO.MemoryStream

$deflate.CopyTo($destStream);
$outputBytes = $destStream.ToArray();
#$result = [System.Text.Encoding]::ASCII.GetString($destStream.ToArray());
$nonSig = [System.Text.Encoding]::ASCII.GetString([Linq.Enumerable]::Take($outputBytes, $outputBytes.Length - 129));
[void]$fileStringBuilder.Append($nonSig);

$memStreamFile.Dispose();
$deflate.Dispose();

$fileContent = [System.IO.File]::WriteAllLines($output, $fileStringBuilder.ToString());
write-output "Decrypted configuration file written to $output."