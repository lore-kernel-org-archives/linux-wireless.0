Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20503 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbbJETMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 15:12:47 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/5] wireless-regdb: Add 160 MHz channel bandwidth for Greenland (GL)
Date: Mon, 5 Oct 2015 22:11:57 +0300
Message-ID: <1444072321-20728-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20151005_211250_301891_D67F6442)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends regulatory rules for Greenland to allow 160 MHz VHT
channels. This was missed in the earlier set of patches that added 160
MHz for large number of countries.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index d57ea84..226057e 100644
--- a/db.txt
+++ b/db.txt
@@ -455,9 +455,9 @@ country GH: DFS-FCC
 
 country GL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20)
-	(5250 - 5330 @ 80), (20), DFS
-	(5490 - 5710 @ 80), (27), DFS
+	(5170 - 5250 @ 80), (20), AUTO-BW
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
+	(5490 - 5710 @ 160), (27), DFS
 
 country GP: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.9.1

