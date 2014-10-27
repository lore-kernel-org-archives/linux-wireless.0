Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:60389 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaJ0M1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 08:27:14 -0400
Date: Mon, 27 Oct 2014 14:26:50 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Add 5490-5710 MHz to Bulgaria (BG)
Message-ID: <20141027122650.GA12859@jouni.qca.qualcomm.com> (sfid-20141027_132718_132297_1DD048D8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/db.txt b/db.txt
index 1df0b4c..43afa5c 100644
--- a/db.txt
+++ b/db.txt
@@ -133,6 +133,7 @@ country BG: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
+	(5490 - 5710 @ 160), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
