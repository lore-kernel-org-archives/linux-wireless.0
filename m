Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbXJYJWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ian Schram <ischram@telenet.be>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/30] iwlwifi: Two comments in iwl-3945.c were longer than 80 columns
Date: Thu, 25 Oct 2007 17:15:28 +0800
Message-Id: <11933037613709-git-send-email-yi.zhu@intel.com> (sfid-20071025_102252_408400_2E8A21AA)
In-Reply-To: <11933037601236-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Schram <ischram@telenet.be>

This patch shorten two comments lines in iwl-3945.c

Signed-off-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8b7db0c..62b44a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1136,8 +1136,9 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
 }
 
 /**
- * iwl_hw_reg_adjust_power_by_temp - return index delta into power gain settings table
- */
+ * iwl_hw_reg_adjust_power_by_temp
+ * return index delta into power gain settings table
+*/
 static int iwl_hw_reg_adjust_power_by_temp(int new_reading, int old_reading)
 {
 	return (new_reading - old_reading) * (-11) / 100;
@@ -1157,8 +1158,9 @@ int iwl_hw_get_temperature(struct iwl_priv *priv)
 }
 
 /**
- * iwl_hw_reg_txpower_get_temperature - get current temperature by reading from NIC
- */
+ * iwl_hw_reg_txpower_get_temperature
+ * get the current temperature by reading from NIC
+*/
 static int iwl_hw_reg_txpower_get_temperature(struct iwl_priv *priv)
 {
 	int temperature;
-- 
1.5.2
