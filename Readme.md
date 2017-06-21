# Introduction
Use these powershell tools to get your VOIP and root passwords from your **Huawei HG659** modem.
Useful in cases where the device is locked down and the ISP will not disclose the details for Voip.

# Instructions
1) Download DecryptConfig.ps1 and DecryptPassword.ps1
2) Log in the router using admin/admin or whatever non root administrator account you have been provided.
3) Go to [http://10.1.1.254/api/system/downloadcfg](http://10.1.1.254/api/system/downloadcfg) to download downloadconfigfile.conf to the same folder. (Replace 10.1.1.254 with your routers IP address)
4) Open powershell and run the following command to generate output.xml which will contain the configuration file: `.\DecryptConfig.ps1`

5) Open output.xml and look for the <Sip tags to get voip details. The second sip tag <SIP AuthUserName="*username*" AuthPassword="*EncryptedPassword*" ..
6) To get the password out run the command: `.\DecryptPassword.ps1 *EncryptedPassword*`

# Thanks
Thanks to https://pastebin.com/JbZjygY3 [https://hg658c.wordpress.com/](https://hg658c.wordpress.com/) where i got the keys to decrypt the modem
Thanks to [Whirlpool](whirlpool.net.au).