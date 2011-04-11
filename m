Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63965 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab1DKOwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 10:52:46 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 07:52:20 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 4/4] ath9k_hw: Fix AR9382 beacon distribution in IBSS
Date: Mon, 11 Apr 2011 20:22:31 +0530
Message-ID: <1302533551-27462-4-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1302533551-27462-1-git-send-email-rmanoharan@atheros.com>
References: <1302533551-27462-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update AR9003 mac_core table to fix imbalance
beacon distribution of AR9382.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index f915a3d..46ecb32 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -1508,9 +1508,9 @@ static const u32 ar9300_2p2_mac_core[][2] = {
 	{0x000081f8, 0x00000000},
 	{0x000081fc, 0x00000000},
 	{0x00008240, 0x00100000},
-	{0x00008244, 0x0010f424},
+	{0x00008244, 0x0010f400},
 	{0x00008248, 0x00000800},
-	{0x0000824c, 0x0001e848},
+	{0x0000824c, 0x0001e800},
 	{0x00008250, 0x00000000},
 	{0x00008254, 0x00000000},
 	{0x00008258, 0x00000000},
-- 
1.7.4.4

