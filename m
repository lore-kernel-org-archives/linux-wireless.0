Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44137 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaBCU6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:31 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so3948490ead.6
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:30 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/62] iwlwifi: remove obsolete TODO
Date: Mon,  3 Feb 2014 22:57:16 +0200
Message-Id: <1391461088-8082-10-git-send-email-egrumbach@gmail.com> (sfid-20140203_220009_247462_39AD14CE)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The calib_version is 255 and this is perfectly fine - no
need to leave a TODO there.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index f06f4cb..4278097 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -397,11 +397,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 	iwl_init_sbands(dev, cfg, data, nvm_sw, sku & NVM_SKU_CAP_11AC_ENABLE,
 			tx_chains, rx_chains);
 
-	data->calib_version = 255;   /* TODO:
-					this value will prevent some checks from
-					failing, we need to check if this
-					field is still needed, and if it does,
-					where is it in the NVM*/
+	data->calib_version = 255;
 
 	return data;
 }
-- 
1.7.9.5

