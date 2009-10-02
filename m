Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183AbZJBUtt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/13] iwlwifi: change valid EEPROM version for 1000 series
Date: Fri,  2 Oct 2009 13:43:59 -0700
Message-Id: <1254516247-4085-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In order to support different type of 1000 series NICs we release to
customers before the production release, iwlwifi driver need to support
all the NICs has EEPROM version greater than 0x15c.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 3bcd600..0eee059 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -257,7 +257,7 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_5050_EEPROM_VERSION	(0x21E)
 
 /* 1000 Specific */
-#define EEPROM_1000_EEPROM_VERSION	(0x15D)
+#define EEPROM_1000_EEPROM_VERSION	(0x15C)
 
 /* 60x0 Specific */
 #define EEPROM_6000_EEPROM_VERSION	(0x434)
-- 
1.5.6.3

