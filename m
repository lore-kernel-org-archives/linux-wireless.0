Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2884 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbXDWUXW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 16:23:22 -0400
Date: Mon, 23 Apr 2007 15:53:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	johannes@sipsolutions.net,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: [PATCH] drivers/net/wireless/Kconfig: correct minor typo
Message-ID: <20070423195313.GG5883@tuxdriver.com>
References: <20070423183334.GC5883@tuxdriver.com> <20070423183443.GD5883@tuxdriver.com> <20070423213519.2692d0fd@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070423213519.2692d0fd@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct minor typo in drivers/net/wireless/Kconfig identified by
Stefano Brivio <stefano.brivio@polimi.it>.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 880c628..4426841 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -11,7 +11,7 @@ config WLAN_PRE80211
 	  Say Y if you have any pre-802.11 wireless LAN hardware.
 
 	  This option does not affect the kernel build, it only
-	  let's you choose drivers.
+	  lets you choose drivers.
 
 config STRIP
 	tristate "STRIP (Metricom starmode radio IP)"
@@ -112,7 +112,7 @@ config WLAN_80211
 	  Say Y if you have any 802.11 wireless LAN hardware.
 
 	  This option does not affect the kernel build, it only
-	  let's you choose drivers.
+	  lets you choose drivers.
 
 config PCMCIA_RAYCS
 	tristate "Aviator/Raytheon 2.4MHz wireless support"

-- 
John W. Linville
linville@tuxdriver.com
