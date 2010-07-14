Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47040 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0GNOpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 10:45:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: convert new uses of __attribute__ ((packed)) to __packed
Date: Wed, 14 Jul 2010 10:37:32 -0400
Message-Id: <1279118252-10258-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 8d2db9d..f1c0e68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1245,7 +1245,7 @@ struct iwl_txfifo_flush_cmd {
 	__le32 fifo_control;
 	__le16 flush_control;
 	__le16 reserved;
-} __attribute__ ((packed));
+} __packed;
 
 /*
  * REPLY_WEP_KEY = 0x20
@@ -3547,7 +3547,7 @@ struct iwl_sensitivity_cmd {
 struct iwl_enhance_sensitivity_cmd {
 	__le16 control;			/* always use "1" */
 	__le16 enhance_table[ENHANCE_HD_TABLE_SIZE];	/* use HD_* as index */
-} __attribute__ ((packed));
+} __packed;
 
 
 /**
-- 
1.7.1.1

