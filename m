Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab1AVASV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:21 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/14] iwlagn: add 2000 series to Kconfig
Date: Fri, 21 Jan 2011 16:06:41 -0800
Message-Id: <1295654809-5790-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add 2000 series support to Kconfig

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 8994d30..442a146 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -113,6 +113,7 @@ config IWL5000
 		Intel 6000 Gen 2 Series Wi-Fi Adapters (6000G2A and 6000G2B)
 		Intel WIreless WiFi Link 6050BGN Gen 2 Adapter
 		Intel 100 Series Wi-Fi Adapters (100BGN and 130BGN)
+		Intel 2000 Series Wi-Fi Adapters
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
-- 
1.7.0.4

