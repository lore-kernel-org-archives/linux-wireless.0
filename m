Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6676 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482AbXJNUWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 16:22:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ian Schram <ischram@telenet.be>
Subject: [PATCH 2/5] iwlwifi: Two comments in iwl-3945.c were longer than 80 columns
Date: Sun, 14 Oct 2007 22:20:31 +0200
Message-Id: <11923932403473-git-send-email-tomas.winkler@intel.com> (sfid-20071014_212230_687403_8C704945)
In-Reply-To: <11923932343888-git-send-email-tomas.winkler@intel.com>
References: <11923932343888-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Schram <ischram@telenet.be>

This patch shorten two comments lines in iwl-3945.c
Signed-off-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index fecc008..1795d2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1137,8 +1137,9 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
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
@@ -1158,8 +1159,9 @@ int iwl_hw_get_temperature(struct iwl_priv *priv)
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
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
