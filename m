Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab1LBRqR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:17 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/16] iwlwifi: declare static for iwl_sram_cleanup function
Date: Fri,  2 Dec 2011 08:48:29 -0800
Message-Id: <1322844520-21149-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184622_024709_9DC4A88F)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 4ea64d6..21b2fbb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -184,7 +184,7 @@ void iwl_testmode_init(struct iwl_priv *priv)
 	priv->testmode_sram.sram_readed = false;
 }
 
-void iwl_sram_cleanup(struct iwl_priv *priv)
+static void iwl_sram_cleanup(struct iwl_priv *priv)
 {
 	if (priv->testmode_sram.sram_readed) {
 		kfree(priv->testmode_sram.buff_addr);
-- 
1.7.0.4

