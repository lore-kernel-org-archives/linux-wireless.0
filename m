Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39787 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3J3VpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 17:45:18 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so1933378wgh.15
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 14:45:16 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/7] wireless-regdb: add DFS ETSI regions
Date: Wed, 30 Oct 2013 22:45:04 +0100
Message-Id: <1383169509-22619-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131030_224527_714873_5428FC47)
In-Reply-To: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This associates the following countries to the
DFS ETSI region:

	AL, AM, AN, AW, AZ, BY, EG, GE, HT,
	IL, KH, KW, MA, OM, RS, RU, SA, TN,
	UA, ZA, ZW

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/db.txt b/db.txt
index 94da96a..1c20be2 100644
--- a/db.txt
+++ b/db.txt
@@ -25,15 +25,15 @@ country AE: DFS-FCC
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country AL:
+country AL: DFS-ETSI
 	(2402 - 2482 @ 20), (20)
 
-country AM:
+country AM: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 20), (18)
 	(5250 - 5330 @ 20), (18), DFS
 
-country AN:
+country AN: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (20)
 	(5250 - 5330 @ 40), (20), DFS
@@ -61,13 +61,13 @@ country AU:
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country AW:
+country AW: DFS-ETSI/
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (20)
 	(5250 - 5330 @ 40), (20), DFS
 	(5490 - 5710 @ 40), (27), DFS
 
-country AZ:
+country AZ: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (18)
 	(5250 - 5330 @ 40), (18), DFS
@@ -133,7 +133,7 @@ country BR: DFS-FCC
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country BY:
+country BY: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (20)
 	(5250 - 5330 @ 40), (20), DFS
@@ -263,7 +263,7 @@ country EE: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country EG:
+country EG: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 20), (20)
 	(5250 - 5330 @ 20), (20), DFS
@@ -292,7 +292,7 @@ country FR: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country GE:
+country GE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (18)
 	(5250 - 5330 @ 40), (18), DFS
@@ -363,7 +363,7 @@ country HR: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country HT:
+country HT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (20)
 	(5250 - 5330 @ 40), (20), DFS
@@ -390,7 +390,7 @@ country IE: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country IL:
+country IL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR
 	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR
@@ -445,7 +445,7 @@ country KE:
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
-country KH:
+country KH: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (20)
 	(5250 - 5330 @ 40), (20), DFS
@@ -519,7 +519,7 @@ country MC: DFS-ETSI
 	(5170 - 5250 @ 40), (18)
 	(5250 - 5330 @ 40), (18), DFS
 
-country MA:
+country MA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (23)
 	(5735 - 5835 @ 80), (23)
@@ -586,7 +586,7 @@ country NZ: DFS-FCC
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country OM:
+country OM: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 40), (17)
 	(5250 - 5330 @ 40), (20), DFS
@@ -661,14 +661,14 @@ country RO: DFS-ETSI
 
 # Source:
 # http://www.ratel.rs/upload/documents/Plan_namene/Plan_namene-sl_glasnik.pdf
-country RS:
+country RS: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
 	(5150 - 5350 @ 40), (200 mW), NO-OUTDOOR
 	(5470 - 5725 @ 20), (1000 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country RU:
+country RU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5330 @ 40), (20)
 	(5650 - 5710 @ 40), (30)
@@ -678,7 +678,7 @@ country RW: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 40), (30)
 
-country SA:
+country SA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
@@ -745,7 +745,7 @@ country TT: DFS-FCC
 	(5490 - 5710 @ 40), (20), DFS
 	(5735 - 5835 @ 40), (30)
 
-country TN:
+country TN: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 20), (20)
 	(5250 - 5330 @ 20), (20), DFS
@@ -765,7 +765,7 @@ country TR: DFS-ETSI
 # Listed 5GHz range is a lowest common denominator for all related
 # rules in the referenced laws. Such a range is used because of
 # disputable definitions there.
-country UA:
+country UA: DFS-ETSI
 	(2400 - 2483.5 @ 40), (20), NO-OUTDOOR
 	(5150 - 5350 @ 40), (20), NO-OUTDOOR
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
@@ -811,13 +811,13 @@ country VN: DFS-FCC
 country YE:
 	(2402 - 2482 @ 40), (20)
 
-country ZA:
+country ZA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
 	(5490 - 5710 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country ZW:
+country ZW: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 
-- 
1.8.4.rc3

