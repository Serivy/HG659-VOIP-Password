#Require -Version 5.0
#using System.Security.Cryptography;
# Seravy
# Decrypt a password in an Auth xml attribute.
param (
    [string]$password = "H/fe3b4F443i6UK+l4X+Hg==" # Default root password
 )
$ErrorActionPreference = "Stop"

# Keys from https://pastebin.com/JbZjygY3  https://hg658c.wordpress.com/
[byte[]] $keyBytes = 219, 175, 51, 97, 232, 29, 160, 239, 83, 88, 161, 146, 159, 201, 10, 128
[byte[]] $ivBytes = 98, 158, 161, 80, 83, 51, 118, 116, 27, 227, 111, 60, 129, 158, 119, 186

[byte[]] $passwordBytes = [System.Convert]::FromBase64String($password)

$symmetricKey = New-Object System.Security.Cryptography.RijndaelManaged
$symmetricKey.set_Padding([System.Security.Cryptography.PaddingMode]::None);
$symmetricKey.set_Mode([System.Security.Cryptography.CipherMode]::CBC);

[byte[]] $result = New-Object byte[] $passwordBytes.Length
$byteLength = 0;

[System.Security.Cryptography.ICryptoTransform] $decryptor = $symmetricKey.CreateDecryptor($keyBytes, $ivBytes)
$memStream = New-Object System.IO.MemoryStream -ArgumentList @(,$passwordBytes)
$cryptoStream = New-Object System.Security.Cryptography.CryptoStream -ArgumentList $memStream, $decryptor, Read

$byteLength = $cryptoStream.Read($result, 0, $result.Length);
$memStream.Close();
$cryptoStream.Close();
$symmetricKey.Clear();
$cryptoStream.Dispose();
$memStream.Dispose();
$decryptor.Dispose();

$utf = [System.Text.Encoding]::UTF8.GetString($result, 0, $byteLength);
$decryptedPassword = $utf.Replace("\0", [string]::Empty);

Write-Output $decryptedPassword