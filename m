Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20361 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZKKJxV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 04:53:21 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 01:53:28 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: [PATCH] wireless-regdb: Add new country codes.
Date: Wed, 11 Nov 2009 15:23:21 +0530
Message-ID: <1257933202-2659-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few new countries and their regulatory domains are added as follows,
Added Barbados(BB) with FCC2_World and 5 GHz HT40 mode enabled.
Added Cambodia(KH) with ETSI1_World and 5 GHz HT40 mode enabled.
Added Greenlad(GL) with ETSI1_World and 5 GHz HT40 mode disabled.
Added Greneda(GD) with FCC3_FCCA and 5 GHz HT40 mode enabled.
Added Guam(GU) with FCC1_FCCA and 5 GHz HT40 mode disabled.
Added Haiti(HT) with ETSI1_World and 5 GHz HT40 mode enabled.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 db.txt |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/db.txt b/db.txt
index a3cd6be..a99b3b7 100644
--- a/db.txt
+++ b/db.txt
@@ -63,6 +63,12 @@ country BA:
 	(5250 - 5330 @ 20), (N/A, 20), DFS
 	(5490 - 5710 @ 20), (N/A, 27), DFS
 
+country BB:
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (3, 23)
+	(5250 - 5330 @ 40), (3, 23), DFS
+	(5735 - 5835 @ 40), (3, 30)
+
 country BE:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
@@ -241,18 +247,37 @@ country GB:
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
+country GD:
+	(2402 - 2472 @ 40), (3, 27)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
+
 country GR:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
+country GL:
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 20), (N/A, 20)
+	(5250 - 5330 @ 20), (N/A, 20), DFS
+	(5490 - 5710 @ 20), (N/A, 27), DFS
+
 country GT:
 	(2402 - 2472 @ 40), (3, 27)
 	(5170 - 5250 @ 40), (3, 17)
 	(5250 - 5330 @ 40), (3, 23), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
+country GU:
+	(2402 - 2472 @ 40), (3, 27)
+	(5170 - 5250 @ 20), (3, 17)
+	(5250 - 5330 @ 20), (3, 23), DFS
+	(5735 - 5835 @ 20), (3, 30)
+
 country HN:
 	(2402 - 2482 @ 40), (N/A, 20)
 
@@ -267,6 +292,12 @@ country HR:
 	(5170 - 5250 @ 20), (N/A, 20)
 	(5250 - 5330 @ 20), (N/A, 20), DFS
 
+country HT:
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5490 - 5710 @ 40), (N/A, 27), DFS
+
 country HU:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
@@ -332,6 +363,12 @@ country JO:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 20), (N/A, 18)
 
+country KH:
+	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (N/A, 20)
+	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5490 - 5710 @ 40), (N/A, 27), DFS
+
 country KP:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5330 @ 40), (3, 20)
-- 
1.6.0.4

