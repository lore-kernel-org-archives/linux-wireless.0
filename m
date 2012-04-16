Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab2DPWB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/16] iwlwifi: added HBUS_TARG_TEST_REG
Date: Mon, 16 Apr 2012 14:57:00 -0700
Message-Id: <1334613430-30720-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000248_718101_4A95B9E2)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

This register is used to enable some debug mechanisms.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 5f96ce1..5975054 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -430,6 +430,9 @@
 #define HBUS_TARG_PRPH_WDAT     (HBUS_BASE+0x04c)
 #define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
 
+/* Used to enable DBGM */
+#define HBUS_TARG_TEST_REG	(HBUS_BASE+0x05c)
+
 /*
  * Per-Tx-queue write pointer (index, really!)
  * Indicates index to next TFD that driver will fill (1 past latest filled).
-- 
1.7.0.4

