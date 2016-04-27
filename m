Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39068 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbcD0Kxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 06:53:45 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 1/4] ath10k: add pdev bss channel info wmi definitions
Date: Wed, 27 Apr 2016 16:23:19 +0530
Message-ID: <1461754402-7679-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160427_125354_323967_9C0AAE52)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI definitions for pdev bss channel information request and
event.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index db2553522d8b..40bd08d246af 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1444,6 +1444,7 @@ enum wmi_10_2_cmd_id {
 	WMI_10_2_MU_CAL_START_CMDID,
 	WMI_10_2_SET_LTEU_CONFIG_CMDID,
 	WMI_10_2_SET_CCA_PARAMS,
+	WMI_10_2_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
 	WMI_10_2_PDEV_UTF_CMDID = WMI_10_2_END_CMDID - 1,
 };
 
@@ -1487,6 +1488,8 @@ enum wmi_10_2_event_id {
 	WMI_10_2_WDS_PEER_EVENTID,
 	WMI_10_2_PEER_STA_PS_STATECHG_EVENTID,
 	WMI_10_2_PDEV_TEMPERATURE_EVENTID,
+	WMI_10_2_MU_REPORT_EVENTID,
+	WMI_10_2_PDEV_BSS_CHAN_INFO_EVENTID,
 	WMI_10_2_PDEV_UTF_EVENTID = WMI_10_2_END_EVENTID - 1,
 };
 
@@ -2450,6 +2453,7 @@ enum wmi_10_2_feature_mask {
 	WMI_10_2_RX_BATCH_MODE = BIT(0),
 	WMI_10_2_ATF_CONFIG    = BIT(1),
 	WMI_10_2_COEX_GPIO     = BIT(3),
+	WMI_10_2_BSS_CHAN_INFO = BIT(6),
 	WMI_10_2_PEER_STATS    = BIT(7),
 };
 
-- 
2.8.0

