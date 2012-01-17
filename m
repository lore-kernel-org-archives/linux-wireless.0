Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41232 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab2AQPYX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 10:24:23 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: zefir.kurtisi@linux.com, rodrigue@qca.qualcomm.com,
	linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] wireless-regdb: set ETSI as DFS region for EU
Date: Tue, 17 Jan 2012 16:22:59 +0100
Message-Id: <1326813779-8475-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120117_162435_879494_1FD9EF36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

European countries are all in the ETSI DFS regulatory domain.

The added DFS region information is handled by
[wireless-regdb: Add master DFS region support]

Without that patch, the additional attribute is ignored.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 db.txt |   74 ++++++++++++++++++++++++++++++++--------------------------------
 1 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/db.txt b/db.txt
index f0b46d8..40e5ba9 100644
--- a/db.txt
+++ b/db.txt
@@ -39,7 +39,7 @@ country AR:
 	(5490 - 5710 @ 40), (3, 20), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
-country AT:
+country AT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -62,7 +62,7 @@ country AZ:
 	(5170 - 5250 @ 40), (N/A, 18)
 	(5250 - 5330 @ 40), (N/A, 18), DFS
 
-country BA:
+country BA: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -77,13 +77,13 @@ country BB:
 country BD:
 	(2402 - 2482 @ 40), (N/A, 20)
 
-country BE:
+country BE: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country BG:
+country BG: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 23)
 	(5250 - 5290 @ 40), (N/A, 23), DFS
@@ -134,7 +134,7 @@ country CA:
 	(5490 - 5710 @ 40), (3, 20), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
-country CH:
+country CH: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -168,7 +168,7 @@ country CS:
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country CY:
+country CY: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -178,7 +178,7 @@ country CY:
 # and http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
 # Power at 5250 - 5350 MHz and 5470 - 5725 MHz can be doubled if TPC is
 # implemented.
-country CZ:
+country CZ: DFS-ETSI
 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
 	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
@@ -196,7 +196,7 @@ country CZ:
 # apps relies on the attenuation by the building walls only in the
 # absence of DFS; the neighbour countries have 100mW limit here as well.
 
-country DE:
+country DE: DFS-ETSI
 	# entries 279004 and 280006
 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
 	# entry 303005
@@ -206,7 +206,7 @@ country DE:
 	# entries 308002, 309001 and 310003
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
 
-country DK:
+country DK: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -227,7 +227,7 @@ country EC:
 	(5250 - 5330 @ 20), (3, 23), DFS
 	(5735 - 5835 @ 20), (3, 30)
 
-country EE:
+country EE: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -238,19 +238,19 @@ country EG:
 	(5170 - 5250 @ 20), (N/A, 20)
 	(5250 - 5330 @ 20), (N/A, 20), DFS
 
-country ES:
+country ES: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country FI:
+country FI: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country FR:
+country FR: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -261,7 +261,7 @@ country GE:
 	(5170 - 5250 @ 40), (N/A, 18)
 	(5250 - 5330 @ 40), (N/A, 18), DFS
 
-country GB:
+country GB: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -274,13 +274,13 @@ country GD:
 	(5490 - 5710 @ 40), (3, 20), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
-country GR:
+country GR: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country GL:
+country GL: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 20), (N/A, 20)
 	(5250 - 5330 @ 20), (N/A, 20), DFS
@@ -312,7 +312,7 @@ country HK:
 	(5490 - 5710 @ 40), (3, 20), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
-country HR:
+country HR: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -324,7 +324,7 @@ country HT:
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country HU:
+country HU: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -333,7 +333,7 @@ country HU:
 country ID:
 	(2402 - 2482 @ 40), (N/A, 20)
 
-country IE:
+country IE: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -350,7 +350,7 @@ country IN:
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5735 - 5835 @ 40), (N/A, 20)
 
-country IS:
+country IS: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -360,7 +360,7 @@ country IR:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5735 - 5835 @ 40), (N/A, 30)
 
-country IT:
+country IT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -427,7 +427,7 @@ country LB:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5735 - 5835 @ 40), (N/A, 30)
 
-country LI:
+country LI: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -440,25 +440,25 @@ country LK:
 	(5490 - 5710 @ 20), (3, 20), DFS
 	(5735 - 5835 @ 20), (3, 30)
 
-country LT:
+country LT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country LU:
+country LU: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country LV:
+country LV: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country MC:
+country MC: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 18)
 	(5250 - 5330 @ 40), (N/A, 18), DFS
@@ -472,13 +472,13 @@ country MO:
 	(5250 - 5330 @ 40), (3, 23), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
-country MK:
+country MK: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country MT:
+country MT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -495,13 +495,13 @@ country MX:
 	(5250 - 5330 @ 40), (3, 23), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
-country NL:
+country NL: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20), NO-OUTDOOR
 	(5250 - 5330 @ 40), (N/A, 20), NO-OUTDOOR, DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country NO:
+country NO: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -548,13 +548,13 @@ country PK:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5735 - 5835 @ 40), (N/A, 30)
 
-country PL:
+country PL: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country PT:
+country PT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -570,7 +570,7 @@ country QA:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5735 - 5835 @ 40), (N/A, 30)
 
-country RO:
+country RO: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -586,7 +586,7 @@ country SA:
 	(5250 - 5330 @ 20), (3, 23), DFS
 	(5735 - 5835 @ 20), (3, 30)
 
-country SE:
+country SE: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -598,13 +598,13 @@ country SG:
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5735 - 5835 @ 40), (N/A, 20)
 
-country SI:
+country SI: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
-country SK:
+country SK: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
@@ -643,7 +643,7 @@ country TN:
 	(5170 - 5250 @ 20), (N/A, 20)
 	(5250 - 5330 @ 20), (N/A, 20), DFS
 
-country TR:
+country TR: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 20), (N/A, 20)
 	(5250 - 5330 @ 20), (N/A, 20), DFS
-- 
1.7.4.1

