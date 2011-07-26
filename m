Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:35344 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753447Ab1GZVUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 17:20:51 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Jouni Malinen <j@w1.fi>
Subject: hostap_cs: add ID for LG cards
Date: Tue, 26 Jul 2011 23:14:00 +0200
Cc: linux-wireless@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201107262314.03422.linux@rainbow-software.org> (sfid-20110726_232055_119001_539E6CC7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add IDs for LG PCMCIA cards.
This allows LG LW1100P PCI card (with integrated CardBus bridge) to work
(tested with rev 3.0) and probably also LW1100N (PCMCIA).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-orig/drivers/net/wireless/hostap/hostap_cs.c	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/net/wireless/hostap/hostap_cs.c	2011-07-26 22:17:03.000000000 +0200
@@ -648,6 +648,8 @@ static struct pcmcia_device_id hostap_cs
 					 0x74c5e40d),
 	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "Intersil",
 					 0x4b801a17),
+	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "LG",
+					 0xb474d43a),
 	PCMCIA_MFC_DEVICE_PROD_ID12(0, "SanDisk", "ConnectPlus",
 				    0x7a954bd9, 0x74be00c6),
 	PCMCIA_DEVICE_PROD_ID123(


-- 
Ondrej Zary
