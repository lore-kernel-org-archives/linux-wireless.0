Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64122 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1HaSn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 14:43:58 -0400
Received: by eyx24 with SMTP id 24so1041321eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 11:43:57 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Add new chipset support
Date: Wed, 31 Aug 2011 20:43:52 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201108312043.53795.IvDoorn@gmail.com> (sfid-20110831_204400_879733_147267B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: zero.lin <zero.lin@ralinktech.com>

Signed-off-by: zero.lin <zero.lin@ralinktech.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 7a0fd0e..854d4ce 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1153,6 +1153,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 #endif
 #ifdef CONFIG_RT2800PCI_RT53XX
 	{ PCI_DEVICE(0x1814, 0x5390) },
+	{ PCI_DEVICE(0x1814, 0x539a) },
 	{ PCI_DEVICE(0x1814, 0x539f) },
 #endif
 	{ 0, }
