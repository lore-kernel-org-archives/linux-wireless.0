Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49194 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2K2Hiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 02:38:51 -0500
From: "Bu, Jinsong" <jinsong@qca.qualcomm.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"Balasubramanian, Senthil Kumar" <senthilb@qca.qualcomm.com>,
	"Mani, Raja" <rmani@qca.qualcomm.com>,
	"Sundar, Mohan Kumar" <msundar@qca.qualcomm.com>,
	"Jin, Navy" <nhjin@qca.qualcomm.com>,
	"Thiagarajan, Vasanthakumar" <vthiagar@qca.qualcomm.com>,
	"Yuan, Ye" <yeyuan@qca.qualcomm.com>
Subject: [patch] add K3 and PS to db.txt
Date: Thu, 29 Nov 2012 07:38:32 +0000
Message-ID: <A16247DB21CEBB409D0827EB13D43B451696F72F@NASANEXD02E.na.qualcomm.com> (sfid-20121129_083855_317085_C2164957)
References: <A16247DB21CEBB409D0827EB13D43B4501F6200E@NASANEXD02E.na.qualcomm.com>
 <9DB666D2CF7F704E84559F1AEF4EBA97193ECF5C@aphydexd01a>
 <906BB7F9E7542D408351AC9D2A8FDABA03DC4DE0@nasanexd02f.na.qualcomm.com>
 <50B6EFC4.4070505@qca.qualcomm.com>
In-Reply-To: <50B6EFC4.4070505@qca.qualcomm.com>
Content-Type: multipart/mixed;
	boundary="_002_A16247DB21CEBB409D0827EB13D43B451696F72FNASANEXD02Enaqu_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_A16247DB21CEBB409D0827EB13D43B451696F72FNASANEXD02Enaqu_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi John,

I created a patch to add K3 and PS country string to db.txt, please review =
the patch.

Note that I copied KP's rules for K3 since they are all APL9_WORLD.

---------------------------------------------------------------------------=
----------------------------------------------------------
>From a006587d846cd91a07d3e232421947bc3f96e235 Mon Sep 17 00:00:00 2001
From: jinsong <jinsong@qca.qualcomm.com>
Date: Thu, 29 Nov 2012 15:15:21 +0800
Subject: [PATCH] add K3 and PS


Signed-off-by: jinsong <jinsong@qca.qualcomm.com>
---
 db.txt |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/db.txt b/db.txt
index 4c54543..a7ff207 100644
--- a/db.txt
+++ b/db.txt
@@ -391,6 +391,13 @@ country JO:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 18)
=20
+country K3:
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5330 @ 40), (3, 20)
+	(5160 - 5250 @ 40), (3, 20), DFS
+	(5490 - 5630 @ 40), (3, 30), DFS
+	(5735 - 5815 @ 40), (3, 30)
+
 country KE:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5735 - 5835 @ 40), (N/A, 30)
@@ -554,6 +561,12 @@ country PL: DFS-ETSI
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
=20
+country PS:
+	(2402 - 2472 @ 40), (3, 27)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 23), DFS
+	(5735 - 5835 @ 40), (3, 30)
+
 country PT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
--=20
1.7.9.5


Best Regards
Jinsong Bu

--_002_A16247DB21CEBB409D0827EB13D43B451696F72FNASANEXD02Enaqu_
Content-Type: application/octet-stream; name="0001-add-K3-and-PS.patch"
Content-Description: 0001-add-K3-and-PS.patch
Content-Disposition: attachment; filename="0001-add-K3-and-PS.patch";
	size=1096; creation-date="Thu, 29 Nov 2012 07:17:39 GMT";
	modification-date="Thu, 29 Nov 2012 07:16:20 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhMDA2NTg3ZDg0NmNkOTFhMDdkM2UyMzI0MjE5NDdiYzNmOTZlMjM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBqaW5zb25nIDxqaW5zb25nQHFjYS5xdWFsY29tbS5jb20+CkRh
dGU6IFRodSwgMjkgTm92IDIwMTIgMTU6MTU6MjEgKzA4MDAKU3ViamVjdDogW1BBVENIXSBhZGQg
SzMgYW5kIFBTCgoKU2lnbmVkLW9mZi1ieTogamluc29uZyA8amluc29uZ0BxY2EucXVhbGNvbW0u
Y29tPgotLS0KIGRiLnR4dCB8ICAgMTMgKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEz
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kYi50eHQgYi9kYi50eHQKaW5kZXggNGM1NDU0
My4uYTdmZjIwNyAxMDA2NDQKLS0tIGEvZGIudHh0CisrKyBiL2RiLnR4dApAQCAtMzkxLDYgKzM5
MSwxMyBAQCBjb3VudHJ5IEpPOgogCSgyNDAyIC0gMjQ4MiBAIDQwKSwgKE4vQSwgMjApCiAJKDUx
NzAgLSA1MjUwIEAgNDApLCAoTi9BLCAxOCkKIAorY291bnRyeSBLMzoKKwkoMjQwMiAtIDI0ODIg
QCA0MCksIChOL0EsIDIwKQorCSg1MTcwIC0gNTMzMCBAIDQwKSwgKDMsIDIwKQorCSg1MTYwIC0g
NTI1MCBAIDQwKSwgKDMsIDIwKSwgREZTCisJKDU0OTAgLSA1NjMwIEAgNDApLCAoMywgMzApLCBE
RlMKKwkoNTczNSAtIDU4MTUgQCA0MCksICgzLCAzMCkKKwogY291bnRyeSBLRToKIAkoMjQwMiAt
IDI0ODIgQCA0MCksIChOL0EsIDIwKQogCSg1NzM1IC0gNTgzNSBAIDQwKSwgKE4vQSwgMzApCkBA
IC01NTQsNiArNTYxLDEyIEBAIGNvdW50cnkgUEw6IERGUy1FVFNJCiAJKDUyNTAgLSA1MzMwIEAg
NDApLCAoTi9BLCAyMCksIERGUwogCSg1NDkwIC0gNTcxMCBAIDQwKSwgKE4vQSwgMjcpLCBERlMK
IAorY291bnRyeSBQUzoKKwkoMjQwMiAtIDI0NzIgQCA0MCksICgzLCAyNykKKwkoNTE3MCAtIDUy
NTAgQCA0MCksICgzLCAxNykKKwkoNTI1MCAtIDUzMzAgQCA0MCksICgzLCAyMyksIERGUworCSg1
NzM1IC0gNTgzNSBAIDQwKSwgKDMsIDMwKQorCiBjb3VudHJ5IFBUOiBERlMtRVRTSQogCSgyNDAy
IC0gMjQ4MiBAIDQwKSwgKE4vQSwgMjApCiAJKDUxNzAgLSA1MjUwIEAgNDApLCAoTi9BLCAyMCkK
LS0gCjEuNy45LjUKCg==

--_002_A16247DB21CEBB409D0827EB13D43B451696F72FNASANEXD02Enaqu_--
