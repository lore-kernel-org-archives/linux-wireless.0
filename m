Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51295 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab0FMMW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 08:22:28 -0400
Received: by fxm8 with SMTP id 8so1908815fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 05:22:25 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.35 V2] p54pci: add Symbol AP-300 minipci adapters pciid
Cc: Joerg Albert <jal2@gmx.de>,
	John W Linville <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 13 Jun 2010 14:22:23 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006131422.23772.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joerg Albert <jal2@gmx.de>

Cc: stable@kernel.org
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
> On Sunday 13 June 2010, Joerg Albert wrote:
>
> BTW, the 2.4 GHz card in the AP-300 has the same id
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 791e2ae..4357e69 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -42,6 +42,8 @@ static DEFINE_PCI_DEVICE_TABLE(p54p_table) = {
 	{ PCI_DEVICE(0x1260, 0x3877) },
 	/* Intersil PRISM Javelin/Xbow Wireless LAN adapter */
 	{ PCI_DEVICE(0x1260, 0x3886) },
+	/* Intersil PRISM Xbow Wireless LAN adapter (Symbol AP-300) */
+	{ PCI_DEVICE(0x1260, 0xffff) },
 	{ },
 };
 
