Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42292 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751462AbdHEIpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 04:45:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 11:44:33 +0300
Message-Id: <20170805084438.12550-6-luca@coelho.fi> (sfid-20170805_104536_482118_07D267C0)
In-Reply-To: <20170805084438.12550-1-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
Subject: [PATCH 05/10] ieee80211: Add WFA TPC report element OUI type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 34e1bcd2d7ff..6572c2ca1261 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2412,6 +2412,7 @@ enum ieee80211_sa_query_action {
 #define WLAN_OUI_TYPE_MICROSOFT_WPA	1
 #define WLAN_OUI_TYPE_MICROSOFT_WMM	2
 #define WLAN_OUI_TYPE_MICROSOFT_WPS	4
+#define WLAN_OUI_TYPE_MICROSOFT_TPC	8
 
 /*
  * WMM/802.11e Tspec Element
-- 
2.13.2
