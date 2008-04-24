Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51290 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760114AbYDXSzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 15/21] iwlwifi-5000: Add HW REV of 5000 HW family
Date: Thu, 24 Apr 2008 11:55:32 -0700
Message-Id: <1209063338-6572-16-git-send-email-reinette.chatre@intel.com> (sfid-20080424_210548_727506_F1342C1B)
In-Reply-To: <1209063338-6572-15-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-10-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-11-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-12-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-13-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-14-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-15-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds values fo CSR_HW_REV for 5000 HW family

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index f8de32b..9d6e5d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -198,6 +198,11 @@
 #define CSR_HW_REV_TYPE_MSK            (0x00000F0)
 #define CSR_HW_REV_TYPE_3945           (0x00000D0)
 #define CSR_HW_REV_TYPE_4965           (0x0000000)
+#define CSR_HW_REV_TYPE_5300           (0x0000020)
+#define CSR_HW_REV_TYPE_5350           (0x0000030)
+#define CSR_HW_REV_TYPE_5100           (0x0000050)
+#define CSR_HW_REV_TYPE_5150           (0x0000040)
+#define CSR_HW_REV_TYPE_NONE           (0x00000F0)
 
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
-- 
1.5.3.4

