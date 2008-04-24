Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.store20.com ([212.7.7.16]:51222 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706AbYDXKuq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 06:50:46 -0400
Subject: [PATCH] iwlwifi: Select also LEDS_TRIGGERS.
From: Priit Laes <plaes@plaes.org>
To: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Cc: yi.zhu@intel.com, reinette.chatre@intel.com
Content-Type: multipart/mixed; boundary="=-W4kGWQmgyE2258Us2gI5"
Date: Thu, 24 Apr 2008 13:42:47 +0300
Message-Id: <1209033767.1368.3.camel@localhost> (sfid-20080424_125133_220434_0A173D50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W4kGWQmgyE2258Us2gI5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Following patch fixes build for me..

--=-W4kGWQmgyE2258Us2gI5
Content-Description: 
Content-Type: application/mbox
Content-Disposition: inline; filename=iwlwifi-fix-leds-build.patch
Content-Transfer-Encoding: base64

RnJvbSBmNzI4OGIxOTRmYTc5ODQyNDZmNTZmMjI4NzEyY2IzZGM2ODgyMjk0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQcmlpdCBMYWVzIDxwbGFlc0BwbGFlcy5vcmc+CkRhdGU6IFRo
dSwgMjQgQXByIDIwMDggMTM6MzY6NDkgKzAzMDAKU3ViamVjdDogW1BBVENIXSBpd2x3aWZpOiBT
ZWxlY3QgYWxzbyBMRURTX1RSSUdHRVJTLgoKU2lnbmVkLW9mZi1ieTogUHJpaXQgTGFlcyA8cGxh
ZXNAcGxhZXMub3JnPgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvS2NvbmZpZyB8
ICAgIDIgKysKIDEgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvS2NvbmZpZyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvS2NvbmZpZwppbmRleCBjNGU2MzFkLi41NTE4MDE3
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL0tjb25maWcKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9LY29uZmlnCkBAIC01Miw2ICs1Miw3IEBAIGNv
bmZpZyBJV0w0OTY1X0xFRFMKIAlkZXBlbmRzIG9uIElXTDQ5NjUKIAlzZWxlY3QgTUFDODAyMTFf
TEVEUwogCXNlbGVjdCBMRURTX0NMQVNTCisJc2VsZWN0IExFRFNfVFJJR0dFUlMKIAlzZWxlY3Qg
SVdMV0lGSV9MRURTCiAJLS0taGVscC0tLQogCSAgVGhpcyBvcHRpb24gZW5hYmxlcyBMRURTIGZv
ciB0aGUgaXdsd2lmaSBkcml2ZXJzCkBAIC0xMzksNiArMTQwLDcgQEAgY29uZmlnIElXTDM5NDVf
TEVEUwogCWRlcGVuZHMgb24gSVdMMzk0NQogCXNlbGVjdCBNQUM4MDIxMV9MRURTCiAJc2VsZWN0
IExFRFNfQ0xBU1MKKwlzZWxlY3QgTEVEU19UUklHR0VSUwogCS0tLWhlbHAtLS0KIAkgIFRoaXMg
b3B0aW9uIGVuYWJsZXMgTEVEUyBmb3IgdGhlIGl3bDM5NDUgZHJpdmVyLgogCi0tIAoxLjUuNC41
Cgo=


--=-W4kGWQmgyE2258Us2gI5--
