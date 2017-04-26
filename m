Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54504 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1956644AbdDZH7G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:59:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 26 Apr 2017 10:58:48 +0300
Message-Id: <20170426075854.13546-4-luca@coelho.fi> (sfid-20170426_095917_339386_292A0E86)
In-Reply-To: <20170426075854.13546-1-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
Subject: [PATCH 3/9] ieee80211: add FT-802.1X AKM suite selector
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add the definition for FT-8021.1X AKM selector as defined in
IEEE Std 802.11-2016, table 9-133.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index c916ba4a22d4..13f23036dc05 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2384,6 +2384,7 @@ enum ieee80211_sa_query_action {
 /* AKM suite selectors */
 #define WLAN_AKM_SUITE_8021X			SUITE(0x000FAC, 1)
 #define WLAN_AKM_SUITE_PSK			SUITE(0x000FAC, 2)
+#define WLAN_AKM_SUITE_FT_8021X			SUITE(0x000FAC, 3)
 #define WLAN_AKM_SUITE_FT_PSK			SUITE(0x000FAC, 4)
 #define WLAN_AKM_SUITE_8021X_SHA256		SUITE(0x000FAC, 5)
 #define WLAN_AKM_SUITE_PSK_SHA256		SUITE(0x000FAC, 6)
-- 
2.11.0
