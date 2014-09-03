Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24881 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbaICNKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:10:46 -0400
Date: Wed, 3 Sep 2014 16:10:39 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 03/12] wireless-regdb: Add Lesotho (LS) regulatory rules
Message-ID: <20140903131039.GA15922@jouni.qca.qualcomm.com> (sfid-20140903_151049_274864_63A81914)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source:
http://lca.org.ls/images/documents/lesotho_national_frequency_allocation_plan.pdf

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/db.txt b/db.txt
index 1327e60..90ed48b 100644
--- a/db.txt
+++ b/db.txt
@@ -579,6 +579,14 @@ country LK: DFS-FCC
 	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+# Source:
+# http://lca.org.ls/images/documents/lesotho_national_frequency_allocation_plan.pdf
+country LS: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
 country LT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
