Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:49315 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751523AbZFXOFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 10:05:18 -0400
Date: Wed, 24 Jun 2009 16:07:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linville@tuxdriver.com
Cc: Matthew Wilcox <matthew@wil.cx>, "Zhu, Yi" <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] iwmc3200wifi: add Kconfig help
Message-ID: <20090624140721.GA3427@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We're missing a Kconfig help for the iwmc3200wifi driver.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
-- 
drivers/net/wireless/iwmc3200wifi/Kconfig |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index 1eccb6d..030401d 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -4,6 +4,15 @@ config IWM
 	depends on CFG80211
 	select WIRELESS_EXT
 	select FW_LOADER
+	help
+	  The Intel Wireless Multicomm 3200 hardware is a combo
+	  card with GPS, Bluetooth, WiMax and 802.11 radios. It
+	  runs over SDIO and is typically found on Moorestown
+	  based platform. This driver takes care of the 802.11
+	  part, which is a fullmac one.
+
+	  If you choose to build it as a module, it'll be called
+	  iwmc3200wifi.ko.
 
 config IWM_DEBUG
 	bool "Enable full debugging output in iwmc3200wifi"
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
