Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:55194 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931Ab0JWQSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:18:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 7/8] iwlwifi: add new devices to Kconfig
Date: Sat, 23 Oct 2010 09:15:45 -0700
Message-Id: <1287850546-23500-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding description to Kconfig to indicate more devices
are being supported by iwlagn

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index b823642..ed42457 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -106,6 +106,9 @@ config IWL5000
 		Intel WiFi Link 1000BGN
 		Intel Wireless WiFi 5150AGN
 		Intel Wireless WiFi 5100AGN, 5300AGN, and 5350AGN
+		Intel 6000 Gen 2 Series Wi-Fi Adapters (6000G2A and 6000G2B)
+		Intel WIreless WiFi Link 6050BGN Gen 2 Adapter
+		Intel 100 Series Wi-Fi Adapters (100BGN and 130BGN)
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
-- 
1.7.0.4

