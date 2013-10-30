Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:64452 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3J3VpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 17:45:15 -0400
Received: by mail-we0-f180.google.com with SMTP id q59so1884230wes.39
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 14:45:14 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/7] wireless-regdb: add DFS FCC regions
Date: Wed, 30 Oct 2013 22:45:03 +0100
Message-Id: <1383169509-22619-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131030_224521_336670_70F7F920)
In-Reply-To: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This associates the following countries to the
DFS FCC region:

	AE, AR, BB, BR, CA, CN, CO, CR, DO, EC,
	GD, GT, GU, HN, JM, LB, LK, MY, MX, NZ,
	PA, PE, PG, PH, PR, RW, SG, SV, TH, TT,
	UY, UZ, VE, VN

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 68 +++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/db.txt b/db.txt
index c938767..94da96a 100644
--- a/db.txt
+++ b/db.txt
@@ -18,7 +18,7 @@ country AD:
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country AE:
+country AE: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -39,7 +39,7 @@ country AN:
 	(5250 - 5330 @ 40), (20), DFS
 	(5490 - 5710 @ 40), (27), DFS
 
-country AR:
+country AR: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -80,7 +80,7 @@ country BA: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country BB:
+country BB: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (23)
 	(5250 - 5330 @ 40), (23), DFS
@@ -126,7 +126,7 @@ country BO:
 	(2402 - 2482 @ 40), (30)
 	(5735 - 5835 @ 40), (30)
 
-country BR:
+country BR: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -143,7 +143,7 @@ country BZ:
 	(2402 - 2482 @ 40), (30)
 	(5735 - 5835 @ 40), (30)
 
-country CA:
+country CA: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -164,7 +164,7 @@ country CL:
 	(5250 - 5330 @ 40), (20), DFS
 	(5735 - 5835 @ 40), (20)
 
-country CN:
+country CN: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 80), (30)
 	# 60 gHz band channels 1,4: 28dBm, channels 2,3: 44dBm
@@ -173,14 +173,14 @@ country CN:
 	(59400 - 63720 @ 2160), (44)
 	(63720 - 65880 @ 2160), (28)
 
-country CO:
+country CO: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country CR:
+country CR: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -239,7 +239,7 @@ country DK: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country DO:
+country DO: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (23), DFS
@@ -248,7 +248,7 @@ country DO:
 country DZ:
 	(2402 - 2482 @ 40), (20)
 
-country EC:
+country EC: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -307,7 +307,7 @@ country GB: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country GD:
+country GD: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (20), DFS
@@ -328,20 +328,20 @@ country GL: DFS-ETSI
 	(5250 - 5330 @ 20), (20), DFS
 	(5490 - 5710 @ 20), (27), DFS
 
-country GT:
+country GT: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (23), DFS
 	(5735 - 5835 @ 40), (30)
 
-country GU:
+country GU: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country HN:
+country HN: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (20), DFS
@@ -421,7 +421,7 @@ country IT: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country JM:
+country JM: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (20), DFS
@@ -473,7 +473,7 @@ country KW:
 country KZ:
 	(2402 - 2482 @ 40), (20)
 
-country LB:
+country LB: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
@@ -483,7 +483,7 @@ country LI: DFS-ETSI
 	(5250 - 5330 @ 40), (20), DFS
 	(5490 - 5710 @ 40), (27), DFS
 
-country LK:
+country LK: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 20), (17)
 	(5250 - 5330 @ 20), (20), DFS
@@ -546,13 +546,13 @@ country MT: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country MY:
+country MY: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (23), DFS
 	(5735 - 5835 @ 80), (30)
 
-country MX:
+country MX: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -579,7 +579,7 @@ country NP:
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
-country NZ:
+country NZ: DFS-FCC
 	(2402 - 2482 @ 40), (30)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -593,26 +593,26 @@ country OM:
 	(5490 - 5710 @ 40), (20), DFS
 	(5735 - 5835 @ 40), (30)
 
-country PA:
+country PA: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (23), DFS
 	(5735 - 5835 @ 40), (30)
 
-country PE:
+country PE: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country PG:
+country PG: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (23), DFS
 	(5735 - 5835 @ 40), (30)
 
-country PH:
+country PH: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -639,7 +639,7 @@ country PT: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country PR:
+country PR: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -674,7 +674,7 @@ country RU:
 	(5650 - 5710 @ 40), (30)
 	(5735 - 5835 @ 40), (30)
 
-country RW:
+country RW: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
@@ -693,7 +693,7 @@ country SE: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country SG:
+country SG: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -716,7 +716,7 @@ country SK: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country SV:
+country SV: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 20), (17)
 	(5250 - 5330 @ 20), (23), DFS
@@ -731,14 +731,14 @@ country TW:
 	(5490 - 5710 @ 80), (30), DFS
 	(5735 - 5815 @ 80), (30)
 
-country TH:
+country TH: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country TT:
+country TT: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (20), DFS
@@ -783,25 +783,25 @@ country US: DFS-FCC
 	# channels 1,2,3, EIRP=40dBm(43dBm peak)
 	(57240 - 63720 @ 2160), (40)
 
-country UY:
+country UY: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (20), DFS
 	(5490 - 5710 @ 40), (20), DFS
 	(5735 - 5835 @ 40), (30)
 
-country UZ:
+country UZ: DFS-FCC
 	(2402 - 2472 @ 40), (27)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (20), DFS
 	(5490 - 5710 @ 40), (20), DFS
 	(5735 - 5835 @ 40), (30)
 
-country VE:
+country VE: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5815 @ 40), (23)
 
-country VN:
+country VN: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
-- 
1.8.4.rc3

