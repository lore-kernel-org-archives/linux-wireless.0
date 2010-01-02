Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:61619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab0ABQXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 11:23:20 -0500
Content-Type: multipart/mixed; boundary=----------NRtmWjVGFevrIJUHqqf5yG
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Sat, 02 Jan 2010 17:24:32 +0100
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Add new SSB's core id for BCM4328
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u5wyi5dd9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------------NRtmWjVGFevrIJUHqqf5yG
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: Quoted-Printable

Finally I've possibility to test my Christmas-gift N-PHY :) b43 didn't r=
eally "notice" it, so I needed to write this little patch. Now b43 at le=
ast look for firmware for my card.

Does this patch look OK?

This time I post from Opera mail so I hope white-spaces will be fine.

 From 9b3ea4f29b038f732aba737323e2f89b275ce1ab Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Rafa=3DC5=3D82=3D20Mi=3DC5=3D82ecki?=3D <zajec5@gmail.=
com>
Date: Sat, 2 Jan 2010 16:58:16 +0100
Subject: [PATCH] b43: Add new SSB's core id for BCM4328
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Following line shows my BCM4328 detected on SSB. We didn't include 0x0C =
rev.
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)

Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/main.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/=
main.c
index 098dda1..3aa45b8 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -110,6 +110,7 @@ static const struct ssb_device_id b43_ssb_tbl[] =3D =
{
         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 11),
+       SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 12),
         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 15),
         SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 16),
--
1.6.4.2
------------NRtmWjVGFevrIJUHqqf5yG
Content-Disposition: attachment; filename=0001-b43-Add-new-SSB-s-core-id-for-BCM4328.patch
Content-Type: application/octet-stream; name=0001-b43-Add-new-SSB-s-core-id-for-BCM4328.patch
Content-Transfer-Encoding: Base64

RnJvbSA5YjNlYTRmMjliMDM4ZjczMmFiYTczNzMyM2UyZjg5YjI3NWNlMWFiIE1v
biBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UmFmYT1DNT04
Mj0yME1pPUM1PTgyZWNraT89IDx6YWplYzVAZ21haWwuY29tPgpEYXRlOiBTYXQs
IDIgSmFuIDIwMTAgMTY6NTg6MTYgKzAxMDAKU3ViamVjdDogW1BBVENIXSBiNDM6
IEFkZCBuZXcgU1NCJ3MgY29yZSBpZCBmb3IgQkNNNDMyOApNSU1FLVZlcnNpb246
IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgKQ29u
dGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKRm9sbG93aW5nIGxpbmUgc2hv
d3MgbXkgQkNNNDMyOCBkZXRlY3RlZCBvbiBTU0IuIFdlIGRpZG4ndCBpbmNsdWRl
IDB4MEMgcmV2Lgpzc2I6IENvcmUgMSBmb3VuZDogSUVFRSA4MDIuMTEgKGNjIDB4
ODEyLCByZXYgMHgwQywgdmVuZG9yIDB4NDI0MykKClNpZ25lZC1vZmYtYnk6IFJh
ZmHFgiBNacWCZWNraSA8emFqZWM1QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL25l
dC93aXJlbGVzcy9iNDMvbWFpbi5jIHwgICAgMSArCiAxIGZpbGVzIGNoYW5nZWQs
IDEgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9iNDMvbWFpbi5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYjQzL21haW4uYwppbmRleCAwOThkZGExLi4zYWE0NWI4IDEwMDY0NAot
LS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvbWFpbi5jCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2I0My9tYWluLmMKQEAgLTExMCw2ICsxMTAsNyBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IHNzYl9kZXZpY2VfaWQgYjQzX3NzYl90YmxbXSA9
IHsKIAlTU0JfREVWSUNFKFNTQl9WRU5ET1JfQlJPQURDT00sIFNTQl9ERVZfODAy
MTEsIDkpLAogCVNTQl9ERVZJQ0UoU1NCX1ZFTkRPUl9CUk9BRENPTSwgU1NCX0RF
Vl84MDIxMSwgMTApLAogCVNTQl9ERVZJQ0UoU1NCX1ZFTkRPUl9CUk9BRENPTSwg
U1NCX0RFVl84MDIxMSwgMTEpLAorCVNTQl9ERVZJQ0UoU1NCX1ZFTkRPUl9CUk9B
RENPTSwgU1NCX0RFVl84MDIxMSwgMTIpLAogCVNTQl9ERVZJQ0UoU1NCX1ZFTkRP
Ul9CUk9BRENPTSwgU1NCX0RFVl84MDIxMSwgMTMpLAogCVNTQl9ERVZJQ0UoU1NC
X1ZFTkRPUl9CUk9BRENPTSwgU1NCX0RFVl84MDIxMSwgMTUpLAogCVNTQl9ERVZJ
Q0UoU1NCX1ZFTkRPUl9CUk9BRENPTSwgU1NCX0RFVl84MDIxMSwgMTYpLAotLSAK
MS42LjQuMgoK

------------NRtmWjVGFevrIJUHqqf5yG--

