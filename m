Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47896 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab2DPWB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/16] iwlwifi: remove iwl_tx_queue declaration
Date: Mon, 16 Apr 2012 14:57:02 -0700
Message-Id: <1334613430-30720-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000232_001292_EEC09A61)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The declaration isn't needed as the struct is only
used in code that includes the right header file.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d8dd9ac..d56d4db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -51,8 +51,6 @@
 #include "iwl-op-mode.h"
 #include "iwl-notif-wait.h"
 
-struct iwl_tx_queue;
-
 /* CT-KILL constants */
 #define CT_KILL_THRESHOLD_LEGACY   110 /* in Celsius */
 #define CT_KILL_THRESHOLD	   114 /* in Celsius */
-- 
1.7.0.4

