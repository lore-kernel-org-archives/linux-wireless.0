Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22543 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbcDDXUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 19:20:22 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath10k: update 10.4 WMI vdev parameters
Date: Mon, 4 Apr 2016 16:19:15 -0700
Message-ID: <1459811956-26186-3-git-send-email-poh@qca.qualcomm.com> (sfid-20160405_012029_345233_D8220FE0)
In-Reply-To: <1459811956-26186-1-git-send-email-poh@qca.qualcomm.com>
References: <1459811956-26186-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update 10.4 WMI vdev param to sync to current 10.4 firmware
as of 2/23/2016.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 8225d90..e10df2e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4957,6 +4957,12 @@ enum wmi_10_4_vdev_param {
 	WMI_10_4_VDEV_PARAM_MERU_VC,
 	WMI_10_4_VDEV_PARAM_RX_DECAP_TYPE,
 	WMI_10_4_VDEV_PARAM_BW_NSS_RATEMASK,
+	WMI_10_4_VDEV_PARAM_SENSOR_AP,
+	WMI_10_4_VDEV_PARAM_BEACON_RATE,
+	WMI_10_4_VDEV_PARAM_DTIM_ENABLE_CTS,
+	WMI_10_4_VDEV_PARAM_STA_KICKOUT,
+	WMI_10_4_VDEV_PARAM_CAPABILITIES,
+	WMI_10_4_VDEV_PARAM_TSF_INCREMENT,
 };
 
 #define WMI_VDEV_PARAM_TXBF_SU_TX_BFEE BIT(0)
-- 
1.9.1

