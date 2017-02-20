Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50100 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753258AbdBTNYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 08:24:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH 2/6] ieee80211: add FT-PSK AKM suite selector
Date: Mon, 20 Feb 2017 14:24:35 +0100
Message-Id: <20170220132439.16064-2-johannes@sipsolutions.net> (sfid-20170220_142500_735862_A48A2D2F)
In-Reply-To: <20170220132439.16064-1-johannes@sipsolutions.net>
References: <20170220132439.16064-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 0dd9498c694f..6ea381c98aae 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2347,6 +2347,7 @@ enum ieee80211_sa_query_action {
 /* AKM suite selectors */
 #define WLAN_AKM_SUITE_8021X		SUITE(0x000FAC, 1)
 #define WLAN_AKM_SUITE_PSK		SUITE(0x000FAC, 2)
+#define WLAN_AKM_SUITE_FT_PSK		SUITE(0x000FAC, 4)
 #define WLAN_AKM_SUITE_8021X_SHA256	SUITE(0x000FAC, 5)
 #define WLAN_AKM_SUITE_PSK_SHA256	SUITE(0x000FAC, 6)
 #define WLAN_AKM_SUITE_TDLS		SUITE(0x000FAC, 7)
-- 
2.9.3
