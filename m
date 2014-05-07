Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45039 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaEGVus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 17:50:48 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath10k: Fix spelling mistake in comments.
Date: Wed,  7 May 2014 14:50:39 -0700
Message-Id: <1399499440-32365-1-git-send-email-greearb@candelatech.com> (sfid-20140507_235059_040020_47034407)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Simple typo fix.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index fa31b23..71a4470 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2340,9 +2340,9 @@ struct wmi_pdev_param_map {
 #define WMI_PDEV_PARAM_UNSUPPORTED 0
 
 enum wmi_pdev_param {
-	/* TX chian mask */
+	/* TX chain mask */
 	WMI_PDEV_PARAM_TX_CHAIN_MASK = 0x1,
-	/* RX chian mask */
+	/* RX chain mask */
 	WMI_PDEV_PARAM_RX_CHAIN_MASK,
 	/* TX power limit for 2G Radio */
 	WMI_PDEV_PARAM_TXPOWER_LIMIT2G,
-- 
1.7.11.7

