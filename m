Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAQJvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 04:51:54 -0500
Message-ID: <1389952310.6858.1.camel@jlt4.sipsolutions.net> (sfid-20140117_105158_973569_BADBD8D6)
Subject: [PATCH] regdb: Republic of Korea: fix double rule
From: Johannes Berg <johannes@sipsolutions.net>
To: wireless-regdb <wireless-regdb@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 17 Jan 2014 10:51:50 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to have a 20 MHz and a 40 MHz rule that are
other wise completely the same, remove the 20 MHz one.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 db.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/db.txt b/db.txt
index fcab208..bf99234 100644
--- a/db.txt
+++ b/db.txt
@@ -467,7 +467,6 @@ country KP: DFS-JP
 	(5735 - 5815 @ 80), (30)
 
 country KR: DFS-JP
-	(2402 - 2482 @ 20), (20)
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20)
 	(5250 - 5330 @ 80), (20), DFS
-- 
1.8.5.1



