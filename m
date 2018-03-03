Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41124 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965093AbeCCCDe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 21:03:34 -0500
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] net/wireless: fix spaces and grammar copy/paste in vendor
 Kconfig help text
Message-ID: <1627081c-ef0c-1d55-ca2e-898f22b98d72@infradead.org> (sfid-20180303_030346_558564_1FB723D9)
Date: Fri, 2 Mar 2018 18:03:30 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Lots of the wireless driver vendor Kconfig symol help text says
"questions about  cards." (2 spaces between "about" and "cards")

Besides dropping one of those spaces, it also needs some other word
inserted there. Instead of putting each vendor's name there, I chose
to say "these" cards in all of the Kconfig help text.

Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/net/wireless/admtek/Kconfig    |    4 ++--
 drivers/net/wireless/ath/Kconfig       |    4 ++--
 drivers/net/wireless/atmel/Kconfig     |    4 ++--
 drivers/net/wireless/broadcom/Kconfig  |    4 ++--
 drivers/net/wireless/cisco/Kconfig     |    4 ++--
 drivers/net/wireless/intel/Kconfig     |    4 ++--
 drivers/net/wireless/intersil/Kconfig  |    4 ++--
 drivers/net/wireless/marvell/Kconfig   |    4 ++--
 drivers/net/wireless/mediatek/Kconfig  |    4 ++--
 drivers/net/wireless/quantenna/Kconfig |    4 ++--
 drivers/net/wireless/ralink/Kconfig    |    4 ++--
 drivers/net/wireless/realtek/Kconfig   |    4 ++--
 drivers/net/wireless/rsi/Kconfig       |    4 ++--
 drivers/net/wireless/st/Kconfig        |    4 ++--
 drivers/net/wireless/ti/Kconfig        |    4 ++--
 drivers/net/wireless/zydas/Kconfig     |    4 ++--
 16 files changed, 32 insertions(+), 32 deletions(-)

--- linux-next-20180302.orig/drivers/net/wireless/admtek/Kconfig
+++ linux-next-20180302/drivers/net/wireless/admtek/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_ADMTEK
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_ADMTEK
--- linux-next-20180302.orig/drivers/net/wireless/ath/Kconfig
+++ linux-next-20180302/drivers/net/wireless/ath/Kconfig
@@ -8,8 +8,8 @@ config WLAN_VENDOR_ATH
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 	  For more information and documentation on this module you can visit:
--- linux-next-20180302.orig/drivers/net/wireless/atmel/Kconfig
+++ linux-next-20180302/drivers/net/wireless/atmel/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_ATMEL
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_ATMEL
--- linux-next-20180302.orig/drivers/net/wireless/broadcom/Kconfig
+++ linux-next-20180302/drivers/net/wireless/broadcom/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_BROADCOM
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_BROADCOM
--- linux-next-20180302.orig/drivers/net/wireless/cisco/Kconfig
+++ linux-next-20180302/drivers/net/wireless/cisco/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_CISCO
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_CISCO
--- linux-next-20180302.orig/drivers/net/wireless/intel/Kconfig
+++ linux-next-20180302/drivers/net/wireless/intel/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_INTEL
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_INTEL
--- linux-next-20180302.orig/drivers/net/wireless/intersil/Kconfig
+++ linux-next-20180302/drivers/net/wireless/intersil/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_INTERSIL
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_INTERSIL
--- linux-next-20180302.orig/drivers/net/wireless/marvell/Kconfig
+++ linux-next-20180302/drivers/net/wireless/marvell/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_MARVELL
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_MARVELL
--- linux-next-20180302.orig/drivers/net/wireless/mediatek/Kconfig
+++ linux-next-20180302/drivers/net/wireless/mediatek/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_MEDIATEK
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_MEDIATEK
--- linux-next-20180302.orig/drivers/net/wireless/quantenna/Kconfig
+++ linux-next-20180302/drivers/net/wireless/quantenna/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_QUANTENNA
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_QUANTENNA
--- linux-next-20180302.orig/drivers/net/wireless/ralink/Kconfig
+++ linux-next-20180302/drivers/net/wireless/ralink/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_RALINK
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_RALINK
--- linux-next-20180302.orig/drivers/net/wireless/realtek/Kconfig
+++ linux-next-20180302/drivers/net/wireless/realtek/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_REALTEK
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_REALTEK
--- linux-next-20180302.orig/drivers/net/wireless/rsi/Kconfig
+++ linux-next-20180302/drivers/net/wireless/rsi/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_RSI
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_RSI
--- linux-next-20180302.orig/drivers/net/wireless/st/Kconfig
+++ linux-next-20180302/drivers/net/wireless/st/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_ST
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_ST
--- linux-next-20180302.orig/drivers/net/wireless/ti/Kconfig
+++ linux-next-20180302/drivers/net/wireless/ti/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_TI
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_TI
--- linux-next-20180302.orig/drivers/net/wireless/zydas/Kconfig
+++ linux-next-20180302/drivers/net/wireless/zydas/Kconfig
@@ -5,8 +5,8 @@ config WLAN_VENDOR_ZYDAS
 	  If you have a wireless card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about  cards. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if WLAN_VENDOR_ZYDAS
