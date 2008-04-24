Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbYDXAPS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 16/16] iwlwifi: 3945 remove unused SCD definitions
Date: Wed, 23 Apr 2008 17:15:08 -0700
Message-Id: <1208996108-15326-17-git-send-email-reinette.chatre@intel.com> (sfid-20080424_023544_102363_80E15FF6)
In-Reply-To: <1208996108-15326-16-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-8-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-9-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-10-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-11-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-12-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-13-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-14-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-15-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-16-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch remove SCD definitions form iwl-3945-hw.h
The values from iwl-prph.h are used

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 8821c26..644bd9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -289,17 +289,6 @@ struct iwl3945_eeprom {
 #define PCI_REG_WUM8       0x0E8
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
-/* SCD (3945 Tx Frame Scheduler) */
-#define SCD_BASE                        (CSR_BASE + 0x2E00)
-
-#define SCD_MODE_REG                    (SCD_BASE + 0x000)
-#define SCD_ARASTAT_REG                 (SCD_BASE + 0x004)
-#define SCD_TXFACT_REG                  (SCD_BASE + 0x010)
-#define SCD_TXF4MF_REG                  (SCD_BASE + 0x014)
-#define SCD_TXF5MF_REG                  (SCD_BASE + 0x020)
-#define SCD_SBYP_MODE_1_REG             (SCD_BASE + 0x02C)
-#define SCD_SBYP_MODE_2_REG             (SCD_BASE + 0x030)
-
 /*=== FH (data Flow Handler) ===*/
 #define FH_BASE     (0x800)
 
-- 
1.5.3.4

