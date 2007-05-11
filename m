Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbXEKCsg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:48:36 -0400
Subject: [PATCH 02/19] libertas: use <net/ieee80211.h> for MAX_WPA_IE_LEN
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 22:52:04 -0400
Message-Id: <1178851924.8607.13.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/dev.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index b1f876f..295e7d0 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -10,6 +10,7 @@
 #include <linux/wireless.h>
 #include <linux/ethtool.h>
 #include <linux/debugfs.h>
+#include <net/ieee80211.h>
 
 #include "defs.h"
 #include "scan.h"
@@ -198,7 +199,6 @@ struct assoc_request {
 	struct wlan_802_11_security secinfo;
 
 	/** WPA Information Elements*/
-#define MAX_WPA_IE_LEN 64
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	u8 wpa_ie_len;
 };
@@ -339,7 +339,6 @@ struct _wlan_adapter {
 	struct WLAN_802_11_KEY wpa_unicast_key;
 
 	/** WPA Information Elements*/
-#define MAX_WPA_IE_LEN 64
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	u8 wpa_ie_len;
 
-- 
1.5.0.6



