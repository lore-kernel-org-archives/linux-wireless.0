Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647AbZHUUe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/14] iwlwifi: remove duplicated define
Date: Fri, 21 Aug 2009 13:34:22 -0700
Message-Id: <1250886867-4112-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Remove duplicated define "STA_FLG_PWR_SAVE_MSK"

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6b82d4e..2c5c88f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -886,7 +886,6 @@ struct iwl_qosparam_cmd {
 
 #define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2);
 #define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8);
-#define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8);
 #define STA_FLG_RTS_MIMO_PROT_MSK	cpu_to_le32(1 << 17)
 #define STA_FLG_AGG_MPDU_8US_MSK	cpu_to_le32(1 << 18)
 #define STA_FLG_MAX_AGG_SIZE_POS	(19)
-- 
1.5.6.3

