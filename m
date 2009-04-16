Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3864 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbZDPXX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 19:23:29 -0400
Subject: [PATCH] iwl3945-base.c: Add missing space to debug print
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 16:23:26 -0700
Message-Id: <1239924206.32157.149.camel@localhost> (sfid-20090417_012334_474870_F687F9BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"not" is not printed without a space after %pM

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ce72928..f6a6177 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4075,7 +4075,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (!static_key) {
 		sta_id = iwl3945_hw_find_station(priv, addr);
 		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_MAC80211(priv, "leave - %pMnot in station map.\n",
+			IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
 					    addr);
 			return -EINVAL;
 		}


