Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbbHDU7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/37] iwlwifi: mvm: update comment of power_scheme module parameter
Date: Tue,  4 Aug 2015 23:43:14 +0300
Message-Id: <1438721007-23283-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230716_236508_4715BEF7)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d78af9f..767880b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -123,8 +123,7 @@ extern const struct ieee80211_ops iwl_mvm_hw_ops;
  *	be up'ed after the INIT fw asserted. This is useful to be able to use
  *	proprietary tools over testmode to debug the INIT fw.
  * @tfd_q_hang_detect: enabled the detection of hung transmit queues
- * @power_scheme: CAM(Continuous Active Mode)-1, BPS(Balanced Power
- *	Save)-2(default), LP(Low Power)-3
+ * @power_scheme: one of enum iwl_power_scheme
  */
 struct iwl_mvm_mod_params {
 	bool init_dbg;
-- 
2.1.4

