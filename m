Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53321 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbXLETA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 14:00:58 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/3] iwlwifi: add missing comments
Date: Wed,  5 Dec 2007 20:59:59 +0200
Message-Id: <1196881200841-git-send-email-tomas.winkler@intel.com> (sfid-20071205_190111_567417_C2A8180C)
In-Reply-To: <1196881200305-git-send-email-tomas.winkler@intel.com>
References: <1196881199774-git-send-email-tomas.winkler@intel.com>
 <1196881200305-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add comments that escaped from the previous merge

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 5a410e2..267ae75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -516,7 +516,7 @@ struct iwl_ht_info {
 	u8 supported_chan_width;
 	u16 tx_mimo_ps_mode;
 	u8 is_green_field;
-	u8 sgf;
+	u8 sgf;			/* HT_SHORT_GI_* short guard interval */
 	u8 max_amsdu_size;
 	u8 ampdu_factor;
 	u8 mpdu_density;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 14fccd6..f14c44a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -350,7 +350,7 @@ int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
 	 * For the command queue (#4), allocate command space + one big
 	 * command for scan, since scan command is very huge; the system will
 	 * not have two scans at the same time, so only one is needed.
-	 * For data Tx queues (all other queues), no super-size command
+	 * For normal Tx queues (all other queues), no super-size command
 	 * space is needed.
 	 */
 	len = sizeof(struct iwl4965_cmd) * slots_num;
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
