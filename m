Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18929 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2AIIh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 03:37:58 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 7/8] ath6kl: Removed unused ATH6KL_CONF_SUSPEND_CUTPOWER macro
Date: Mon, 9 Jan 2012 14:06:21 +0530
Message-ID: <1326098182-9103-8-git-send-email-rmani@qca.qualcomm.com> (sfid-20120109_093801_265050_97A23BE7)
In-Reply-To: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Title says everything.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index be61fc3..b6b756b 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -188,7 +188,6 @@ struct ath6kl_fw_ie {
 #define ATH6KL_CONF_IGNORE_PS_FAIL_EVT_IN_SCAN  BIT(1)
 #define ATH6KL_CONF_ENABLE_11N			BIT(2)
 #define ATH6KL_CONF_ENABLE_TX_BURST		BIT(3)
-#define ATH6KL_CONF_SUSPEND_CUTPOWER		BIT(4)
 
 enum wlan_low_pwr_state {
 	WLAN_POWER_STATE_ON,
-- 
1.7.1

