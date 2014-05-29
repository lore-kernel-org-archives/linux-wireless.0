Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7179 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822AbaE2QdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 12:33:14 -0400
Date: Thu, 29 May 2014 19:33:08 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 4/8] wireless-regdb: Add Micronesia (FM) and Palau (PW)
 regulatory rules
Message-ID: <20140529163308.GA27966@jouni.qca.qualcomm.com> (sfid-20140529_183333_445846_FA0AAA45)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FCC has jurisdiction over public use of radio spectrum in all U.S.
territories.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/db.txt b/db.txt
index 063cd44..f85a622 100644
--- a/db.txt
+++ b/db.txt
@@ -325,6 +325,13 @@ country FI: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
+country FM: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (24)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
 country FR: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20)
@@ -730,6 +737,13 @@ country PR: DFS-FCC
 	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country PW: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (24)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
 country QA: DFS-JP
 	(2402 - 2482 @ 40), (20)
 	(5735 - 5835 @ 80), (30)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
