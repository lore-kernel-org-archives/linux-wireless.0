Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62306 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0C1PsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 11:48:22 -0400
Received: by bwz1 with SMTP id 1so2977222bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 08:48:20 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, linville@tuxdriver.com,
	IvDoorn@gmail.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/3] wireless: rt2x00: rt2800pci: new id
Date: Sun, 28 Mar 2010 17:48:05 +0200
Message-Id: <1269791285-8678-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taken from latest ralink linux driver, it's a RT3593 PCI/PCIe.

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b1f5643..ce7e88e 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1212,6 +1212,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x3062), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3562), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3592), PCI_DEVICE_DATA(&rt2800pci_ops) },
+	{ PCI_DEVICE(0x1814, 0x3593), PCI_DEVICE_DATA(&rt2800pci_ops) },
 #endif
 	{ 0, }
 };
-- 
1.6.6.1

