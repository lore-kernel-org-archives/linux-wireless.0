Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15724 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab0GaQyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 12:54:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 8/8] iwlagn: fix typo in ucode_bt_stats_read debugfs
Date: Sat, 31 Jul 2010 08:34:12 -0700
Message-Id: <1280590452-10655-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

small typo fix in ucode_bt_stats_read debugfs file

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index f052c6d..d706b8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -980,7 +980,7 @@ ssize_t iwl_ucode_bt_stats_read(struct file *file,
 			 le32_to_cpu(bt->lo_priority_tx_req_cnt),
 			 accum_bt->lo_priority_tx_req_cnt);
 	pos += scnprintf(buf + pos, bufsz - pos,
-			 "lo_priority_rx_denied_cnt:\t%u\t\t\t%u\n",
+			 "lo_priority_tx_denied_cnt:\t%u\t\t\t%u\n",
 			 le32_to_cpu(bt->lo_priority_tx_denied_cnt),
 			 accum_bt->lo_priority_tx_denied_cnt);
 	pos += scnprintf(buf + pos, bufsz - pos,
-- 
1.7.0.4

