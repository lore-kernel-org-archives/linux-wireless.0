Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35770 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751667AbdI2LVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 07:21:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 14:21:14 +0300
Message-Id: <20170929112114.6992-1-luca@coelho.fi> (sfid-20170929_132127_734870_220CCE3A)
In-Reply-To: <1504693769.13457.6.camel@sipsolutions.net>
References: <1504693769.13457.6.camel@sipsolutions.net>
Subject: [PATCH v2] ieee80211: Add WFA TPC report element OUI type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add Transmit Power Control OUI type definition for WLAN_OUI_MICROSOFT.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 55a604ad459f..ee6657a0ed69 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2445,6 +2445,7 @@ enum ieee80211_sa_query_action {
 #define WLAN_OUI_TYPE_MICROSOFT_WPA	1
 #define WLAN_OUI_TYPE_MICROSOFT_WMM	2
 #define WLAN_OUI_TYPE_MICROSOFT_WPS	4
+#define WLAN_OUI_TYPE_MICROSOFT_TPC	8
 
 /*
  * WMM/802.11e Tspec Element
-- 
2.14.1
