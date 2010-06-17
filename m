Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34097 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab0FQJsH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 05:48:07 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 02:48:07 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wireless-regdb: Update the regulatory domain for a few countries.
Date: Thu, 17 Jun 2010 15:17:53 +0530
Message-ID: <1276768074-4366-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1276768074-4366-1-git-send-email-vnatarajan@atheros.com>
References: <1276768074-4366-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Bangladesh(BD) with NULL1_WORLD.
Add Kenya(KE) with APL1_WORLD.
Change Honduras(HN) to FCC3_WORLD.
Change Lebanon(LB) to  APL1_WORLD,
Change Macedonia(MK) to ETSI1_WORLD.
Change Pakistan(PK) to APL1_WORLD.
Change Romania(RO) to ETSI1_WORLD.
Change Russia(RU) to FCC3_WORLD.
Change Saudi Arabia(SA) to FCC2_WORLD.
Change UAE(AE) to ETSI1_WORLD.
Change Venezuela(VE) to FCC1_WORLD.
Change Vietnam(VN) to ETSI3_WORLD.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 db.txt |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index e63a43e..e405d78 100644
--- a/db.txt
+++ b/db.txt
@@ -14,6 +14,9 @@ country 00:
 
 country AE:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5490 - 5710 @ 40), (N/A, 27), DFS
 
 country AL:
 	(2402 - 2482 @ 20), (N/A, 20)
@@ -71,6 +74,9 @@ country BB:
 	(5250 - 5330 @ 40), (3, 23), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
+country BD:
+	(2402 - 2482 @ 40), (N/A, 20)
+
 country BE:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
@@ -282,6 +288,10 @@ country GU:
 
 country HN:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country HK:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -367,6 +377,10 @@ country JO:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 18)
 
+country KE:
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5735 - 5835 @ 40), (N/A, 30)
+
 country KH:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
@@ -397,6 +411,7 @@ country KZ:
 
 country LB:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5735 - 5835 @ 40), (N/A, 30)
 
 country LI:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -445,6 +460,9 @@ country MO:
 
 country MK:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5490 - 5710 @ 40), (N/A, 27), DFS
 
 country MT:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -514,6 +532,7 @@ country PH:
 
 country PK:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5735 - 5835 @ 40), (N/A, 30)
 
 country PL:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -539,12 +558,19 @@ country QA:
 
 country RO:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5490 - 5710 @ 40), (N/A, 27), DFS
 
 country RU:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5735 - 5835 @ 20), (N/A, 30)
 
 country SA:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 20), (3, 23)
+	(5250 - 5330 @ 20), (3, 23), DFS
+	(5735 - 5835 @ 20), (3, 30)
 
 country SE:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -634,11 +660,13 @@ country UZ:
 	(5735 - 5835 @ 40), (3, 30)
 
 country VE:
-	(2402 - 2482 @ 40), (N/A, 30)
-	(5735 - 5815 @ 20), (N/A, 23)
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5735 - 5815 @ 40), (N/A, 23)
 
 country VN:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
 
 country YE:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.6.3.3

