Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0GITXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 15:23:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/4] iwlagn: more generic description for iwlagn devices
Date: Fri,  9 Jul 2010 12:24:39 -0700
Message-Id: <1278703480-13363-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278703480-13363-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278703480-13363-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Intel Wireless WiFi Next Gen AGN support two major categories:
 1. Intel Wireless WiFi 4965 AGN device
 2. Intel Wireless-N/Advanced-N/Ultimate-N family

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 6491e27..a51e4da 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -87,10 +87,15 @@ config IWL4965
 	  This option enables support for Intel Wireless WiFi Link 4965AGN
 
 config IWL5000
-	bool "Intel Wireless WiFi 5000AGN; Intel WiFi Link 1000, 6000, and 6050 Series"
+	bool "Intel Wireless-N/Advanced-N/Ultimate-N WiFi Link"
 	depends on IWLAGN
 	---help---
-	  This option enables support for Intel Wireless WiFi Link 5000AGN Family
+	  This option enables support for use with the following hardware:
+		Intel Wireless WiFi Link 6250AGN Adapter
+		Intel 6000 Series Wi-Fi Adapters (6200AGN and 6300AGN)
+		Intel WiFi Link 1000BGN
+		Intel Wireless WiFi 5150AGN
+		Intel Wireless WiFi 5100AGN, 5300AGN, and 5350AGN
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
-- 
1.7.0.4

