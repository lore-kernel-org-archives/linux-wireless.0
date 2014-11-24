Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45240 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbaKXOgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:55 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so12590353wgh.30
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:54 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 73/75] iwlwifi: declare d0i3 support for IWL_DEVICE_8000
Date: Mon, 24 Nov 2014 16:34:49 +0200
Message-Id: <1416839691-28533-73-git-send-email-egrumbach@gmail.com> (sfid-20141124_153707_241053_8A2CE2FF)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 0919759..436efad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -123,6 +123,7 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.base_params = &iwl8000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000,	\
+	.d0i3 = true,						\
 	.non_shared_ant = ANT_A
 
 const struct iwl_cfg iwl8260_2n_cfg = {
-- 
1.9.1

