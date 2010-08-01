Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0HAUjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 16:39:23 -0400
Date: Sun, 01 Aug 2010 15:40:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, chunkeey@web.de
Cc: olbrannon@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] p54pci: Add PCI ID for SMC2802W
Message-ID: <4c55dba4.XXR/v2S5PwU13tOb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SMC2802W appears to work with p54pci.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: David Cozatt <olbrannon@gmail.com>
---

Index: wireless-testing/drivers/net/wireless/p54/p54pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54pci.c
+++ wireless-testing/drivers/net/wireless/p54/p54pci.c
@@ -43,6 +43,8 @@ static DEFINE_PCI_DEVICE_TABLE(p54p_tabl
 	{ PCI_DEVICE(0x1260, 0x3886) },
 	/* Intersil PRISM Xbow Wireless LAN adapter (Symbol AP-300) */
 	{ PCI_DEVICE(0x1260, 0xffff) },
+	/* Standard Microsystems Corp SMC2802W Wireless PCI */
+	{ PCI_DEVICE(0x10b8, 0x2802) },
 	{ },
 };
 
