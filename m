Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33432 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753613AbcGFKog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:19 +0300
Message-Id: <1467801651-1816-24-git-send-email-luca@coelho.fi> (sfid-20160706_125024_370485_ACF92AD7)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 24/56] iwlwifi: Reserve iwl_fw_error_dump_type enum
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Reserve a single iwl_fw_error_dump_type enum for external
code utilities.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
index 09b7ea2..420c31d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
@@ -89,6 +89,9 @@
  * @IWL_FW_ERROR_PAGING: UMAC's image memory segments which were
  *	paged to the DRAM.
  * @IWL_FW_ERROR_DUMP_RADIO_REG: Dump the radio registers.
+ * @IWL_FW_ERROR_DUMP_EXTERNAL: used only by external code utilities, and
+ *	for that reason is not in use in any other place in the Linux Wi-Fi
+ *	stack.
  */
 enum iwl_fw_error_dump_type {
 	/* 0 is deprecated */
@@ -106,6 +109,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_PAGING = 12,
 	IWL_FW_ERROR_DUMP_RADIO_REG = 13,
 	IWL_FW_ERROR_DUMP_INTERNAL_TXF = 14,
+	IWL_FW_ERROR_DUMP_EXTERNAL = 15, /* Do not move */
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
-- 
2.8.1

