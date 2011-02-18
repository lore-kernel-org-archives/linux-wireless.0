Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46223 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1BRN1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 08:27:32 -0500
Received: by bwz15 with SMTP id 15so709668bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 05:27:31 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: xose.vazquez@gmail.com, IvDoorn@gmail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH] wireless: rt2x00: rt2800pci.c: add two ids
Date: Fri, 18 Feb 2011 14:27:09 +0100
Message-Id: <1298035629-12989-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

taken two RT35XX EDIMAX from DPO_RT3562_3592_3062_LinuxSTA_V2.4.1.1_20101217

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index aa97971..7951cda 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1065,6 +1065,8 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x3390), PCI_DEVICE_DATA(&rt2800pci_ops) },
 #endif
 #ifdef CONFIG_RT2800PCI_RT35XX
+	{ PCI_DEVICE(0x1432, 0x7711), PCI_DEVICE_DATA(&rt2800pci_ops) },
+	{ PCI_DEVICE(0x1432, 0x7722), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3060), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3062), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3562), PCI_DEVICE_DATA(&rt2800pci_ops) },
-- 
1.7.4

