Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38847 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbbJOOTY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 10:19:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless-regdb: fix gHz to GHz
Date: Thu, 15 Oct 2015 16:19:19 +0200
Message-Id: <1444918759-21559-1-git-send-email-johannes@sipsolutions.net> (sfid-20151015_161927_528139_8B68AD95)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no "g" prefix, only "G" (1e9) that was clearly intended here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 db.txt | 80 +++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/db.txt b/db.txt
index 78a46bd07184..c0a1ec834647 100644
--- a/db.txt
+++ b/db.txt
@@ -22,7 +22,7 @@ country AD:
 	(5170 - 5250 @ 80), (20)
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country AE: DFS-FCC
@@ -82,7 +82,7 @@ country AT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country AU: DFS-ETSI
@@ -108,7 +108,7 @@ country BA: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country BB: DFS-FCC
@@ -126,7 +126,7 @@ country BE: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country BF: DFS-FCC
@@ -141,13 +141,13 @@ country BG: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 5 gHz Short Range Devices, ref:
+	# 5 GHz Short Range Devices, ref:
 	# Etsi EN 300 440-1
 	# Etsi EN 300 440-2
 	# http://crc.bg/files/_bg/Spisak_2015.pdf
 	# http://crc.bg/files/_bg/Pravila_2015_resh24.pdf
 	(5725 - 5875 @ 80), (14)
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country BH: DFS-JP
@@ -234,7 +234,7 @@ country CH: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country CI: DFS-FCC
@@ -255,7 +255,7 @@ country CN: DFS-FCC
 	(5170 - 5250 @ 80), (23), AUTO-BW
 	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
 	(5735 - 5835 @ 80), (30)
-	# 60 gHz band channels 1,4: 28dBm, channels 2,3: 44dBm
+	# 60 GHz band channels 1,4: 28dBm, channels 2,3: 44dBm
 	# ref: http://www.miit.gov.cn/n11293472/n11505629/n11506593/n11960250/n11960606/n11960700/n12330791.files/n12330790.pdf
 	(57240 - 59400 @ 2160), (28)
 	(59400 - 63720 @ 2160), (44)
@@ -287,7 +287,7 @@ country CY: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 # Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
@@ -299,7 +299,7 @@ country CZ: DFS-ETSI
 	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
 	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
 	(5470 - 5725 @ 160), (500 mW), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 # Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from
@@ -323,7 +323,7 @@ country DE: DFS-ETSI
 	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
 	# entries 308002, 309001 and 310003
 	(5470 - 5725 @ 160), (500 mW), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country DK: DFS-ETSI
@@ -331,7 +331,7 @@ country DK: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 # Source:
@@ -366,7 +366,7 @@ country EE: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country EG: DFS-ETSI
@@ -386,7 +386,7 @@ country ES: DFS-ETSI
 	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
 	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
 	(5470 - 5725 @ 160), (500 mW), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country ET: DFS-ETSI
@@ -400,7 +400,7 @@ country FI: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country FM: DFS-FCC
@@ -415,7 +415,7 @@ country FR: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country GB: DFS-ETSI
@@ -423,7 +423,7 @@ country GB: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country GD: DFS-FCC
@@ -437,7 +437,7 @@ country GE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (18), AUTO-BW
 	(5250 - 5330 @ 80), (18), DFS, AUTO-BW
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country GF: DFS-ETSI
@@ -470,7 +470,7 @@ country GR: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country GT: DFS-FCC
@@ -509,7 +509,7 @@ country HR: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country HT: DFS-FCC
@@ -524,7 +524,7 @@ country HU: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country ID: DFS-JP
@@ -537,7 +537,7 @@ country IE: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country IL: DFS-ETSI
@@ -560,7 +560,7 @@ country IS: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country IT: DFS-ETSI
@@ -568,7 +568,7 @@ country IT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country JM: DFS-FCC
@@ -687,7 +687,7 @@ country LT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country LU: DFS-ETSI
@@ -695,7 +695,7 @@ country LU: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country LV: DFS-ETSI
@@ -703,7 +703,7 @@ country LV: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country MA: DFS-ETSI
@@ -751,7 +751,7 @@ country MK: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country MN: DFS-FCC
@@ -794,7 +794,7 @@ country MT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country MU: DFS-FCC
@@ -849,7 +849,7 @@ country NL: DFS-ETSI
 	(5170 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
 	(5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 # Data from http://www.lovdata.no/dokument/SF/forskrift/2012-01-19-77
@@ -864,7 +864,7 @@ country NO: DFS-ETSI
 	(5470 - 5795 @ 160), (500 mW), DFS
 	(5815 - 5850 @ 35), (2000 mW), DFS
 	(17100 - 17300 @ 200), (100 mW)
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country NP: DFS-JP
@@ -928,7 +928,7 @@ country PL: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country PM: DFS-ETSI
@@ -949,7 +949,7 @@ country PT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country PW: DFS-FCC
@@ -981,7 +981,7 @@ country RO: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 
@@ -991,7 +991,7 @@ country RS: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
 	(5150 - 5350 @ 40), (200 mW), NO-OUTDOOR
 	(5470 - 5725 @ 20), (1000 mW), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country RU: DFS-ETSI
@@ -1021,7 +1021,7 @@ country SE: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country SG: DFS-FCC
@@ -1036,7 +1036,7 @@ country SI: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country SK: DFS-ETSI
@@ -1044,7 +1044,7 @@ country SK: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 # Source:
@@ -1109,7 +1109,7 @@ country TR: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country TT: DFS-FCC
@@ -1151,7 +1151,7 @@ country UA: DFS-ETSI
 	(5250 - 5350 @ 80), (20), DFS, NO-OUTDOOR, AUTO-BW
 	(5490 - 5670 @ 160), (20), DFS
 	(5735 - 5835 @ 80), (20)
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
 country UG: DFS-FCC
-- 
2.5.1

