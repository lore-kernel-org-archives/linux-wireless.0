Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39633 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088AbZIFMuY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2009 08:50:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: PCMCIA is not experimental anymore
Date: Sun, 6 Sep 2009 14:49:43 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909061449.45455.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCMCIA support works well and is not experimental anymore.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
 drivers/net/wireless/b43/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig
+++ wireless-testing/drivers/net/wireless/b43/Kconfig
@@ -42,8 +42,8 @@ config B43_PCICORE_AUTOSELECT
 	default y
 
 config B43_PCMCIA
-	bool "Broadcom 43xx PCMCIA device support (EXPERIMENTAL)"
-	depends on B43 && SSB_PCMCIAHOST_POSSIBLE && EXPERIMENTAL
+	bool "Broadcom 43xx PCMCIA device support"
+	depends on B43 && SSB_PCMCIAHOST_POSSIBLE
 	select SSB_PCMCIAHOST
 	---help---
 	  Broadcom 43xx PCMCIA device support.

-- 
Greetings, Michael.
