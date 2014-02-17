Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp130.uni-oldenburg.de ([134.106.141.130]:49476 "EHLO
	smtp130.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBQRFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 12:05:47 -0500
Message-ID: <53023E51.90202@Uni-Oldenburg.DE> (sfid-20140217_180551_234247_4B66834B)
Date: Mon, 17 Feb 2014 17:52:33 +0100
From: Bernd Wagener <Bernd.Wagener@Uni-Oldenburg.DE>
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>,
	Arend van Spriel <arend@broadcom.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
	frankyl@broadcom.com
Subject: Re: brcmfmac NVRAM files
References: <20140217150640.GJ18868@zurbaran> <20140217163315.GA22010@zurbaran>
In-Reply-To: <20140217163315.GA22010@zurbaran>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060106030108090804030206"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060106030108090804030206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 17.02.2014 17:33, schrieb Samuel Ortiz:
> On Mon, Feb 17, 2014 at 04:06:40PM +0100, Samuel Ortiz wrote:
>> Hi Arend,
>>
>> I'm trying to use a 43241 SDIO chip here, and it fails asking for the
>> .txt file (brcmfmac43241b4-sdio.txt). This seems to be an NVRAM map
>> file, but I could not find either a template on linux-firmware or any
>> kind of documentation about it.
>>
>> How do distro handle that ? Are they expected to build their own, or i=
s
>> it completely OEM pecific ?
> Adding Franky to the Cc list.
>
> Cheers,
> Samuel.
>
Hi Samuel,
I had the same proble with a wandboard here and I guess it's a bug. In=20
/lib/firmware/brcm are all reqired *.bin files, but no *.txt file. On=20
www.wandboard.or I found a SDK-Kit with brcmfmac4329-sdio.txt, copied=20
the file and then the wlan was running.
The *.txt are simply forgotten to copy to the firmware directory.
No idea how to fix this.

Bernd


--------------ms060106030108090804030206
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIII6TCC
BBYwggL+oAMCAQICCwQAAAAAAS9O4SzhMA0GCSqGSIb3DQEBBQUAMFcxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMRAwDgYDVQQLEwdSb290IENBMRswGQYDVQQD
ExJHbG9iYWxTaWduIFJvb3QgQ0EwHhcNMTEwNDEzMTAwMDAwWhcNMTkwNDEzMTAwMDAwWjBU
MQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEqMCgGA1UEAxMhR2xv
YmFsU2lnbiBQZXJzb25hbFNpZ24gMSBDQSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEA8aUcr5BvPNGjx0+LH0uRqeZCHrYQ7KN3QuahfxY8fAzAbnvNDzGdEMyKn3+Y
X+k/QbAGNJOSFRxrAfhviF7WGcqDlin3HracDqMRgwrknWuFeqxhN2J7uXs3Y0zluJEkEitt
RXv+ZdXOG/Gp3gtoz5P9noc5jBbfWQpQBhcaJA2ucABbUVTHDTxi7dBY8mTWq6kRAkGWBybH
wq0YX+jaHudtQw0oBEmxjpJFP9qIXu0ckU/+OhtnAhrgzrsd4oAyqgc6u4dBYERcjDJFohih
jbzPozgKDSSbdr44uO3p9Bg6ibjCxn2besLrIE7upoxvV09Fsf7hDeD/jcvs64z8pQIDAQAB
o4HlMIHiMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBTs
rJjMJ3KTz1YyzSPHnY1FhfQiAzBHBgNVHSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wMwYDVR0fBCwwKjAooCag
JIYiaHR0cDovL2NybC5nbG9iYWxzaWduLm5ldC9yb290LmNybDAfBgNVHSMEGDAWgBRge2Ya
RQ2XyolQL30EzTSo//z9SzANBgkqhkiG9w0BAQUFAAOCAQEAr7unyEtmt9Ia7hmNpqP+xMd0
t5hLM0QBY8G3Dlg70XI6F+ZeSZeeXgCtUT/JhdQ+HsJ8+c6HypDuvg/OZ0gILDFIa9LDfRWm
+tHIgxKaJjtCy0izg838dLwwnt/O3kA9N/htEYev2lsmWYCV9cVUm5V1tW3XuYNg6SbtcDRH
+Ki1RED9es3R0BgHSm012KPxsiAOOxuhm1D3Iqs1qe6ms5WTKXVgwb/j/kplOa13nshhc8zU
LVO+oAlD4+7czNK2RJiTvhJiDJDRTZy3DJ3BCQ8rXOGdWzDEI5uiB8TZ0s327g44Ylc6dgKg
YelNn9RLYjNETX8OIJZlr0tFYpcYrDCCBMswggOzoAMCAQICEGZgT+TGYtW+XJFIVmQFPNsw
DQYJKoZIhvcNAQEFBQAwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExKjAoBgNVBAMTIUdsb2JhbFNpZ24gUGVyc29uYWxTaWduIDEgQ0EgLSBHMjAeFw0xMzEx
MTgxNDM3MTNaFw0xNjExMTgxNDM3MTNaMFgxJzAlBgNVBAMMHkJlcm5kLldhZ2VuZXJAVW5p
LU9sZGVuYnVyZy5ERTEtMCsGCSqGSIb3DQEJARYeQmVybmQuV2FnZW5lckBVbmktT2xkZW5i
dXJnLkRFMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxyaWvO97GDUCDrrd6OuN
g+yJzxX8N7ROP2h2x3FWhjLBRewm0h1/hwGVLZLM7pnf51PLRVZISGnfnjysaVfPF1Y/X2c7
yUK6PQFQteMeeg3dxfhkRhCll13GFTyv77QpblMKXLvlzHLAHbEO7ZpkpZqpbxmc5bBbTyLv
IwUg12X7Qpe6KJL3O0+xyFaJ46EjRPkhcDqmXJlUcWJBQh01+0uXx6RSEgw/7AiRRRPpj0N/
F6jqtUlJPk3Dbr7gMdUG5DN8WQVfuBcqiNRo5aiQiRHIrvnlMOE6z7AB7JLKLCckzfXpgfs9
6+JwI5mKP4BwrGHAHAXkuPBKJNMmfMmRTwIDAQABo4IBkzCCAY8wDgYDVR0PAQH/BAQDAgWg
MEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmds
b2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMCkGA1UdEQQiMCCBHkJlcm5kLldhZ2VuZXJAVW5p
LU9sZGVuYnVyZy5ERTAJBgNVHRMEAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
BDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzL2dzcGVy
c29uYWxzaWduMWcyLmNybDBVBggrBgEFBQcBAQRJMEcwRQYIKwYBBQUHMAKGOWh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMWcyLmNydDAdBgNV
HQ4EFgQUo6v6aPpk9tm4GPs+owgUjzzuzuEwHwYDVR0jBBgwFoAU7KyYzCdyk89WMs0jx52N
RYX0IgMwDQYJKoZIhvcNAQEFBQADggEBAFRYw1pQE69c8Q+siLv/z5rkwEYmtvDFEHPKzZXF
mNU7ZHD4PvA8QPXeMvyDJnwOztUce3YkwpszDehNhZX6pu9WsnOwjPBdvvTvm9oVJHFIwZmU
fjvC6I1D/Z0s4QU/2WorrElbQl/AR7hnK3PhLQxcHjSyskRaB7CGoBnPqhjWzZ4s3sedMlpG
NWbDQrlKhz1BSaW0K9tSQgv76hXTgNJn5W4CgtDy7uQz93NetWOusWP+w1PQ2VetDeES9xuF
UgD/r+y0ct8Tzs6tJIWpY8+IQiaFRLrrvUqCF+oqQS1JQOY8H/MX9YX9CZKm01ZW9RJAFZK9
4h0ODdPV4XOJn60xggNSMIIDTgIBATBoMFQxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAxIENBIC0g
RzICEGZgT+TGYtW+XJFIVmQFPNswCQYFKw4DAhoFAKCCAb8wGAYJKoZIhvcNAQkDMQsGCSqG
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwMjE3MTY1MjMzWjAjBgkqhkiG9w0BCQQxFgQU
93CegviJnMxZhJbL92S05DYbuDEwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAH
BgUrDgMCBzANBggqhkiG9w0DAgIBKDB3BgkrBgEEAYI3EAQxajBoMFQxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIFBlcnNv
bmFsU2lnbiAxIENBIC0gRzICEGZgT+TGYtW+XJFIVmQFPNsweQYLKoZIhvcNAQkQAgsxaqBo
MFQxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFH
bG9iYWxTaWduIFBlcnNvbmFsU2lnbiAxIENBIC0gRzICEGZgT+TGYtW+XJFIVmQFPNswDQYJ
KoZIhvcNAQEBBQAEggEAgCv7qByUsZHttQ/eArDpRcqtOmvXRB1V2WUs8JBTFugGRuDuFufp
ZRVo/MGaPhgFNPXB5nNx3VCyOlnFCvmzkwixgYqGCi8YchIoc3hH5vbEtW2FHoIB5o7MOq83
yywsG1QRVldTmBnysBw/QO7pqe5TuKecDOdT6Ya537o76C4Bqf2LP3Kt8basWWtSEbrdo3+J
cMyR6zKhCCzvejlhhcmtIBP/lZ9yVF7u5BDTeyuqmMWIVNwtEcsRd+9/kwP7bFbDSz6FvSJe
FOSxO/VvtkjefLbw70yHMM0weCuHPyeDJTxK4Q1WhCprNmWeEs9Mwt5yoNcsSInV2EWoBApM
hwAAAAAAAA==
--------------ms060106030108090804030206--
