Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:23549 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaE1JRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 05:17:04 -0400
Date: Wed, 28 May 2014 12:16:58 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 9/9] wireless-regdb: Update Venezuela (VE) regulatory rules
Message-ID: <20140528091658.GA14748@jouni.qca.qualcomm.com> (sfid-20140528_111708_729279_F6A0706D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source:
Official Gazette (Gaceta Oficial) concerning Unlicensed transmitter use
(10 June 2013)
http://www.conatel.gob.ve/

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 9864027..2854eec 100644
--- a/db.txt
+++ b/db.txt
@@ -874,9 +874,13 @@ country UZ: DFS-ETSI
 	(5170 - 5250 @ 80), (20)
 	(5250 - 5330 @ 80), (20), DFS
 
+# Source:
+# Official Gazette (Gaceta Oficial) concerning Unlicensed transmitter use
+# (10 June 2013)
+# http://www.conatel.gob.ve/
 country VE: DFS-FCC
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17)
+	(2402 - 2482 @ 40), (30)
+	(5170 - 5250 @ 80), (23)
 	(5250 - 5330 @ 80), (23), DFS
 	(5735 - 5835 @ 80), (30)
 
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
