Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40201 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753138AbYCXXlx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 19:41:53 -0400
Message-ID: <47E83DF5.9030401@gmx.de> (sfid-20080324_234158_300445_4EEA627F)
Date: Tue, 25 Mar 2008 00:49:09 +0100
From: Florian Manschwetus <florianmanschwetus@gmx.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: gentoo ebuild for compat wireless (resend)
References: <47E7A8DB.5020106@gmx.de>	 <43e72e890803241304g13ea443co4e4afb1681da989c@mail.gmail.com>	 <47E839BE.5030806@gmx.de> <43e72e890803241630n1906147ej1190d7562f5d1354@mail.gmail.com>
In-Reply-To: <43e72e890803241630n1906147ej1190d7562f5d1354@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms040203000004070004000602"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040203000004070004000602
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Luis R. Rodriguez schrieb:
> On Mon, Mar 24, 2008 at 7:31 PM, Florian Manschwetus
> <florianmanschwetus@gmx.de> wrote:
>> Luis R. Rodriguez schrieb:
>>
>>
>>> On Mon, Mar 24, 2008 at 9:12 AM, Florian Manschwetus
>>  > <florianmanschwetus@gmx.de> wrote:
>>  >> is it possible to get a version appendix on the tar.bz?
>>  >>  so it should be easy to get a working ebuild fpr this.
>>  >
>>  > The problem is there's two things to "version", compat-wireless itself
>>  > and Linux. I keep both version already as part of the tarball.
>>  >
>>  > wireless@sipsolutions:~$ cat compat-wireless-2.6/compat-release
>>  > 2.8-49-gfe0f268
>>  >
>>  > wireless@sipsolutions:~$ cat compat-wireless-2.6/git-describe
>>  > v2.6.25-rc5-2623-g7556b76
>>  >
>>  > You can also just pull these from the directory that was used to
>>  > create the tarball:
>>  >
>>  > http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6/compat-release
>>  > http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6/git-describe
>>  >
>>  > Does this suffice?
>>
>>
>> Not really but it gives a version hint, could you create a symlink or so?
>>  a url like that would be fine:
>>  http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.8-49.tar.bz2
> 
> The problem is that does not reflect changes to Linux so there may be
> a lot of great code added and yet this wouldn't reflect it. And if we
> go with git-describe for Linux we could get updates on compat-wireless
> itself during no code changes on Linux. I could use date (date -I),
> that might work best but will it work for you?
a date would be perfect (f.e. -20080325)
florian
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------------ms040203000004070004000602
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKlDCC
BUYwggMuoAMCAQICAwQsXDANBgkqhkiG9w0BAQUFADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0wNzEw
MTgxODMzMjRaFw0wOTEwMTcxODMzMjRaMEgxHDAaBgNVBAMTE0Zsb3JpYW4gTWFuc2Nod2V0
dXMxKDAmBgkqhkiG9w0BCQEWGUZsb3JpYW5NYW5zY2h3ZXR1c0BnbXguZGUwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQC2GnTI54ujEGPHu7/5L3UePHT6bydUQAWsck9f44wc
hURmyPxNMb228wpkIEaWOpsnxCYbKfxW7nIi0zP7eSAhGhXiI9jyLPgJ4NpG1OFT2Eyzjkkf
25CtC1NO9ZbMacVieXjDw4ezPkuJvSyhsDcFAUERCWG9DT74tMdP9ADdMzI8h/eXjv6j4flz
TD2WAsDe1hfdSTkzB7G3SMBtBu6J46CY6p93epais/x1CzFkzDJsh0r7dh0tHGhVCGkR1bN1
5SB2QhIdCR3+Ji1F1W8/7ugak6utREUz4LxYPw/wfiIRaVHTVPjo5YwfD0gjcWSXx25gWf2J
SEVBx+VDr3o1AgMBAAGjggEGMIIBAjAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdU
byBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6
Ly93d3cuQ0FjZXJ0Lm9yZzBABgNVHSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQB
gjcKAwQGCisGAQQBgjcKAwMGCWCGSAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUH
MAGGFmh0dHA6Ly9vY3NwLmNhY2VydC5vcmcwJAYDVR0RBB0wG4EZRmxvcmlhbk1hbnNjaHdl
dHVzQGdteC5kZTANBgkqhkiG9w0BAQUFAAOCAgEAM6hh9b2HehQ1/BN9CVHh/TuF4EektTuE
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
Uk4UE2xEMYIDhzCCA4MCAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0
cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5
MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAwQsXDAJBgUrDgMCGgUAoIIB
2zAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wODAzMjQyMzQ5
MDlaMCMGCSqGSIb3DQEJBDEWBBRBaSTjN6eBlbD44hXwgAUBIpgSoTBSBgkqhkiG9w0BCQ8x
RTBDMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMC
BzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAEMYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3Qg
Q0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBT
aWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgME
LFwwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsT
FWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhv
cml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMELFwwDQYJKoZIhvcN
AQEBBQAEggEAilGajrOtL9GSxKstmtBpXtUYzvE1jURpA/1YqFJ/Zc43pGlSOK4EYdUU942M
cmMBos/BKwO7upXTDgTGJnhwdG3uzTS3QS3SLX4f2DKjAYOdAUgURWso5gMcXeQ1NTONx1Af
ktHPQkEn9RzC11adL7YrDq1q1iFzBbwB074OBTs3x1iH2mHr+Xf+a3u+GaEkreNxC0oQjOoD
24wmL8jJ6urX7Ibtkd8WCeV32GaPaPq/8b2Uqc73gOfX81fGpS7LMcQdIZ5nb0ABPSN8fSmv
fQDmme2hE9sbVlJ3UDioCZJMw6VROuL63Ke1UXIf+THbemD2P5DCGgaBX7hm81yqsgAAAAAA
AA==
--------------ms040203000004070004000602--
