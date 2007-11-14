Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:58387 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761500AbXKNRti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 12:49:38 -0500
Date: Wed, 14 Nov 2007 19:49:49 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH] Add myself to MAINTAINERS and rewrite module description
	on Kconfig
Message-ID: <20071114174949.GA7479@localhost.domain.invalid> (sfid-20071114_174950_007098_E56D817E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*Add better description in Kconfig
*Add myself to MAINTAINERS

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/MAINTAINERS b/MAINTAINERS
index 751cd42..38b3956 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -652,9 +652,12 @@ S:	Supported
 ATHEROS ATH5K WIRELESS DRIVER
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
+P:	Nick Kossifidis
+M:	mickflemm@gmail.com
 P:	Luis R. Rodriguez
 M:	mcgrof@gmail.com
 L:	linux-wireless@vger.kernel.org
+L:	ath5k-devel@lists.ath5k.org
 S:	Maintained
 
 ATL1 ETHERNET DRIVER

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index f29d24d..393301e 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -609,8 +609,13 @@ config ATH5K
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	default m
 	---help---
-	  This module adds support for atheros 5xxx (e.g. 5212) wireless
-	  cards. If you have this card in your PC, select this to be build.
+	  This module adds support for wireless adapters based on
+	  Atheros 5xxx chipset. 
+
+	  Currently the following chip versions are supported:
+
+	  MAC: AR5211 AR5212
+	  PHY: RF5111/2111 RF5112/2112 RF5413/2413
 
 	  This driver uses the kernel's mac80211 subsystem.
 


