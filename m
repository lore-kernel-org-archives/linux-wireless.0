Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab1AVASW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:22 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/14] iwlagn: remove Gen2 from Kconfig
Date: Fri, 21 Jan 2011 16:06:42 -0800
Message-Id: <1295654809-5790-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Remove Gen 2 from Kconfig file since 6005/6030/6150 series of
products are released.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 442a146..236f900 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -110,8 +110,9 @@ config IWL5000
 		Intel WiFi Link 1000BGN
 		Intel Wireless WiFi 5150AGN
 		Intel Wireless WiFi 5100AGN, 5300AGN, and 5350AGN
-		Intel 6000 Gen 2 Series Wi-Fi Adapters (6000G2A and 6000G2B)
-		Intel WIreless WiFi Link 6050BGN Gen 2 Adapter
+		Intel 6005 Series Wi-Fi Adapters
+		Intel 6030 Series Wi-Fi Adapters
+		Intel Wireless WiFi Link 6150BGN 2 Adapter
 		Intel 100 Series Wi-Fi Adapters (100BGN and 130BGN)
 		Intel 2000 Series Wi-Fi Adapters
 
-- 
1.7.0.4

