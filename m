Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:27122 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaICNZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:25:07 -0400
Date: Wed, 3 Sep 2014 16:25:01 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	<wireless-regdb@lists.infradead.org>
Subject: [PATCH v2 05/12] wireless-regdb: Update Saint Barthelemy (BL)
 regulatory rules
Message-ID: <20140903132501.GA15621@jouni.qca.qualcomm.com> (sfid-20140903_152511_662924_8A28D45F)
References: <20140903131329.GA16147@jouni.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20140903131329.GA16147@jouni.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

French Jurisdiction, follows ETSI rules per R&TTE Directive.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

v2: Looks like something did not exactly like the non-ASCII character in
the subject, so lets try with ASCII-only..


diff --git a/db.txt b/db.txt
index c1c70cc..980b193 100644
--- a/db.txt
+++ b/db.txt
@@ -138,10 +138,11 @@ country BH: DFS-JP
 	(5250 - 5330 @ 80), (20), DFS
 	(5735 - 5835 @ 80), (20)
 
-country BL:
+country BL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (18)
-	(5250 - 5330 @ 40), (18), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country BN: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
