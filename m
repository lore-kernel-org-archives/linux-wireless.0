Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [77.235.43.93] ([77.235.43.93]:54114 "EHLO main.fasthost.gr"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802AbXGVNXv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2007 09:23:51 -0400
Received: from paravoid  by divinity (envelope-from <paravoid@debian.org>)
	with local (Exim 4.63 (Debian GNU/Linux))
	id 1ICbIx-0000mK-Ic
	for linux-wireless@vger.kernel.org; Sun, 22 Jul 2007 16:16:59 +0300
Date: Sun, 22 Jul 2007 16:16:59 +0300
From: Faidon Liambotis <paravoid@debian.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.23 2/3] [wireless] Kconfig: remove references of pcmcia-cs
Message-ID: <20070722131659.GA2981@void.cube.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pcmcia-cs/cardmgr is deprecated and mentioning it in the help text is
misleading.

Signed-off-by: Faidon Liambotis <paravoid@debian.org>
---
 drivers/net/wireless/Kconfig |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 2e264b0..cfcaf5c 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -63,11 +63,6 @@ config WAVELAN
 	  a Radio LAN (wireless Ethernet-like Local Area Network) using the
 	  radio frequencies 900 MHz and 2.4 GHz.
 
-	  This driver support the ISA version of the WaveLAN card.  A separate
-	  driver for the PCMCIA (PC-card) hardware is available in David
-	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
-	  for location).
-
 	  If you want to use an ISA WaveLAN card under Linux, say Y and read
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>. Some more specific
@@ -390,12 +385,7 @@ config PCMCIA_HERMES
 	  such as the Linksys, D-Link and Farallon Skyline.  It should also
 	  work on Symbol cards such as the 3Com AirConnect and Ericsson WLAN.
 
-	  To use your PC-cards, you will need supporting software from David
-	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
-	  for location).  You also want to check out the PCMCIA-HOWTO,
-	  available from <http://www.tldp.org/docs.html#howto>.
-
-	  You will also very likely also need the Wireless Tools in order to
+	  You will very likely need the Wireless Tools in order to
 	  configure your card and that /etc/pcmcia/wireless.opts works:
 	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
@@ -467,11 +457,6 @@ config AIRO_CS
 	  and Cisco proprietary API, so both the Linux Wireless Tools and the
 	  Cisco Linux utilities can be used to configure the card.
 
-	  To use your PC-cards, you will need supporting software from David
-	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
-	  for location).  You also want to check out the PCMCIA-HOWTO,
-	  available from <http://www.tldp.org/docs.html#howto>.
-
 config PCMCIA_WL3501
       tristate "Planet WL3501 PCMCIA cards"
       depends on EXPERIMENTAL && PCMCIA && WLAN_80211
-- 
1.5.2.4

