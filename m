Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:4324 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZJGHL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 03:11:58 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] libertas: remove extraneous select FW_LOADER
Date: Wed, 7 Oct 2009 09:10:33 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910070910.33493.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As kindly pointed out by Andrey Yurovsky, CONFIG_LIBERTAS already
selects FW_LOADER.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: linux-wl/drivers/net/wireless/libertas/Kconfig
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/Kconfig	
2009-10-07 08:00:25.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/Kconfig	2009-10-07 
08:00:30.000000000 +0200
@@ -17,7 +17,6 @@ config LIBERTAS_USB
 config LIBERTAS_CS
 	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
 	depends on LIBERTAS && PCMCIA
-	select FW_LOADER
 	---help---
 	  A driver for Marvell Libertas 8385 CompactFlash devices.
 

-- 
http://www.holgerschurig.de
