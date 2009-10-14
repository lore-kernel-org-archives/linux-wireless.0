Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns3.uci.cu ([200.55.140.180]:51383 "HELO mx3.uci.cu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760632AbZJNAbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 20:31:31 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ucimail2.uci.cu (Postfix) with ESMTP id 4590EC48007
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 20:25:13 -0400 (CDT)
Received: from [10.8.129.1] (unknown [10.8.129.1])
	by ucimail2.uci.cu (Postfix) with ESMTP id 1C76FC48004
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 20:25:13 -0400 (CDT)
Subject: compat-wireless 2.6.32-rc4 failed to compile
From: Anielkis Herrera Gonzalez <aherrerag@uci.cu>
Reply-To: aherrerag@uci.cu
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="sha1"; protocol="application/x-pkcs7-signature"; boundary="=-jhtKXlKrXia2yugv/w5h"
Date: Tue, 13 Oct 2009 20:24:07 -0400
Message-Id: <1255479847.6242.0.camel@shadow>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jhtKXlKrXia2yugv/w5h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

# uname -r
2.6.32-rc4

and it failed in:
  CC
[M]  /var/tmp/portage/net-wireless/compat-wireless-2.6.32_rc4/work/compat-w=
ireless-2.6.32-rc4/drivers/net/wireless/ipw2x00/ipw2100.o
/var/tmp/portage/net-wireless/compat-wireless-2.6.32_rc4/work/compat-wirele=
ss-2.6.32-rc4/drivers/net/wireless/ipw2x00/ipw2100.c:1: warning: SSE instru=
ction set disabled, using 387 arithmetics
/var/tmp/portage/net-wireless/compat-wireless-2.6.32_rc4/work/compat-wirele=
ss-2.6.32-rc4/drivers/net/wireless/ipw2x00/ipw2100.c: In function 'ipw2100_=
alloc_device':
/var/tmp/portage/net-wireless/compat-wireless-2.6.32_rc4/work/compat-wirele=
ss-2.6.32-rc4/drivers/net/wireless/ipw2x00/ipw2100.c:6060: error: 'struct i=
w_public_data' has no member named 'ieee80211'


--=20
________________________________________________________

           Ing. Anielkis Herrera Gonz=C3=A1lez

            Arquitecto Principal de Nova

                 Linux User #377809


        Universidad de las Ciencias Inform=C3=A1ticas

                        Cuba
________________________________________________________



--=-jhtKXlKrXia2yugv/w5h
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGITCCAtow
ggJDoAMCAQICEE0p9AtdzUkxjleSG1qbGcMwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA5MDYwOTE4MTU0MFoXDTEwMDYwOTE4MTU0
MFowQjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEfMB0GCSqGSIb3DQEJARYQYWhl
cnJlcmFnQHVjaS5jdTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMV57ZN5gtOHMCWr
EJEYoVj3N7nCdUSejXgJt933ZpMZ3ydfaPlBCvMp/Cl7oyJJUkVwGLxIzG9u/9xbulWOEwwI2vax
XfuUTDIl5LmC8P+hFSbRunTFTvI1ke5yqSGjhld5kbt0VnhPzj7n1oXWyGhG8+u08Ws8ZYb8uIBv
QGrQZLqncEe51W/RmvHN5GoirZRaieCIJHHtPx+O8VADyDmpbV8AzNy0hG8wcWi5o5SSxWQMCaZm
CvN2t6PHyPDQ+sASriz4jrF1miKiHDM2Xymo92+hanAo6n1RXt2lagVi3GxNOtwag5Pk77m+gAMI
6ruauOqpJVLrV6NHixKTYP8CAwEAAaMtMCswGwYDVR0RBBQwEoEQYWhlcnJlcmFnQHVjaS5jdTAM
BgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAC9/VVHn8DP2neYDvvfYfbSzut5iQxDgJVDp
EHJiPR+EcTyqVEyTgmk0rS3u4rv+UJgeErGQ1dw8j00YYvdDS9yzb26/iO9dcni+CjIZjRMPE79I
qGCE7ZaUO5GjbZQHGnYCTEZ+MoiUEK2OCNIzfU+0utaLXL/CeIvxc5CBUXWaMIIDPzCCAqigAwIB
AgIBDTANBgkqhkiG9w0BAQUFADCB0TELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2Fw
ZTESMBAGA1UEBxMJQ2FwZSBUb3duMRowGAYDVQQKExFUaGF3dGUgQ29uc3VsdGluZzEoMCYGA1UE
CxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNlcyBEaXZpc2lvbjEkMCIGA1UEAxMbVGhhd3RlIFBlcnNv
bmFsIEZyZWVtYWlsIENBMSswKQYJKoZIhvcNAQkBFhxwZXJzb25hbC1mcmVlbWFpbEB0aGF3dGUu
Y29tMB4XDTAzMDcxNzAwMDAwMFoXDTEzMDcxNjIzNTk1OVowYjELMAkGA1UEBhMCWkExJTAjBgNV
BAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25h
bCBGcmVlbWFpbCBJc3N1aW5nIENBMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEpjxVc1X7
TrnKmVoeaMB1BHCd3+n/ox7svc31W/Iadr1/DDph8r9RzgHU5VAKMNcCY1osiRVwjt3J8CuFWqo/
cVbLrzwLB+fxH5E2JCoTzyvV84J3PQO+K/67GD4Hv0CAAmTXp6a7n2XRxSpUhQ9IBH+nttE8YQRA
HmQZcmC3+wIDAQABo4GUMIGRMBIGA1UdEwEB/wQIMAYBAf8CAQAwQwYDVR0fBDwwOjA4oDagNIYy
aHR0cDovL2NybC50aGF3dGUuY29tL1RoYXd0ZVBlcnNvbmFsRnJlZW1haWxDQS5jcmwwCwYDVR0P
BAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwyLTEzODANBgkqhkiG
9w0BAQUFAAOBgQBIjNFQg+oLLswNo2asZw9/r6y+whehQ5aUnX9MIbj4Nh+qLZ82L8D0HFAgk3A8
/a3hYWLD2ToZfoSxmRsAxRoLgnSeJVCUYsfbJ3FXJY3dqZw5jowgT2Vfldr394fWxghOrvbqNOUQ
Gls1TXfjViF4gtwhGTXeJLHTHUb/XV9lTzGCAfwwggH4AgEBMHYwYjELMAkGA1UEBhMCWkExJTAj
BgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJz
b25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhBNKfQLXc1JMY5XkhtamxnDMAkGBSsOAwIaBQCgXTAY
BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wOTEwMTQwMDI0MDRaMCMG
CSqGSIb3DQEJBDEWBBRcmMXS4616t0BNLt0yEAyXRwfLrjANBgkqhkiG9w0BAQEFAASCAQBCuIM4
HUZ7xiOd231aP2UHlm3H8VKocj+NnFWDCmdzjBmZJAeHMMKxa5vD+ty9RabKPXo3RxUhAE8D2CYE
CtpYMK29ag1tq1gzE+K/cm6IUg0RwttRmfFJH3hoyNoIcNcUEtQR5R97AKD6QcUbxWJkolXOWbFm
8JWW43+CA5B8lIRvlsiG2xayIjpxu8GgUUpubSEUsXWu/G0gWApAsY03U7H2V4CWzxQCqNV06B8T
FsDvs4l321/CeS6arDy0N7RtPIECX8G0p4qIJY/BnQRhtfA7KQUj3xnxBQtQtimBa5EzU708CjXG
q9W1GtRB3AShtfV0V9igpGV3FRJxd3A5AAAAAAAA


--=-jhtKXlKrXia2yugv/w5h--

