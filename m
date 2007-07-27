Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760258AbXG0J3A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:00 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 07/17] iwilwifi: removed unused constant
Date: Fri, 27 Jul 2007 17:26:31 +0800
Message-Id: <11855284142478-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284122218-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

removed OFDM_SYMBOL_TIME

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-hw.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index 58afbf7..49ad71b 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -99,7 +99,6 @@
  */
 #define SHORT_SLOT_TIME 9
 #define LONG_SLOT_TIME 20
-#define OFDM_SYMBOL_TIME 4
 
 /* RSSI to dBm */
 #if IWL == 3945
-- 
1.5.2
