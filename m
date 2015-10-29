Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26039 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbbJ2NnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 09:43:12 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 3/3] ath10k: Add new pdev params defines to 10.4
Date: Thu, 29 Oct 2015 19:11:34 +0530
Message-ID: <1446126094-30880-4-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20151029_144315_447750_05E97BBB)
In-Reply-To: <1446126094-30880-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1446126094-30880-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functionality change, just sync to the latest
pdev params that 10.4 firmware defines.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3076581..a9073b0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3660,6 +3660,12 @@ enum wmi_10_4_pdev_param {
 	WMI_10_4_PDEV_PARAM_WAPI_MBSSID_OFFSET,
 	WMI_10_4_PDEV_PARAM_ARP_SRCADDR,
 	WMI_10_4_PDEV_PARAM_ARP_DSTADDR,
+	WMI_10_4_PDEV_PARAM_TXPOWER_DECR_DB,
+	WMI_10_4_PDEV_PARAM_RX_BATCHMODE,
+	WMI_10_4_PDEV_PARAM_PACKET_AGGR_DELAY,
+	WMI_10_4_PDEV_PARAM_ATF_OBSS_NOISE_SCH,
+	WMI_10_4_PDEV_PARAM_ATF_OBSS_NOISE_SCALING_FACTOR,
+	WMI_10_4_PDEV_PARAM_CUST_TXPOWER_SCALE,
 };
 
 struct wmi_pdev_set_param_cmd {
-- 
1.9.1

