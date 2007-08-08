Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12789 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757920AbXHHHhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/28] iwlwifi: add more Kconfig options
Date: Wed,  8 Aug 2007 15:33:19 +0800
Message-Id: <1186558432932-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584292234-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add IWLWIFI_SENSITIVITY, IWLWIFI_SPECTRUM_MEASUREMENT, and IWLWIFI_QOS.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/Kconfig |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index daa7c9e..a9f97ab 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -768,6 +768,29 @@ config IWLWIFI_DEBUG
 	  as the debug information can assist others in helping you resolve
 	  any problems you may encounter.
 
+config IWLWIFI_SENSITIVITY
+	bool "Enable Sensitivity Calibration in iwlwifi drivers"
+	depends on IWLWIFI
+	default y
+	---help---
+	  This option will enable sensitivity calibration for the iwlwifi
+	  drivers.
+
+config IWLWIFI_SPECTRUM_MEASUREMENT
+	bool "Enable Spectrum Measurement in iwlwifi drivers"
+	depends on IWLWIFI
+	default y
+	---help---
+	  This option will enable spectrum measurement for the iwlwifi drivers.
+
+config IWLWIFI_QOS
+	bool "Enable Wireless QoS in iwlwifi drivers"
+	depends on IWLWIFI
+	default y
+	---help---
+	  This option will enable wireless quality of service (QoS) for the
+	  iwlwifi drivers.
+
 config IWLWIFI_HT
 	bool "Enable 802.11n HT features in iwlwifi drivers"
 	depends on EXPERIMENTAL
-- 
1.5.2
