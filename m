Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759174Ab0JFPXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:23:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/6] iwlwifi: remove uncorrect comments
Date: Wed,  6 Oct 2010 08:23:11 -0700
Message-Id: <1286378593-7509-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

some structure belong to _agn devices, not just 5000. Fix it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 16dda2d..953e536 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1042,7 +1042,7 @@ struct iwl4965_keyinfo {
 	u8 key[16];		/* 16-byte unicast decryption key */
 } __packed;
 
-/* 5000 */
+/* agn */
 struct iwl_keyinfo {
 	__le16 key_flags;
 	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
@@ -1168,7 +1168,7 @@ struct iwl4965_addsta_cmd {
 	__le16 reserved2;
 } __packed;
 
-/* 5000 */
+/* agn */
 struct iwl_addsta_cmd {
 	u8 mode;		/* 1: modify existing, 0: add new station */
 	u8 reserved[3];
-- 
1.7.0.4

