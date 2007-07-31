Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49643 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbXGaC7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 22:59:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/7] iwlwifi: add IWLWIFI_HT Kconfig option
Date: Tue, 31 Jul 2007 10:56:30 +0800
Message-Id: <118585059814-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11858505963374-git-send-email-yi.zhu@intel.com>
References: <11858505963374-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/Kconfig |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index afb0871..daa7c9e 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -768,6 +768,15 @@ config IWLWIFI_DEBUG
 	  as the debug information can assist others in helping you resolve
 	  any problems you may encounter.
 
+config IWLWIFI_HT
+	bool "Enable 802.11n HT features in iwlwifi drivers"
+	depends on EXPERIMENTAL
+	depends on IWLWIFI && MAC80211_HT
+	default n
+	---help---
+	  This option enables IEEE 802.11n High Throughput features
+	  for the iwlwifi drivers.
+
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN"
 	depends on m && IWLWIFI && EXPERIMENTAL
-- 
1.5.2
