Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:35304 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDMUOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 16:14:17 -0400
Received: by fg-out-1718.google.com with SMTP id 16so391192fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 13:14:15 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 13 Apr 2009 22:14:00 +0200
Message-ID: <69e28c910904131314s49f0c2e2w55b7098f662aa3fe@mail.gmail.com> (sfid-20090413_221421_218737_B3D38F02)
Subject: [PATCH RFC] rtl8187: Call 8187L variants "RTL8187LvX" rather than
	"RTL8187vX"
To: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Content-Type: multipart/mixed; boundary=000e0cd24762c53b390467755bfa
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd24762c53b390467755bfa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

We call RTL8187B chips "RTL8187BvX" (X is the revision), so we should
call RTL8187L ones "RTL8187LvX", not "RTL8187vX".

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---
Patch also available as an attachment if Gmail linewraps the inline version=
.

rtl8187_dev.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

---
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c~
b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index fd81884..0eb5c4c 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c~
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1415,10 +1415,10 @@ static int __devinit rtl8187_probe(struct
usb_interface *intf,
 			priv->hw_rev =3D RTL8187BvB;
 			break;
 		case RTL818X_TX_CONF_R8187vD:
-			chip_name =3D "RTL8187vD";
+			chip_name =3D "RTL8187LvD";
 			break;
 		default:
-			chip_name =3D "RTL8187vB (default)";
+			chip_name =3D "RTL8187LvB (default)";
 		}
        } else {
 		/*

--000e0cd24762c53b390467755bfa
Content-Type: text/x-patch; charset=US-ASCII;
	name="rtl8187-call-8187l-chips-rtl8187lvx.patch"
Content-Disposition: attachment;
	filename="rtl8187-call-8187l-chips-rtl8187lvx.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fthlo4vd0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bDgxOHgvcnRsODE4N19kZXYuY34g
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGw4MTh4L3J0bDgxODdfZGV2LmMKaW5kZXggZmQ4MTg4
NC4uMGViNWM0YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsODE4eC9ydGw4
MTg3X2Rldi5jfgorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGw4MTh4L3J0bDgxODdfZGV2
LmMKQEAgLTE0MTUsMTAgKzE0MTUsMTAgQEAgc3RhdGljIGludCBfX2RldmluaXQgcnRsODE4N19w
cm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZiwKIAkJCXByaXYtPmh3X3JldiA9IFJUTDgx
ODdCdkI7CiAJCQlicmVhazsKIAkJY2FzZSBSVEw4MThYX1RYX0NPTkZfUjgxODd2RDoKLQkJCWNo
aXBfbmFtZSA9ICJSVEw4MTg3dkQiOworCQkJY2hpcF9uYW1lID0gIlJUTDgxODdMdkQiOwogCQkJ
YnJlYWs7CiAJCWRlZmF1bHQ6Ci0JCQljaGlwX25hbWUgPSAiUlRMODE4N3ZCIChkZWZhdWx0KSI7
CisJCQljaGlwX25hbWUgPSAiUlRMODE4N0x2QiAoZGVmYXVsdCkiOwogCQl9CiAgICAgICAgfSBl
bHNlIHsKIAkJLyoK
--000e0cd24762c53b390467755bfa--
