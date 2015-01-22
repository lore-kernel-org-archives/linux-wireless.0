Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbbAVUeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:23 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/38] iwlwifi: mvm: BT Coex - fine tune the MPLUT register
Date: Thu, 22 Jan 2015 22:33:15 +0200
Message-Id: <1421958809-3371-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214445_545674_DE79019C)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allow to better preserve the BT performance while
WiFi is running.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index f98f3ef..d91c46b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -94,7 +94,7 @@
 #define IWL_MVM_BT_COEX_MPLUT			1
 #define IWL_MVM_BT_COEX_RRC			1
 #define IWL_MVM_BT_COEX_TTC			1
-#define IWL_MVM_BT_COEX_MPLUT_REG0		0x28412201
+#define IWL_MVM_BT_COEX_MPLUT_REG0		0x22002200
 #define IWL_MVM_BT_COEX_MPLUT_REG1		0x11118451
 #define IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS	30
 #define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
-- 
1.9.1

