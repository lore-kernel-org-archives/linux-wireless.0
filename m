Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58629 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaE1JQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 05:16:13 -0400
Date: Wed, 28 May 2014 12:16:07 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 8/9] wireless-regdb: Add Guyana (GY) regulatory rules
Message-ID: <20140528091607.GA14718@jouni.qca.qualcomm.com> (sfid-20140528_111616_418137_7C2BA9DC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts and email confirmation from
ministry that spectrum rules are based upon FCC 15.247 for bands
2400-2483.5 MHz and 5725-5850 MHz. NFMU.Gov.GY

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/db.txt b/db.txt
index b06fb2b..9864027 100644
--- a/db.txt
+++ b/db.txt
@@ -366,6 +366,10 @@ country GU: DFS-FCC
 	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country GY:
+	(2402 - 2482 @ 40), (30)
+	(5735 - 5835 @ 80), (30)
+
 country HN: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
