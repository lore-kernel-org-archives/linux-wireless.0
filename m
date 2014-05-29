Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15988 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675AbaE2QhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 12:37:11 -0400
Date: Thu, 29 May 2014 19:37:06 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 8/8] wireless-regdb: Update Haiti (HT) regulatory rules
Message-ID: <20140529163706.GA28051@jouni.qca.qualcomm.com> (sfid-20140529_183716_393142_88005047)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts and email confirmation from
ministry. 2.4 & 5 GHz limits and RF channels used in Haiti are same as
FCC. Conseil National des Telecommunications

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 769826c..31e8394 100644
--- a/db.txt
+++ b/db.txt
@@ -429,11 +429,12 @@ country HR: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-country HT: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20)
-	(5250 - 5330 @ 80), (20), DFS
-	(5490 - 5710 @ 80), (27), DFS
+country HT: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (24)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country HU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
