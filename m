Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7111 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbaE2Qcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 12:32:48 -0400
Date: Thu, 29 May 2014 19:32:35 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/8] wireless-regdb: Add Central African Republic (CF)
 regulatory rules
Message-ID: <20140529163235.GA27947@jouni.qca.qualcomm.com> (sfid-20140529_183251_535296_AEF295CD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts and
http://www.art-rca.org.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/db.txt b/db.txt
index c957b1d..063cd44 100644
--- a/db.txt
+++ b/db.txt
@@ -177,6 +177,15 @@ country CA: DFS-FCC
 	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+# Source:
+# http://www.art-rca.org
+country CF: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 40), (17)
+	(5250 - 5330 @ 40), (24), DFS
+	(5490 - 5730 @ 40), (24), DFS
+	(5735 - 5835 @ 40), (30)
+
 country CH: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
