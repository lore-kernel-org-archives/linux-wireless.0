Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:44262 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3J3VpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 17:45:19 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so1850968wes.8
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 14:45:18 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/7] wireless-regdb: add DFS JP regions
Date: Wed, 30 Oct 2013 22:45:05 +0100
Message-Id: <1383169509-22619-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131030_224524_482041_20EF2CC1)
In-Reply-To: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This associates the following countries to the
DFS JP region:

	BD, BH, BN, BO, BZ, CL, DZ, ID, IN, IR
	JP, JO, KE, KP, KR, NP, PK, QA, TW

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/db.txt b/db.txt
index 1c20be2..5ca9704 100644
--- a/db.txt
+++ b/db.txt
@@ -86,7 +86,7 @@ country BB: DFS-FCC
 	(5250 - 5330 @ 40), (23), DFS
 	(5735 - 5835 @ 40), (30)
 
-country BD:
+country BD: DFS-JP
 	(2402 - 2482 @ 40), (20)
 
 country BE: DFS-ETSI
@@ -105,7 +105,7 @@ country BG: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country BH:
+country BH: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 20), (20)
 	(5250 - 5330 @ 20), (20), DFS
@@ -116,13 +116,13 @@ country BL:
 	(5170 - 5250 @ 40), (18)
 	(5250 - 5330 @ 40), (18), DFS
 
-country BN:
+country BN: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (20)
 	(5250 - 5330 @ 40), (20), DFS
 	(5735 - 5835 @ 40), (30)
 
-country BO:
+country BO: DFS-JP
 	(2402 - 2482 @ 40), (30)
 	(5735 - 5835 @ 40), (30)
 
@@ -139,7 +139,7 @@ country BY: DFS-ETSI
 	(5250 - 5330 @ 40), (20), DFS
 	(5490 - 5710 @ 40), (27), DFS
 
-country BZ:
+country BZ: DFS-JP
 	(2402 - 2482 @ 40), (30)
 	(5735 - 5835 @ 40), (30)
 
@@ -158,7 +158,7 @@ country CH: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country CL:
+country CL: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (20)
 	(5250 - 5330 @ 40), (20), DFS
@@ -245,7 +245,7 @@ country DO: DFS-FCC
 	(5250 - 5330 @ 40), (23), DFS
 	(5735 - 5835 @ 40), (30)
 
-country DZ:
+country DZ: DFS-JP
 	(2402 - 2482 @ 40), (20)
 
 country EC: DFS-FCC
@@ -377,7 +377,7 @@ country HU: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country ID:
+country ID: DFS-JP
 	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5815 @ 80), (20)
@@ -395,7 +395,7 @@ country IL: DFS-ETSI
 	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR
 	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR
 
-country IN:
+country IN: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (20)
 	(5250 - 5330 @ 40), (20), DFS
@@ -409,7 +409,7 @@ country IS: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country IR:
+country IR: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
@@ -428,7 +428,7 @@ country JM: DFS-FCC
 	(5490 - 5710 @ 40), (20), DFS
 	(5735 - 5835 @ 40), (30)
 
-country JP:
+country JP: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(2474 - 2494 @ 20), (20), NO-OFDM
 	(4910 - 4990 @ 40), (23)
@@ -437,11 +437,11 @@ country JP:
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 160), (23), DFS
 
-country JO:
+country JO: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (18)
 
-country KE:
+country KE: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
@@ -451,7 +451,7 @@ country KH: DFS-ETSI
 	(5250 - 5330 @ 40), (20), DFS
 	(5490 - 5710 @ 40), (27), DFS
 
-country KP:
+country KP: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5330 @ 40), (20)
 	(5160 - 5250 @ 40), (20), DFS
@@ -575,7 +575,7 @@ country NO: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country NP:
+country NP: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
@@ -619,7 +619,7 @@ country PH: DFS-FCC
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country PK:
+country PK: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
@@ -646,7 +646,7 @@ country PR: DFS-FCC
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country QA:
+country QA: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
@@ -725,7 +725,7 @@ country SV: DFS-FCC
 country SY:
 	(2402 - 2482 @ 40), (20)
 
-country TW:
+country TW: DFS-JP
 	(2402 - 2472 @ 40), (27)
 	(5270 - 5330 @ 40), (17), DFS
 	(5490 - 5710 @ 80), (30), DFS
-- 
1.8.4.rc3

