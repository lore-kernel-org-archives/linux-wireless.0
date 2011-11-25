Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59592 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab1KYUIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 15:08:19 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/7] iwlwifi: show command string for REPLY_D3_CONFIG
Date: Fri, 25 Nov 2011 11:11:46 -0800
Message-Id: <1322248308-5113-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111125_210823_968844_0DE33A92)
In-Reply-To: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

missing the string, add it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index fdb4c37..087fd52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -117,6 +117,7 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_WOWLAN_TKIP_PARAMS);
 		IWL_CMD(REPLY_WOWLAN_KEK_KCK_MATERIAL);
 		IWL_CMD(REPLY_WOWLAN_GET_STATUS);
+		IWL_CMD(REPLY_D3_CONFIG);
 	default:
 		return "UNKNOWN";
 
-- 
1.7.0.4

