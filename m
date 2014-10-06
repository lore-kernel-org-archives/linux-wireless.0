Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14503 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaJFOTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 10:19:55 -0400
Date: Mon, 6 Oct 2014 17:19:39 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Update Bolivia (BO) regulatory rules
Message-ID: <20141006141939.GA14053@jouni.qca.qualcomm.com> (sfid-20141006_161958_254392_A28224FC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://www.att.gob.bo/
National Frequency table 2012 PNF 8_11_12

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 5bd9388..a08f19c 100644
--- a/db.txt
+++ b/db.txt
@@ -151,7 +151,8 @@ country BN: DFS-JP
 	(5735 - 5835 @ 80), (20)
 
 country BO: DFS-JP
-	(2402 - 2482 @ 40), (30)
+	(2402 - 2482 @ 40), (20)
+	(5250 - 5330 @ 80), (30), DFS
 	(5735 - 5835 @ 80), (30)
 
 country BR: DFS-FCC
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
