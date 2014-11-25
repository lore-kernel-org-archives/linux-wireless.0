Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48307 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaKYUCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 15:02:48 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath10k: add new pdev parameters for fw 10.2
Date: Tue, 25 Nov 2014 12:02:44 -0800
Message-ID: <1416945765-26902-1-git-send-email-poh@qca.qualcomm.com> (sfid-20141125_210305_756145_81C9814E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New pdev paramters have been added to firmware 10.2,
hence update wmi interfaces to sync with.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index a38d788..8fa0192 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2707,6 +2707,9 @@ enum wmi_10x_pdev_param {
 	WMI_10X_PDEV_PARAM_SET_MCAST2UCAST_MODE,
 	WMI_10X_PDEV_PARAM_SET_MCAST2UCAST_BUFFER,
 	WMI_10X_PDEV_PARAM_REMOVE_MCAST2UCAST_BUFFER,
+	WMI_10X_PDEV_PEER_STA_PS_STATECHG_ENABLE,
+	WMI_10X_PDEV_PARAM_RTS_FIXED_RATE,
+	WMI_10X_PDEV_PARAM_CAL_PERIOD
 };
 
 struct wmi_pdev_set_param_cmd {
-- 
1.9.1

