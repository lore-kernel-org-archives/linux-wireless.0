Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12604 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaICNPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:15:42 -0400
Date: Wed, 3 Sep 2014 16:15:18 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 09/12] wireless-regdb: Add Saint Lucia (LC) regulatory rules
Message-ID: <20140903131518.GA16219@jouni.qca.qualcomm.com> (sfid-20140903_151545_087407_3E924FCA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source:
http://www.ntrc.org.lc/operational_structures.htm

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/db.txt b/db.txt
index 77b1773..2d0988a 100644
--- a/db.txt
+++ b/db.txt
@@ -576,6 +576,15 @@ country LB: DFS-FCC
 	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+# Source:
+# http://www.ntrc.org.lc/operational_structures.htm
+country LC: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (30), DFS
+	(5735 - 5815 @ 80), (30)
+
 country LI: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
