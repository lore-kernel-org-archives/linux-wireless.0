Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65013 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0JGABn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 20:01:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlagn: add define for MODULE_FIRMWARE
Date: Wed,  6 Oct 2010 17:00:55 -0700
Message-Id: <1286409655-32679-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286409655-32679-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286409655-32679-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding MODULE_FIRMWARE define for 130 series of devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b448b03..6261aec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -858,3 +858,4 @@ MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6000G2A_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6000G2B_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL130_MODULE_FIRMWARE(IWL130_UCODE_API_MAX));
-- 
1.7.0.4

