Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:60245 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab1ITXXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 19:23:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/8] iwlagn: remove uneeded declaration
Date: Tue, 20 Sep 2011 15:37:25 -0700
Message-Id: <1316558247-10018-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110921_012347_477236_417BD17F)
In-Reply-To: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This has been removed but the declaration hasn't.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 0e7d915..2b6756e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -275,8 +275,6 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
 				 dma_addr_t addr, u16 len, u8 reset);
 int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id);
 int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
-int __must_check iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id,
-			u32 flags, u16 len, const void *data);
 void iwl_tx_cmd_complete(struct iwl_trans *trans,
 			 struct iwl_rx_mem_buffer *rxb, int handler_status);
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
-- 
1.7.0.4

