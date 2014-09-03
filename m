Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:28048 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291AbaICNPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:15:05 -0400
Date: Wed, 3 Sep 2014 16:14:58 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 08/12] wireless-regdb: Add Saint Kitts and Nevis (KN)
 regulatory rules
Message-ID: <20140903131458.GA16201@jouni.qca.qualcomm.com> (sfid-20140903_151509_243924_366A8029)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source:
http://ntrc.kn/?page_id=7

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/db.txt b/db.txt
index 7e34611..77b1773 100644
--- a/db.txt
+++ b/db.txt
@@ -538,6 +538,15 @@ country KH: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 
+# Source
+# http://ntrc.kn/?page_id=7
+country KN: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (30), DFS
+	(5735 - 5815 @ 80), (30)
+
 country KP: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
