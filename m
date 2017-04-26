Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54490 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S948081AbdDZH7F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:59:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 26 Apr 2017 10:58:46 +0300
Message-Id: <20170426075854.13546-2-luca@coelho.fi> (sfid-20170426_095912_365597_F345C8E2)
In-Reply-To: <20170426075854.13546-1-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
Subject: [PATCH 1/9] ieee80211: add SUITE_B AKM selectors
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add the definitions for SUITE_B and SUITE_B_192 AKM selectors as
defined in IEEE802.11REVmc_D5.0, table 9-132.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 294fa6273a62..23e095fa6701 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2356,18 +2356,20 @@ enum ieee80211_sa_query_action {
 #define WLAN_CIPHER_SUITE_SMS4		SUITE(0x001472, 1)
 
 /* AKM suite selectors */
-#define WLAN_AKM_SUITE_8021X		SUITE(0x000FAC, 1)
-#define WLAN_AKM_SUITE_PSK		SUITE(0x000FAC, 2)
-#define WLAN_AKM_SUITE_FT_PSK		SUITE(0x000FAC, 4)
-#define WLAN_AKM_SUITE_8021X_SHA256	SUITE(0x000FAC, 5)
-#define WLAN_AKM_SUITE_PSK_SHA256	SUITE(0x000FAC, 6)
-#define WLAN_AKM_SUITE_TDLS		SUITE(0x000FAC, 7)
-#define WLAN_AKM_SUITE_SAE		SUITE(0x000FAC, 8)
-#define WLAN_AKM_SUITE_FT_OVER_SAE	SUITE(0x000FAC, 9)
-#define WLAN_AKM_SUITE_FILS_SHA256	SUITE(0x000FAC, 14)
-#define WLAN_AKM_SUITE_FILS_SHA384	SUITE(0x000FAC, 15)
-#define WLAN_AKM_SUITE_FT_FILS_SHA256	SUITE(0x000FAC, 16)
-#define WLAN_AKM_SUITE_FT_FILS_SHA384	SUITE(0x000FAC, 17)
+#define WLAN_AKM_SUITE_8021X			SUITE(0x000FAC, 1)
+#define WLAN_AKM_SUITE_PSK			SUITE(0x000FAC, 2)
+#define WLAN_AKM_SUITE_FT_PSK			SUITE(0x000FAC, 4)
+#define WLAN_AKM_SUITE_8021X_SHA256		SUITE(0x000FAC, 5)
+#define WLAN_AKM_SUITE_PSK_SHA256		SUITE(0x000FAC, 6)
+#define WLAN_AKM_SUITE_TDLS			SUITE(0x000FAC, 7)
+#define WLAN_AKM_SUITE_SAE			SUITE(0x000FAC, 8)
+#define WLAN_AKM_SUITE_FT_OVER_SAE		SUITE(0x000FAC, 9)
+#define WLAN_AKM_SUITE_8021X_SUITE_B		SUITE(0x000FAC, 11)
+#define WLAN_AKM_SUITE_8021X_SUITE_B_192	SUITE(0x000FAC, 12)
+#define WLAN_AKM_SUITE_FILS_SHA256		SUITE(0x000FAC, 14)
+#define WLAN_AKM_SUITE_FILS_SHA384		SUITE(0x000FAC, 15)
+#define WLAN_AKM_SUITE_FT_FILS_SHA256		SUITE(0x000FAC, 16)
+#define WLAN_AKM_SUITE_FT_FILS_SHA384		SUITE(0x000FAC, 17)
 
 #define WLAN_MAX_KEY_LEN		32
 
-- 
2.11.0
