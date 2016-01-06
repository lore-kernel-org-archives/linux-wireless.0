Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbcAFWYP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 17:24:15 -0500
From: Rodrigo Freire <rfreire@redhat.com>
To: johannes.berg@intel.com
Cc: emmanuel.grumbach@intel.com, linuxwifi@intel.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: Document missing module options
Date: Wed,  6 Jan 2016 20:24:01 -0200
Message-Id: <91cd61cc8ed52fab61dcf19531d821dda75db267.1452118569.git.rfreire@redhat.com> (sfid-20160106_232434_919727_A8EBFFB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch documents two missing module options in the internal
code comment block.

Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-modparams.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index ac2b90d..1477277 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -102,6 +102,8 @@ enum iwl_disable_11n {
  * @power_level: power level, default = 1
  * @debug_level: levels are IWL_DL_*
  * @ant_coupling: antenna coupling in dB, default = 0
+ * @nvm_file: specifies a external NVM file
+ * @uapsd_disable: disable U-APSD, default = 1
  * @d0i3_disable: disable d0i3, default = 1,
  * @lar_disable: disable LAR (regulatory), default = 0
  * @fw_monitor: allow to use firmware monitor
-- 
1.7.1

