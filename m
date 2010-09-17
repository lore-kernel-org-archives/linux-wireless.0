Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab0IQVX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/10] iwlagn: add bt_status_read for 5150
Date: Fri, 17 Sep 2010 14:24:25 -0700
Message-Id: <1284758674-25297-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Include bt_status_read function pointer for 5150 device

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1dbb124..b9399fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -474,6 +474,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
+		.bt_stats_read = iwl_ucode_bt_stats_read,
 	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
-- 
1.7.0.4

