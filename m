Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9395 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272AbcAaLGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Rodrigo Freire <rfreire@redhat.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/31] iwlwifi: Document missing module options
Date: Sun, 31 Jan 2016 13:06:04 +0200
Message-Id: <1454238386-27032-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120642_382415_D3398E63)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rodrigo Freire <rfreire@redhat.com>

This patch documents two missing module options in the internal
code comment block.

Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index fd42f63..b88ecc7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -108,6 +108,8 @@ enum iwl_amsdu_size {
  * @power_level: power level, default = 1
  * @debug_level: levels are IWL_DL_*
  * @ant_coupling: antenna coupling in dB, default = 0
+ * @nvm_file: specifies a external NVM file
+ * @uapsd_disable: disable U-APSD, default = 1
  * @d0i3_disable: disable d0i3, default = 1,
  * @d0i3_entry_delay: time to wait after no refs are taken before
  *	entering D0i3 (in msecs)
-- 
2.5.0

