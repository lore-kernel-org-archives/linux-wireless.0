Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14460 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbYEOF4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:33 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 19/26] iwlwifi: add rx_handlers stub for iwl5000
Date: Thu, 15 May 2008 13:54:11 +0800
Message-Id: <1210830858-3410-20-git-send-email-yi.zhu@intel.com> (sfid-20080515_081614_091083_81F168B2)
In-Reply-To: <1210830858-3410-19-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-9-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-11-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-12-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-13-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-14-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-15-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-16-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-17-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-18-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-19-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds rx_handler_setup stub to iwl5000.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d155247..00ad360 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -464,6 +464,10 @@ static u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
 	return len;
 }
 
+static void iwl5000_rx_handler_setup(struct iwl_priv *priv)
+{
+}
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
@@ -483,6 +487,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.shared_mem_rx_idx = iwl5000_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.disable_tx_fifo = iwl5000_disable_tx_fifo,
+	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.config = iwl5000_nic_config,
-- 
1.5.3.6

