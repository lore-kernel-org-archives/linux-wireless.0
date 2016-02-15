Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18944 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbcBOL7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 06:59:11 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/5] iwlwifi: dvm: remove a wrong dependency on m
Date: Mon, 15 Feb 2016 13:59:03 +0200
Message-Id: <1455537546-22157-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160215_181515_014009_05BE31EE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was wronly added when the dependency on IWLWIFI was
removed.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=112201

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 8660677..7438fbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -53,7 +53,6 @@ config IWLWIFI_LEDS
 
 config IWLDVM
 	tristate "Intel Wireless WiFi DVM Firmware support"
-	depends on m
 	help
 	  This is the driver that supports the DVM firmware. The list
 	  of the devices that use this firmware is available here:
-- 
2.5.0

