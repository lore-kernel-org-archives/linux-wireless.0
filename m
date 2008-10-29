Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbYJ2VF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:05:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/7] iwlwifi: rename double inclusion protection name in iwl-commands.h
Date: Wed, 29 Oct 2008 14:05:47 -0700
Message-Id: <1225314349-11139-6-git-send-email-reinette.chatre@intel.com> (sfid-20081029_220536_351053_53B63D84)
In-Reply-To: <1225314349-11139-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch change the name of the double inclusion protection in
iwl-commands.h

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 5ab74fc..8aade00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -66,8 +66,8 @@
  * Please use iwl-dev.h for driver implementation definitions.
  */
 
-#ifndef __iwl4965_commands_h__
-#define __iwl4965_commands_h__
+#ifndef __iwl_commands_h__
+#define __iwl_commands_h__
 
 enum {
 	REPLY_ALIVE = 0x1,
@@ -3064,4 +3064,4 @@ struct iwl_rx_packet {
 
 #define IWL_RX_FRAME_SIZE        (4 + sizeof(struct iwl4965_rx_frame))
 
-#endif				/* __iwl4965_commands_h__ */
+#endif				/* __iwl_commands_h__ */
-- 
1.5.4.3

