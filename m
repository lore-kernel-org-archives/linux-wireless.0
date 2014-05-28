Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4435 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaE1JO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 05:14:59 -0400
Date: Wed, 28 May 2014 12:14:53 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 6/9] wireless-regdb: Add Togo (TG) regulatory rules
Message-ID: <20140528091453.GA14675@jouni.qca.qualcomm.com> (sfid-20140528_111502_133732_5F0921CF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts and correspondence with
Telecom agency (ARTP).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db.txt b/db.txt
index 6621681..887902e 100644
--- a/db.txt
+++ b/db.txt
@@ -785,6 +785,12 @@ country SV: DFS-FCC
 country SY:
 	(2402 - 2482 @ 40), (20)
 
+country TG: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 40), (20)
+	(5250 - 5330 @ 40), (20), DFS
+	(5490 - 5710 @ 40), (27), DFS
+
 country TW: DFS-JP
 	(2402 - 2472 @ 40), (30)
 	(5270 - 5330 @ 40), (17), DFS
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
