Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbZGADjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 23:39:17 -0400
Date: Tue, 30 Jun 2009 22:39:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, ccmcphe@verizon.net
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43: Add support for 4318E
Message-ID: <4a4ada70.t85pybsO8xH4owyV%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Clyde McPherson <ccmcphe@verizon.net>

Added support for the Broadcom 4318E chipset on PCMCIA/CF cards. The 
4318E can do 802.11A/B/G, only B and G mode are supported in b43.

Signed-off-by: Clyde McPherson <ccmcphe@verizon.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

diff --git a/drivers/net/wireless/b43/pcmcia.c 
b/drivers/net/wireless/b43/pcmcia.c
index 3cfc303..6c3a749 100644
--- a/drivers/net/wireless/b43/pcmcia.c
+++ b/drivers/net/wireless/b43/pcmcia.c
@@ -35,6 +35,7 @@
 
 static /*const */ struct pcmcia_device_id b43_pcmcia_tbl[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x448),
+	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x476),
 	PCMCIA_DEVICE_NULL,
 };

