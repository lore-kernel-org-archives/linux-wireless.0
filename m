Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:44498 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333AbaICNOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:14:37 -0400
Date: Wed, 3 Sep 2014 16:14:29 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 07/12] wireless-regdb: Add Saint Pierre and Miquelon (PM)
 regulatory rules
Message-ID: <20140903131429.GA16183@jouni.qca.qualcomm.com> (sfid-20140903_151440_131677_97528F78)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

French Jurisdiction, follows ETSI rules per R&TTE Directive.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db.txt b/db.txt
index 7f842f3..7e34611 100644
--- a/db.txt
+++ b/db.txt
@@ -769,6 +769,12 @@ country PL: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
+country PM: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
 country PT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
