Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-135-115-6.HINET-IP.hinet.net ([220.135.115.6]:54467 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbbESCTX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 22:19:23 -0400
Date: Tue, 19 May 2015 10:18:34 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: fix typos in Kconfig
Message-ID: <20150519021834.GA9546@ns.kevlo.org> (sfid-20150519_041927_157838_1EDAA6F6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes typos in drivers/net/wirless/rtlwifi/Kconfig.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---

diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/rtlwifi/Kconfig
index 5cf509d..73067ca 100644
--- a/drivers/net/wireless/rtlwifi/Kconfig
+++ b/drivers/net/wireless/rtlwifi/Kconfig
@@ -100,7 +100,7 @@ config RTL8821AE
 	select RTLWIFI_PCI
 	select RTLBTCOEXIST
 	---help---
-	This is the driver for Realtek RTL8i821AE/RTL8812AE 802.11av PCIe
+	This is the driver for Realtek RTL8821AE/RTL8812AE 802.11ac PCIe
 	wireless network adapters.
 
 	If you choose to build it as a module, it will be called rtl8821ae
