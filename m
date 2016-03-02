Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42652 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbcCBH5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:41 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/43] iwlwifi: mvm: various trivial cleanups
Date: Wed,  2 Mar 2016 09:56:30 +0200
Message-Id: <1456905404-14435-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085951_893880_6CDD94C8)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Remove uneeded includes:
	iwl-csr.h and devcoredump aren't used in mac80211.c.
* Remove uneeded empty line

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b755161..85ea5a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -70,7 +70,6 @@
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/if_arp.h>
-#include <linux/devcoredump.h>
 #include <linux/time.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
@@ -86,7 +85,6 @@
 #include "testmode.h"
 #include "iwl-fw-error-dump.h"
 #include "iwl-prph.h"
-#include "iwl-csr.h"
 #include "iwl-nvm-parse.h"
 #include "fw-dbg.h"
 
@@ -2142,7 +2140,6 @@ iwl_mvm_bss_info_changed_ap_ibss(struct iwl_mvm *mvm,
 				bss_conf->txpower);
 		iwl_mvm_set_tx_power(mvm, vif, bss_conf->txpower);
 	}
-
 }
 
 static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
-- 
2.5.0

