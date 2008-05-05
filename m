Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45862 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbYEECYF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:05 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 02/25] iwlwifi-5000: rename iwl5000_init_nic to iwl5000_init_config
Date: Mon,  5 May 2008 10:22:29 +0800
Message-Id: <1209954172-3092-3-git-send-email-yi.zhu@intel.com> (sfid-20080505_042355_224423_E36AC4F7)
In-Reply-To: <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 0d8ef63..83ed69d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -86,7 +86,7 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	return ret;
 }
 
-static void iwl5000_nic_init(struct iwl_priv *priv)
+static void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	u16 radio_cfg;
@@ -439,7 +439,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
-		.config = iwl5000_nic_init,
+		.config = iwl5000_nic_config,
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
 	.eeprom_ops = {
-- 
1.5.3.6

