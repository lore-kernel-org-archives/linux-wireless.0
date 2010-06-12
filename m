Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45520 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0FLWyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 18:54:55 -0400
Received: by bwz7 with SMTP id 7so1224345bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jun 2010 15:54:53 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54pci: add Symbol AP-300 5GHz minipci adapter pciid
Date: Sun, 13 Jun 2010 00:54:51 +0200
Cc: Joerg Albert <jal2@gmx.de>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006130054.52075.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joerg Albert <jal2@gmx.de>

Cc: stable@kernel.org
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 791e2ae..4357e69 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -42,6 +42,8 @@ static DEFINE_PCI_DEVICE_TABLE(p54p_table) = {
 	{ PCI_DEVICE(0x1260, 0x3877) },
 	/* Intersil PRISM Javelin/Xbow Wireless LAN adapter */
 	{ PCI_DEVICE(0x1260, 0x3886) },
+	/* Intersil PRISM Xbow Wireless LAN adapter (Symbol AP-300 5GHz) */
+	{ PCI_DEVICE(0x1260, 0xffff) },
 	{ },
 };
 
