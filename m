Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:22607 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYCZM3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 08:29:51 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: the compact flash driver is no longer experimental
Date: Wed, 26 Mar 2008 13:26:55 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803261326.55437.hs4233@mail.mn-solutions.de> (sfid-20080326_122955_394033_18FC244F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/Kconfig	2008-03-26 12:25:36.000000000 +0100
+++ wireless-testing/drivers/net/wireless/Kconfig	2008-03-26 12:25:44.000000000 +0100
@@ -283,7 +283,7 @@ config LIBERTAS_USB
 
 config LIBERTAS_CS
 	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
-	depends on LIBERTAS && PCMCIA && EXPERIMENTAL
+	depends on LIBERTAS && PCMCIA
 	select FW_LOADER
 	---help---
 	  A driver for Marvell Libertas 8385 CompactFlash devices.
