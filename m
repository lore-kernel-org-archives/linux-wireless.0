Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24220 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbaJ2VWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 17:22:12 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] wireless-regdb: Add 160 MHz channel bandwidth for Malaysia (MY)
Date: Wed, 29 Oct 2014 23:21:28 +0200
Message-ID: <1414617690-29786-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20141029_222216_836950_88DA3DEA)
In-Reply-To: <1414617690-29786-1-git-send-email-jouni@qca.qualcomm.com>
References: <1414617690-29786-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends regulatory rules for Malaysia to allow 160 MHz VHT channels
to be used in 5.15-5.25 GHz, 5.25-5.35 GHz. Since the rules between
5.15-5.25 and 5.25-5.35 GHz ranges are different (e.g., DFS
requirement), the AUTO-BW flag needs to be used to allow the maximum
channel bandwidth to be determined automatically based on two rules.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 10aaf44..0df4644 100644
--- a/db.txt
+++ b/db.txt
@@ -801,8 +801,8 @@ country MW: DFS-ETSI
 
 country MY: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (23), DFS
+	(5170 - 5250 @ 80), (17), AUTO-BW
+	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
 	(5735 - 5835 @ 80), (30)
 
 country MX: DFS-FCC
-- 
1.9.1

