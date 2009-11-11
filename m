Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20362 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbZKKJx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 04:53:27 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 01:53:33 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: [PATCH] wireless-regdb: Update the regulatory domain for a few countries.
Date: Wed, 11 Nov 2009 15:23:22 +0530
Message-ID: <1257933202-2659-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1257933202-2659-1-git-send-email-vnatarajan@atheros.com>
References: <1257933202-2659-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify the regulatory domain for the following countries,
Change Argentina(AR) to FCC3_World,
Change Croatia(HR) to ETSI1_World,
Change Hong Kong(HK) to FCC3_World,
Change Indonesia(ID) to NULL1_World,
Change Jamaica(JM) to FCC3_World,
Change Kuwait(KW) to ETSI3_World,
Change Oman(OM) to FCC3_World,
Change Qatar(QA) to APL1_World,
Change Trinidad and Tobago(TT) to FCC3_World,
Change Uruguay(UY) to FCC3_World.

And also enable HT40 mode in 5 GHz for AR, BA, HR, JO, OM, TT, UY
which was disabled earlier.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 db.txt |   53 +++++++++++++++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/db.txt b/db.txt
index a99b3b7..e63a43e 100644
--- a/db.txt
+++ b/db.txt
@@ -31,8 +31,10 @@ country AN:
 
 country AR:
 	(2402 - 2482 @ 20), (N/A, 20)
-	(5270 - 5330 @ 20), (3, 17), DFS
-	(5735 - 5815 @ 20), (3, 30)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country AT:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -59,9 +61,9 @@ country AZ:
 
 country BA:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 20), (N/A, 20)
-	(5250 - 5330 @ 20), (N/A, 20), DFS
-	(5490 - 5710 @ 20), (N/A, 27), DFS
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5490 - 5710 @ 40), (N/A, 27), DFS
 
 country BB:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -283,14 +285,16 @@ country HN:
 
 country HK:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (3, 23)
-	(5250 - 5330 @ 40), (3, 23), DFS
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
 country HR:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 20), (N/A, 20)
-	(5250 - 5330 @ 20), (N/A, 20), DFS
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5490 - 5710 @ 40), (N/A, 27), DFS
 
 country HT:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -306,7 +310,6 @@ country HU:
 
 country ID:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5735 - 5835 @ 20), (N/A, 30)
 
 country IE:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -341,9 +344,10 @@ country IT:
 
 country JM:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
-	(5490 - 5710 @ 40), (N/A, 27), DFS
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country JP:
 	(2402 - 2472 @ 40), (N/A, 20)
@@ -361,7 +365,7 @@ country JP:
 
 country JO:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 20), (N/A, 18)
+	(5170 - 5250 @ 40), (N/A, 18)
 
 country KH:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -385,6 +389,8 @@ country KR:
 
 country KW:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
 
 country KZ:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -481,9 +487,10 @@ country NZ:
 
 country OM:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 20), (N/A, 20)
-	(5250 - 5330 @ 20), (N/A, 20), DFS
-	(5735 - 5835 @ 20), (N/A, 20)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country PA:
 	(2402 - 2472 @ 40), (3, 27)
@@ -528,6 +535,7 @@ country PR:
 
 country QA:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5735 - 5835 @ 40), (N/A, 30)
 
 country RO:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -585,8 +593,10 @@ country TH:
 
 country TT:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 20), (N/A, 18)
-	(5250 - 5330 @ 20), (N/A, 18), DFS
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country TN:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -611,7 +621,10 @@ country US:
 
 country UY:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5735 - 5815 @ 20), (N/A, 23)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country UZ:
 	(2402 - 2472 @ 40), (3, 27)
-- 
1.6.0.4

