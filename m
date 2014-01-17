Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:53664 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaAQNIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 08:08:20 -0500
Received: by mail-ea0-f172.google.com with SMTP id g15so1166970eak.17
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 05:08:19 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: enable wmi ps peer param command for 10.x FW
Date: Fri, 17 Jan 2014 14:08:08 +0100
Message-Id: <1389964088-4458-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_140823_957964_F6788317)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable ap_ps_peer_param_cmdid for 10.x FW.
This is used mainly for AP UAPSD.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 712a606..f49a842 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -213,7 +213,7 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.p2p_go_set_beacon_ie = WMI_10X_P2P_GO_SET_BEACON_IE,
 	.p2p_go_set_probe_resp_ie = WMI_10X_P2P_GO_SET_PROBE_RESP_IE,
 	.p2p_set_vendor_ie_data_cmdid = WMI_CMD_UNSUPPORTED,
-	.ap_ps_peer_param_cmdid = WMI_CMD_UNSUPPORTED,
+	.ap_ps_peer_param_cmdid = WMI_10X_AP_PS_PEER_PARAM_CMDID,
 	.ap_ps_peer_uapsd_coex_cmdid = WMI_CMD_UNSUPPORTED,
 	.peer_rate_retry_sched_cmdid = WMI_10X_PEER_RATE_RETRY_SCHED_CMDID,
 	.wlan_profile_trigger_cmdid = WMI_10X_WLAN_PROFILE_TRIGGER_CMDID,
-- 
1.7.9.5

