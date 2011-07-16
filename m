Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab1GPPcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/18] iwlagn: add comment to tx and get_tx_cmd in iwl_trans_ops
Date: Sat, 16 Jul 2011 07:56:30 -0700
Message-Id: <1310828199-18000-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173241_704261_D4FA4774)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Those comments were missed in a previous commit.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cb6801c..34625de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1243,6 +1243,8 @@ struct iwl_trans;
  * @tx_free: frees the tx memory
  * @send_cmd:send a host command
  * @send_cmd_pdu:send a host command: flags can be CMD_*
+ * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
+ * @tx: send an skb
  * @sync_irq: the upper layer will typically disable interrupt and call this
  *            handler. After this handler returns, it is guaranteed that all
  *            the ISR / tasklet etc... have finished running and the transport
-- 
1.7.0.4

