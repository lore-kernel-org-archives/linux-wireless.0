Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48056 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797AbaLBSLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:49 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so17816498wgh.12
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:48 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/26] iwlwifi: fix 4165 series name
Date: Tue,  2 Dec 2014 20:11:09 +0200
Message-Id: <1417543877-24193-18-git-send-email-egrumbach@gmail.com> (sfid-20141202_191217_488327_59335A34)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Fix the 4165 series name that was called 4265 by mistake.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   | 4 ++--
 drivers/net/wireless/iwlwifi/iwl-config.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 1211569..bf0a95c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -159,8 +159,8 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.max_vht_ampdu_exponent = MAX_VHT_AMPDU_EXPONENT_8260_SDIO,
 };
 
-const struct iwl_cfg iwl4265_2ac_sdio_cfg = {
-	.name = "Intel(R) Dual Band Wireless-AC 4265",
+const struct iwl_cfg iwl4165_2ac_sdio_cfg = {
+	.name = "Intel(R) Dual Band Wireless-AC 4165",
 	.fw_name_pre = IWL8000_FW_PRE,
 	IWL_DEVICE_8000,
 	.ht_params = &iwl8000_ht_params,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index e63cafa..3a4b9c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -371,6 +371,7 @@ extern const struct iwl_cfg iwl8260_2n_cfg;
 extern const struct iwl_cfg iwl8260_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4265_2ac_sdio_cfg;
+extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
-- 
1.9.1

