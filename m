Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab1DHPuN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/16] iwlagn: remove unused 3945 define
Date: Fri,  8 Apr 2011 08:30:27 -0700
Message-Id: <1302276636-12802-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3945 no longer apply

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index da06d13..0f1052f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -424,7 +424,6 @@
 #define RX_LOW_WATERMARK 8
 
 /* Size of one Rx buffer in host DRAM */
-#define IWL_RX_BUF_SIZE_3K (3 * 1000) /* 3945 only */
 #define IWL_RX_BUF_SIZE_4K (4 * 1024)
 #define IWL_RX_BUF_SIZE_8K (8 * 1024)
 
@@ -443,7 +442,7 @@ struct iwl_rb_status {
 	__le16 closed_fr_num;
 	__le16 finished_rb_num;
 	__le16 finished_fr_nam;
-	__le32 __unused; /* 3945 only */
+	__le32 __unused;
 } __packed;
 
 
-- 
1.7.0.4

