Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51172 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385Ab3BLTpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 14:45:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless-regdb Clean-up some whitespace damage that had crept into db.txt...
Date: Tue, 12 Feb 2013 14:40:05 -0500
Message-Id: <1360698005-18798-1-git-send-email-linville@tuxdriver.com> (sfid-20130212_204540_130393_F65FD1A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 db.txt | 158 ++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 79 insertions(+), 79 deletions(-)

diff --git a/db.txt b/db.txt
index 0270c2f..c5861b8 100644
--- a/db.txt
+++ b/db.txt
@@ -1,20 +1,20 @@
 # This is the world regulatory domain
 country 00:
 	(2402 - 2472 @ 40), (3, 20)
-        # Channel 12 - 13.
-        (2457 - 2482 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
-        # Channel 14. Only JP enables this and for 802.11b only
-        (2474 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS, NO-OFDM
-        # Channel 36 - 48
-        (5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
-        # NB: 5260 MHz - 5700 MHz requies DFS
-        # Channel 149 - 165
-        (5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+	# Channel 12 - 13.
+	(2457 - 2482 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+	# Channel 14. Only JP enables this and for 802.11b only
+	(2474 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS, NO-OFDM
+	# Channel 36 - 48
+	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+	# NB: 5260 MHz - 5700 MHz requies DFS
+	# Channel 149 - 165
+	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
 
 
 country AD:
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country AE:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -48,8 +48,8 @@ country AT: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country AU:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -73,8 +73,8 @@ country BA: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country BB:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -90,16 +90,16 @@ country BE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country BG: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 23)
 	(5250 - 5290 @ 40), (N/A, 23), DFS
 	(5490 - 5710 @ 40), (N/A, 30), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country BH:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -151,8 +151,8 @@ country CH: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country CL:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -192,8 +192,8 @@ country CY: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 # Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
 # and http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
@@ -204,8 +204,8 @@ country CZ: DFS-ETSI
 	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 # Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from
 # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
@@ -228,16 +228,16 @@ country DE: DFS-ETSI
 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
 	# entries 308002, 309001 and 310003
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country DK: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country DO:
 	(2402 - 2472 @ 40), (3, 27)
@@ -259,8 +259,8 @@ country EE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country EG:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -272,39 +272,39 @@ country ES: DFS-ETSI
 	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country FI: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country FR: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country GE:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 18)
 	(5250 - 5330 @ 40), (N/A, 18), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country GB: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country GD:
 	(2402 - 2472 @ 40), (3, 27)
@@ -318,8 +318,8 @@ country GR: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country GL: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -358,8 +358,8 @@ country HR: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country HT:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -372,8 +372,8 @@ country HU: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country ID:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -383,8 +383,8 @@ country IE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country IL:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -402,8 +402,8 @@ country IS: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country IR:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -414,8 +414,8 @@ country IT: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country JM:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -491,24 +491,24 @@ country LT: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country LU: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country LV: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country MC: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -529,16 +529,16 @@ country MK: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country MT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country MY:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -556,16 +556,16 @@ country NL: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20), NO-OUTDOOR
 	(5250 - 5330 @ 40), (N/A, 20), NO-OUTDOOR, DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country NO: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country NP:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -613,16 +613,16 @@ country PL: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country PT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country PR:
 	(2402 - 2472 @ 40), (3, 27)
@@ -639,8 +639,8 @@ country RO: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 
 # Source:
@@ -671,8 +671,8 @@ country SE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country SG:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -685,16 +685,16 @@ country SI: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country SK: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country SV:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.11.7

