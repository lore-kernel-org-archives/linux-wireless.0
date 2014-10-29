Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24731 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbaJ2VWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 17:22:05 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/7] wireless-regdb: Add 160 MHz channel bandwidth for Dominica (DM)
Date: Wed, 29 Oct 2014 23:21:26 +0200
Message-ID: <1414617690-29786-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20141029_222209_191999_70243A3D)
In-Reply-To: <1414617690-29786-1-git-send-email-jouni@qca.qualcomm.com>
References: <1414617690-29786-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends regulatory rules for Dominica to allow 160 MHz
VHT channels to be used in 5.15-5.25 GHz, 5.25-5.35 GHz. Since the rules
between 5.15-5.25 and 5.25-5.35 GHz ranges are different (e.g., DFS
requirement), the AUTO-BW flag needs to be used to allow the maximum
channel bandwidth to be determined automatically based on two rules.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 999bc5f..d527b54 100644
--- a/db.txt
+++ b/db.txt
@@ -331,8 +331,8 @@ country DK: DFS-ETSI
 # http://www.ntrcdom.org/index.php?option=com_content&view=category&layout=blog&id=10&Itemid=55
 country DM: DFS-FCC
 	(2402 - 2472 @ 40), (30)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (23), DFS
+	(5170 - 5250 @ 80), (17), AUTO-BW
+	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
 	(5735 - 5835 @ 80), (30)
 
 country DO: DFS-FCC
-- 
1.9.1

