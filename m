Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759940AbZKFWxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:05 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/20] iwlwifi: Update comments for struct iwl_ssid_ie
Date: Fri,  6 Nov 2009 14:52:59 -0800
Message-Id: <1257547983-12590-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index b62c90e..2857287 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2566,9 +2566,10 @@ struct iwl_scan_channel {
 /**
  * struct iwl_ssid_ie - directed scan network information element
  *
- * Up to 4 of these may appear in REPLY_SCAN_CMD, selected by "type" field
- * in struct iwl_scan_channel; each channel may select different ssids from
- * among the 4 entries.  SSID IEs get transmitted in reverse order of entry.
+ * Up to 20 of these may appear in REPLY_SCAN_CMD (Note: Only 4 are in
+ * 3945 SCAN api), selected by "type" bit field in struct iwl_scan_channel;
+ * each channel may select different ssids from among the 20 (4) entries.
+ * SSID IEs get transmitted in reverse order of entry.
  */
 struct iwl_ssid_ie {
 	u8 id;
-- 
1.5.6.3

