Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29828 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbaE1JKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 05:10:13 -0400
Date: Wed, 28 May 2014 12:09:26 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/9] wireless-regdb: Add Afghanistan (AF) regulatory rules
Message-ID: <20140528090926.GA14400@jouni.qca.qualcomm.com> (sfid-20140528_111018_806019_B1830503)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts and correspondence with
Telecom agency (TRA)

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db.txt b/db.txt
index be552d0..6435c54 100644
--- a/db.txt
+++ b/db.txt
@@ -28,6 +28,12 @@ country AE: DFS-FCC
 	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country AF: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
 country AL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20.00)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
