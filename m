Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12529 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbYLSCpb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:31 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 30/43] iwlwifi: add more comments to IWL_DL_xx
Date: Fri, 19 Dec 2008 10:37:30 +0800
Message-Id: <1229654263-21454-31-git-send-email-yi.zhu@intel.com> (sfid-20081219_040901_917007_BE1DB4F5)
In-Reply-To: <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds more comments to IWL_DL_xx macros.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 067bd8e..e15bc3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -132,30 +132,32 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_MACDUMP		(1 << 4)
 #define IWL_DL_HCMD_DUMP	(1 << 5)
 #define IWL_DL_RADIO		(1 << 7)
-
+/* 0x00000F00 - 0x00000100 */
 #define IWL_DL_POWER		(1 << 8)
 #define IWL_DL_TEMP		(1 << 9)
 #define IWL_DL_NOTIF		(1 << 10)
 #define IWL_DL_SCAN		(1 << 11)
-
+/* 0x0000F000 - 0x00001000 */
 #define IWL_DL_ASSOC		(1 << 12)
 #define IWL_DL_DROP		(1 << 13)
 #define IWL_DL_TXPOWER		(1 << 14)
 #define IWL_DL_AP		(1 << 15)
-
+/* 0x000F0000 - 0x00010000 */
 #define IWL_DL_FW		(1 << 16)
 #define IWL_DL_RF_KILL		(1 << 17)
 #define IWL_DL_FW_ERRORS	(1 << 18)
 #define IWL_DL_LED		(1 << 19)
-
+/* 0x00F00000 - 0x00100000 */
 #define IWL_DL_RATE		(1 << 20)
 #define IWL_DL_CALIB		(1 << 21)
 #define IWL_DL_WEP		(1 << 22)
 #define IWL_DL_TX		(1 << 23)
+/* 0x0F000000 - 0x01000000 */
 #define IWL_DL_RX		(1 << 24)
 #define IWL_DL_ISR		(1 << 25)
 #define IWL_DL_HT		(1 << 26)
 #define IWL_DL_IO		(1 << 27)
+/* 0xF0000000 - 0x10000000 */
 #define IWL_DL_11H		(1 << 28)
 #define IWL_DL_STATS		(1 << 29)
 #define IWL_DL_TX_REPLY		(1 << 30)
-- 
1.5.3.6

