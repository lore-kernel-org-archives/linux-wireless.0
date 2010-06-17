Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34099 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab0FQJsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 05:48:13 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 02:48:13 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wireless-regdb: Enable 40MHz operation for some countries.
Date: Thu, 17 Jun 2010 15:17:54 +0530
Message-ID: <1276768074-4366-3-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1276768074-4366-2-git-send-email-vnatarajan@atheros.com>
References: <1276768074-4366-1-git-send-email-vnatarajan@atheros.com>
 <1276768074-4366-2-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable 40MHz operation for Argentina, Brazil, Colombia, Algeria,
India, Malaysia, Peru and South Africa.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 db.txt |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/db.txt b/db.txt
index e405d78..74ae9e3 100644
--- a/db.txt
+++ b/db.txt
@@ -33,7 +33,7 @@ country AN:
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
 country AR:
-	(2402 - 2482 @ 20), (N/A, 20)
+	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (3, 17)
 	(5250 - 5330 @ 40), (3, 20), DFS
 	(5490 - 5710 @ 40), (3, 20), DFS
@@ -111,11 +111,11 @@ country BO:
 	(5735 - 5835 @ 40), (N/A, 30)
 
 country BR:
-	(2402 - 2482 @ 20), (N/A, 20)
-	(5170 - 5250 @ 20), (3, 17)
-	(5250 - 5330 @ 20), (3, 20), DFS
-	(5490 - 5710 @ 20), (3, 20), DFS
-	(5735 - 5835 @ 20), (3, 30)
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country BY:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -152,9 +152,9 @@ country CN:
 
 country CO:
 	(2402 - 2472 @ 40), (3, 27)
-	(5170 - 5250 @ 20), (3, 17)
-	(5250 - 5330 @ 20), (3, 23), DFS
-	(5735 - 5835 @ 20), (3, 30)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 23), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country CR:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -207,7 +207,7 @@ country DO:
 	(5735 - 5835 @ 40), (3, 30)
 
 country DZ:
-	(2402 - 2482 @ 20), (N/A, 20)
+	(2402 - 2482 @ 40), (N/A, 20)
 
 country EC:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -332,9 +332,9 @@ country IL:
 
 country IN:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 20), (N/A, 20)
-	(5250 - 5330 @ 20), (N/A, 20), DFS
-	(5735 - 5835 @ 20), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5735 - 5835 @ 40), (N/A, 20)
 
 country IS:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -471,9 +471,9 @@ country MT:
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
 country MY:
-	(2402 - 2482 @ 20), (N/A, 20)
-	(5250 - 5330 @ 20), (N/A, 30), DFS
-	(5735 - 5835 @ 20), (N/A, 30)
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 30), DFS
+	(5735 - 5835 @ 40), (N/A, 30)
 
 country MX:
 	(2402 - 2472 @ 40), (3, 27)
@@ -518,7 +518,7 @@ country PA:
 
 country PE:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5735 - 5835 @ 20), (N/A, 30)
+	(5735 - 5835 @ 40), (N/A, 30)
 
 country PG:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -673,10 +673,10 @@ country YE:
 
 country ZA:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 20), (3, 17)
-	(5250 - 5330 @ 20), (3, 20), DFS
-	(5490 - 5710 @ 20), (3, 20), DFS
-	(5735 - 5835 @ 20), (3, 30)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country ZW:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.6.3.3

