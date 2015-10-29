Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40267 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbbJ2Nmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 09:42:47 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 2/3] ath10k: Add new WMI cmd/event defines for 10.4
Date: Thu, 29 Oct 2015 19:11:33 +0530
Message-ID: <1446126094-30880-3-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20151029_144251_380445_DBAF4529)
In-Reply-To: <1446126094-30880-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1446126094-30880-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No real functionality change, add WMI command/event
defines to be in sync with 10.4 firmware.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 103dd8c..3076581 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1582,6 +1582,9 @@ enum wmi_10_4_cmd_id {
 	WMI_10_4_MU_CAL_START_CMDID,
 	WMI_10_4_SET_CCA_PARAMS_CMDID,
 	WMI_10_4_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
+	WMI_10_4_EXT_RESOURCE_CFG_CMDID,
+	WMI_10_4_VDEV_SET_IE_CMDID,
+	WMI_10_4_SET_LTEU_CONFIG_CMDID,
 	WMI_10_4_PDEV_UTF_CMDID = WMI_10_4_END_CMDID - 1,
 };
 
@@ -1644,6 +1647,7 @@ enum wmi_10_4_event_id {
 	WMI_10_4_PDEV_TEMPERATURE_EVENTID,
 	WMI_10_4_PDEV_NFCAL_POWER_ALL_CHANNELS_EVENTID,
 	WMI_10_4_PDEV_BSS_CHAN_INFO_EVENTID,
+	WMI_10_4_MU_REPORT_EVENTID,
 	WMI_10_4_PDEV_UTF_EVENTID = WMI_10_4_END_EVENTID - 1,
 };
 
-- 
1.9.1

