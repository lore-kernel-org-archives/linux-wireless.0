Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19680 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994AbaJ2V0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 17:26:08 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] wireless-regdb: Add 160 MHz channel bandwidth for Venezuela (VE)
Date: Wed, 29 Oct 2014 23:25:44 +0200
Message-ID: <1414617944-29966-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20141029_222613_497878_13928811)
In-Reply-To: <1414617944-29966-1-git-send-email-jouni@qca.qualcomm.com>
References: <1414617690-29786-1-git-send-email-jouni@qca.qualcomm.com>
 <1414617944-29966-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends regulatory rules for Venezuela to allow 160 MHz VHT channels
to be used in 5.15-5.25 GHz, 5.25-5.35 GHz. Since the rules between
5.15-5.25 and 5.25-5.35 GHz ranges are different (e.g., DFS
requirement), the AUTO-BW flag needs to be used to allow the maximum
channel bandwidth to be determined automatically based on two rules.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 499cc1b..c7854c2 100644
--- a/db.txt
+++ b/db.txt
@@ -1159,8 +1159,8 @@ country VC: DFS-ETSI
 # http://www.conatel.gob.ve/
 country VE: DFS-FCC
 	(2402 - 2482 @ 40), (30)
-	(5170 - 5250 @ 80), (23)
-	(5250 - 5330 @ 80), (23), DFS
+	(5170 - 5250 @ 80), (23), AUTO-BW
+	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
 	(5735 - 5835 @ 80), (30)
 
 country VI: DFS-FCC
-- 
1.9.1

