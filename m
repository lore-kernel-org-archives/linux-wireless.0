Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19632 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaKMJTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 04:19:16 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Reorder country codes to be in alphabetical order
Date: Thu, 13 Nov 2014 11:18:38 +0200
Message-ID: <1415870318-8505-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20141113_101937_724712_BDAF529C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to write (semi-)automated synchronization and
validation scripts against external databases. I'd assume this order was
already supposed to be used, but couple of the countries have been
placed in incorrect locations in the file over the years.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 134 ++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff --git a/db.txt b/db.txt
index 6cf86e1..df7f7b1 100644
--- a/db.txt
+++ b/db.txt
@@ -411,19 +411,6 @@ country FR: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-country GE: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (18), AUTO-BW
-	(5250 - 5330 @ 80), (18), DFS, AUTO-BW
-	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57000 - 66000 @ 2160), (40)
-
-country GF: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
-
 country GB: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
@@ -439,6 +426,19 @@ country GD: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country GE: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (18), AUTO-BW
+	(5250 - 5330 @ 80), (18), DFS, AUTO-BW
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57000 - 66000 @ 2160), (40)
+
+country GF: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20), AUTO-BW
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
+	(5490 - 5710 @ 160), (27), DFS
+
 country GH: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17), AUTO-BW
@@ -446,6 +446,12 @@ country GH: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country GL: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
 country GP: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
@@ -460,12 +466,6 @@ country GR: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-country GL: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20)
-	(5250 - 5330 @ 80), (20), DFS
-	(5490 - 5710 @ 80), (27), DFS
-
 country GT: DFS-FCC
 	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (17), AUTO-BW
@@ -483,18 +483,18 @@ country GY:
 	(2402 - 2482 @ 40), (30)
 	(5735 - 5835 @ 80), (30)
 
-country HN: DFS-FCC
+country HK:
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17), AUTO-BW
 	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5730 @ 160), (24), DFS
+	(5490 - 5710 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country HK:
+country HN: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17), AUTO-BW
 	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (24), DFS
+	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
 country HR: DFS-ETSI
@@ -544,6 +544,10 @@ country IN: DFS-JP
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5735 - 5835 @ 80), (20)
 
+country IR: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5735 - 5835 @ 80), (30)
+
 country IS: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
@@ -552,10 +556,6 @@ country IS: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-country IR: DFS-JP
-	(2402 - 2482 @ 40), (20)
-	(5735 - 5835 @ 80), (30)
-
 country IT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
@@ -571,6 +571,11 @@ country JM: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country JO: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (23)
+	(5735 - 5835 @ 80), (23)
+
 country JP: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(2474 - 2494 @ 20), (20), NO-OFDM
@@ -580,11 +585,6 @@ country JP: DFS-JP
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (23), DFS
 
-country JO: DFS-JP
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (23)
-	(5735 - 5835 @ 80), (23)
-
 country KE: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (23)
@@ -696,16 +696,16 @@ country LV: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-country MC: DFS-ETSI
+country MA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
 
-country MA: DFS-ETSI
+country MC: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
+	(5490 - 5710 @ 160), (27), DFS
 
 # Source:
 # http://www.cnfr.md/index.php?pag=sec&id=117&l=en
@@ -729,12 +729,6 @@ country MF: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
 
-country MO:
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (23)
-	(5250 - 5330 @ 40), (23), DFS
-	(5735 - 5835 @ 40), (30)
-
 country MH: DFS-FCC
 	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (24), AUTO-BW
@@ -757,6 +751,12 @@ country MN: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country MO:
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 40), (23)
+	(5250 - 5330 @ 40), (23), DFS
+	(5735 - 5835 @ 40), (30)
+
 country MP: DFS-FCC
 	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (24), AUTO-BW
@@ -799,17 +799,17 @@ country MW: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
 
-country MY: DFS-FCC
+country MX: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
+	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
+	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country MX: DFS-FCC
+country MY: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5730 @ 160), (24), DFS
+	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
 	(5735 - 5835 @ 80), (30)
 
 country NI: DFS-FCC
@@ -912,6 +912,13 @@ country PM: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
 
+country PR: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17), AUTO-BW
+	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
+	(5490 - 5730 @ 160), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
 country PT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
@@ -920,13 +927,6 @@ country PT: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-country PR: DFS-FCC
-	(2402 - 2472 @ 40), (30)
-	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5730 @ 160), (24), DFS
-	(5735 - 5835 @ 80), (30)
-
 country PW: DFS-FCC
 	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (24), AUTO-BW
@@ -1065,13 +1065,6 @@ country TG: DFS-ETSI
 	(5250 - 5330 @ 40), (20), DFS
 	(5490 - 5710 @ 40), (27), DFS
 
-country TW: DFS-JP
-	(2402 - 2472 @ 40), (30)
-	(5270 - 5330 @ 40), (17), DFS
-	(5490 - 5590 @ 80), (30), DFS
-	(5650 - 5710 @ 40), (30), DFS
-	(5735 - 5835 @ 80), (30)
-
 country TH: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17), AUTO-BW
@@ -1079,13 +1072,6 @@ country TH: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country TT: DFS-FCC
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5730 @ 160), (24), DFS
-	(5735 - 5835 @ 80), (30)
-
 country TN: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
@@ -1098,6 +1084,20 @@ country TR: DFS-ETSI
 	(5490 - 5710 @ 160), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
+
+country TT: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17), AUTO-BW
+	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
+	(5490 - 5730 @ 160), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country TW: DFS-JP
+	(2402 - 2472 @ 40), (30)
+	(5270 - 5330 @ 40), (17), DFS
+	(5490 - 5590 @ 80), (30), DFS
+	(5650 - 5710 @ 40), (30), DFS
+	(5735 - 5835 @ 80), (30)
  
 # Source:
 # #914 / 06 Sep 2007: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
-- 
1.9.1

