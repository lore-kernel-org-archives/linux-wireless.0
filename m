Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3HPLHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>
Subject: [PATCH 02/20] iwlwifi: introduce external debug level
Date: Fri, 16 Aug 2013 13:06:52 +0200
Message-Id: <1376651230-1060-2-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130728_881795_811BBA55)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

This debug level will be used in the future for logging
interaction with external modules.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 7edb851..b2bb32a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -145,6 +145,7 @@ do {                                            			\
 #define IWL_DL_RX		0x01000000
 #define IWL_DL_ISR		0x02000000
 #define IWL_DL_HT		0x04000000
+#define IWL_DL_EXTERNAL		0x08000000
 /* 0xF0000000 - 0x10000000 */
 #define IWL_DL_11H		0x10000000
 #define IWL_DL_STATS		0x20000000
@@ -153,6 +154,7 @@ do {                                            			\
 
 #define IWL_DEBUG_INFO(p, f, a...)	IWL_DEBUG(p, IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_MAC80211(p, f, a...)	IWL_DEBUG(p, IWL_DL_MAC80211, f, ## a)
+#define IWL_DEBUG_EXTERNAL(p, f, a...)	IWL_DEBUG(p, IWL_DL_EXTERNAL, f, ## a)
 #define IWL_DEBUG_TEMP(p, f, a...)	IWL_DEBUG(p, IWL_DL_TEMP, f, ## a)
 #define IWL_DEBUG_SCAN(p, f, a...)	IWL_DEBUG(p, IWL_DL_SCAN, f, ## a)
 #define IWL_DEBUG_RX(p, f, a...)	IWL_DEBUG(p, IWL_DL_RX, f, ## a)
-- 
1.8.4.rc2

