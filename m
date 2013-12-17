Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45492 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3LQUpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:07 -0500
Received: by mail-ee0-f46.google.com with SMTP id d49so3061782eek.5
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:06 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/36] iwlwifi: mvm: clarify smps_requests documentation
Date: Tue, 17 Dec 2013 22:44:18 +0200
Message-Id: <1387313079-28123-15-git-send-email-egrumbach@gmail.com> (sfid-20131217_214631_537033_7FE97B64)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The documentation for smps_requests is unclear, rewrite it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4275720..84edf36 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -273,8 +273,8 @@ struct iwl_mvm_vif_bf_data {
  * @bcast_sta: station used for broadcast packets. Used by the following
  *  vifs: P2P_DEVICE, GO and AP.
  * @beacon_skb: the skb used to hold the AP/GO beacon template
- * @smps_requests: the requests of of differents parts of the driver, regard
-	the desired smps mode.
+ * @smps_requests: the SMPS requests of differents parts of the driver,
+ *	combined on update to yield the overall request to mac80211.
  */
 struct iwl_mvm_vif {
 	u16 id;
-- 
1.7.9.5

