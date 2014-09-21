Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41509 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaIUTWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:50 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 16/17] iwlwifi: mvm: disable BT Co-running by default
Date: Sun, 21 Sep 2014 22:22:17 +0300
Message-Id: <1411327338-23099-16-git-send-email-egrumbach@gmail.com> (sfid-20140921_213113_930464_29291AA9)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The tables still contain dummy values.

Cc: <stable@vger.kernel.org> [3.15+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index f47f458..d4dfbe4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -90,7 +90,7 @@
 #define IWL_MVM_BT_COEX_EN_RED_TXP_THRESH	62
 #define IWL_MVM_BT_COEX_DIS_RED_TXP_THRESH	65
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
-#define IWL_MVM_BT_COEX_CORUNNING		1
+#define IWL_MVM_BT_COEX_CORUNNING		0
 #define IWL_MVM_BT_COEX_MPLUT			1
 #define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
 #define IWL_MVM_QUOTA_THRESHOLD			8
-- 
1.9.1

