Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52704 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042AbbBBW5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 17:57:20 -0500
Received: by mail-wi0-f178.google.com with SMTP id bs8so18252430wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2015 14:57:19 -0800 (PST)
Message-ID: <54D000CD.7040809@gmail.com> (sfid-20150202_235723_791252_5F8B1247)
Date: Mon, 02 Feb 2015 23:57:17 +0100
From: =?UTF-8?B?VmxhZGltw61yIMSMdW7DoXQ=?= <vcunat@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Sven-Haegar Koch <haegar@sdinet.de>,
	Nix Dev <nix-dev@lists.science.uu.nl>
Subject: Re: broken URLs of iwlwifi firmware tarballs
References: <54CFF0B3.1060507@gmail.com> <alpine.DEB.2.11.1502022345190.28286@aurora.sdinet.de>
In-Reply-To: <alpine.DEB.2.11.1502022345190.28286@aurora.sdinet.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070100070002020800000809"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070100070002020800000809
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 02/02/2015 11:45 PM, Sven-Haegar Koch wrote:
> Aren't they now all available as part of
> https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.gi=
t/

Yes, all should be there as well, I guess. I didn't switch to that repo=20
yet because:
  - they're not the same *.tgz files (with the same hashes);
  - serving uncompressed files through (c)git surely isn't a preferred=20
method to distribute binaries;
  - the URLs were used by many (according to my searching), so it seemed =

preferable to just fix them instead of everyone switching to different on=
es.


Vladimir



--------------ms070100070002020800000809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJazCC
BKAwggOIoAMCAQICEQDwhvYlHZdHibfdyBlsiW2AMA0GCSqGSIb3DQEBBQUAMDsxCzAJBgNV
BAYTAk5MMQ8wDQYDVQQKEwZURVJFTkExGzAZBgNVBAMTElRFUkVOQSBQZXJzb25hbCBDQTAe
Fw0xMjA2MjYwMDAwMDBaFw0xNTA2MjYyMzU5NTlaMGsxCzAJBgNVBAYTAkNaMSMwIQYDVQQK
ExpVbml2ZXJ6aXRhIEthcmxvdmEgdiBQcmF6ZTEaMBgGA1UEAwwRVmxhZGltw61yIMSMdW7D
oXQxGzAZBgkqhkiG9w0BCQIWDDEwMDAwMDA1MDU5OTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBANcoAjmclljT9rjG719tYe8Ov3aTzBlnnpQUlmLrhztf3R+FAuJloiGgBiZ1
tUdX7F/j/Mb+/LrROiqenYvnk3B2mrxg5klkfua44v1VZSePH8d5kwIN+eBVK4cicuNFbqt+
szFH1mFXFdlUfJtj6l5KFhyucFgcrp0ccxpcy9kEajaOChUoljG5BXJfB1T0z8Jr+tGw0hce
CQ9P/uahEkiDHWtK1gbtGQyAuMh1vFtEM35mt0pyQ0PzouCHzqGmDzLGi7l+Ud72uDWvJ9nR
rGQWFwKqrbd/C4bbnwgIsItp65jTObmgeDzAIyISUeBgouUMwk9k0AHkILNAJlyT7rUCAwEA
AaOCAW0wggFpMB8GA1UdIwQYMBaAFGNNQ1oZSD/ERsECur/uDuWCt2amMB0GA1UdDgQWBBRE
k9LYYV+vNxAFmKcTUdWizi/PyzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNV
HSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwGAYDVR0gBBEwDzANBgsrBgEEAbIxAQICHTA/
BgNVHR8EODA2MDSgMqAwhi5odHRwOi8vY3JsLnRjcy50ZXJlbmEub3JnL1RFUkVOQVBlcnNv
bmFsQ0EuY3JsMHIGCCsGAQUFBwEBBGYwZDA6BggrBgEFBQcwAoYuaHR0cDovL2NydC50Y3Mu
dGVyZW5hLm9yZy9URVJFTkFQZXJzb25hbENBLmNydDAmBggrBgEFBQcwAYYaaHR0cDovL29j
c3AudGNzLnRlcmVuYS5vcmcwGwYDVR0RBBQwEoEQdmN1bmF0QGdtYWlsLmNvbTANBgkqhkiG
9w0BAQUFAAOCAQEAdL7MsKsfcl1/yHu/kz1XOZxmZFpSiIYrlf04iuHG+1cH+9qaDIno2BBt
PMw5l7fWjtMu7s9G9gLW+hrduPUbMdHAL7GyHD1J5puisO6AE1RDOZCpDUFiU4NN2wUZFTWL
scRK37ijol/Pa5gyt98R0Lyb23J2wNywNEWjFJyE/Izz/BpX+xldrFRu10DQN0faSo9+9F4Y
zLTuG7lGAbNJ14HGNhiFJurinIWq0HOPIw9Uyf7enleaYlKHWsjhBipzoFr4NoinHY5UuaDB
8o4d+g1qSpNZM7NSVzN0l043rFVHEWNAvrHx4fHj0ydar47MR2EE716F4iO1/m0S/uW84zCC
BMMwggOroAMCAQICEHP+V/rfuMUIgXtmuWvwLe8wDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNV
BAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3Qu
Y29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
RW1haWwwHhcNMDkwNTE4MDAwMDAwWhcNMjgxMjMxMjM1OTU5WjA7MQswCQYDVQQGEwJOTDEP
MA0GA1UEChMGVEVSRU5BMRswGQYDVQQDExJURVJFTkEgUGVyc29uYWwgQ0EwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDIFdn1M2ojoZANz7sFRMOrH0o1hRohhaBP+PBA4kpD
m/5bsbC/tFfcdYBBS2Qa9ttPb4/QJUU1+erLSvr72tPtRYgRlDbkzKgN78U9N+0We+PClZ5Y
M38i+/j/7Oa+264KZSUih9pvhItG6ECGKD+/VgjiSumDouki+y36tigfkcHDcftTwCtOpAyh
bp1V7ezhJIc6COINHOTETdDLJ/qEZObRl51WJFuTuykuQ+JBaj3iSmX8ml9ahoe8h8d5gJaZ
UcaQD2SRmX0Q3awsAyrheGT+zj1O9CtQEUvRWNSbA/B/9TtTsFND+8UvxAQpGjqs11Xp0Q6V
0Tsxf3hPriktAgMBAAGjggFNMIIBSTAfBgNVHSMEGDAWgBSJgmd9xJ0mcABLtFBIfN49rgRu
fTAdBgNVHQ4EFgQUY01DWhlIP8RGwQK6v+4O5YK3ZqYwDgYDVR0PAQH/BAQDAgEGMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwGAYDVR0gBBEwDzANBgsrBgEEAbIxAQICHTBYBgNVHR8EUTBPME2g
S6BJhkdodHRwOi8vY3JsLnVzZXJ0cnVzdC5jb20vVVROLVVTRVJGaXJzdC1DbGllbnRBdXRo
ZW50aWNhdGlvbmFuZEVtYWlsLmNybDBvBggrBgEFBQcBAQRjMGEwOAYIKwYBBQUHMAKGLGh0
dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VVE5BQUFDbGllbnRfQ0EuY3J0MCUGCCsGAQUFBzAB
hhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQAGK6lTLxPc
XDkWzIafXkx7cvvsjVWKXpoK/1NMdvQGPVDPV/Ciz6+ZjKr+oBl2PpkDMvp1gziKu2uapQwT
stQbduaULmeYWeORbAKQmpzIYEtVq8qIWo0r5WmVAwfR1A78JCIuWbFjpF/t2SNy5JzOOlxs
H0+pAMkd/vp/RS22LoTdDyegWRhO1XYlRfSZJnnbb58j90O7Kw8Eo4EmLLd7Nfk9d19AIeZ/
HaWWWr3QyxY6bLthi4r9BDlECsss4cvOLhCYGtvgk+1JZGQIIJ+3o1Dwot3KtMZ8DD3nXhXc
J4bkOjtSWherqQZTK50Jc2QcAcP9MNKHA2/kFQN6OV9oMYIDCjCCAwYCAQEwUDA7MQswCQYD
VQQGEwJOTDEPMA0GA1UEChMGVEVSRU5BMRswGQYDVQQDExJURVJFTkEgUGVyc29uYWwgQ0EC
EQDwhvYlHZdHibfdyBlsiW2AMAkGBSsOAwIaBQCgggGPMBgGCSqGSIb3DQEJAzELBgkqhkiG
9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDIwMjIyNTcxN1owIwYJKoZIhvcNAQkEMRYEFJ0u
qK+OAo0TfW+7g4YnPSmAdyAaMF8GCSsGAQQBgjcQBDFSMFAwOzELMAkGA1UEBhMCTkwxDzAN
BgNVBAoTBlRFUkVOQTEbMBkGA1UEAxMSVEVSRU5BIFBlcnNvbmFsIENBAhEA8Ib2JR2XR4m3
3cgZbIltgDBhBgsqhkiG9w0BCRACCzFSoFAwOzELMAkGA1UEBhMCTkwxDzANBgNVBAoTBlRF
UkVOQTEbMBkGA1UEAxMSVEVSRU5BIFBlcnNvbmFsIENBAhEA8Ib2JR2XR4m33cgZbIltgDBs
BgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcw
DgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEo
MA0GCSqGSIb3DQEBAQUABIIBANKqa0zLgaAj8cLjbB5r4/xAoWKtjFuqI3m6ugo6O5mTRXut
JjfAszy2KVbLQhsZb9W6JGinTQxW9IMkcqbe0S4VT5sokDg7XXV21PLFs+lpe/66tXGv5nb0
3lQIjIvTY7VEwlLlSPxYsn333vM9WU78dYPwPH1o20ILJP5x1FHLWe29OGkh3egiTmkmAunO
cAOGrlFFdA0DmbZiXl7YD/5XdO4/YC6TofxkXg8URq3evoFteA/6p4MVY3ovUc0gFLVEVFRG
aY+A96HkQe2dVZit3WhS2iNL78dDbysjpfUJ1dm3t32OPoYpQ/ZcQxFpzeJC/TFUIvsJORnD
nAq/9IkAAAAAAAA=
--------------ms070100070002020800000809--
