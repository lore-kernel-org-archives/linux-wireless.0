Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59868 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab2DNVd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 17:33:27 -0400
Received: by wgbds11 with SMTP id ds11so6720057wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Apr 2012 14:33:26 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: xose.vazquez@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, IvDoorn@gmail.com,
	linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: [PATCH] wireless: rt2x00: rt2800pci add more RT539x ids
Date: Sat, 14 Apr 2012 23:33:21 +0200
Message-Id: <1334439201-13424-1-git-send-email-xose.vazquez@gmail.com> (sfid-20120414_233400_995842_CD4DDCB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RT539x devices:
(0x1814, 0x5362)
(0x1814, 0x5392)

Taken from ralink driver 2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0397bbf..7968f45 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1184,7 +1184,9 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x3593) },
 #endif
 #ifdef CONFIG_RT2800PCI_RT53XX
+	{ PCI_DEVICE(0x1814, 0x5362) },
 	{ PCI_DEVICE(0x1814, 0x5390) },
+	{ PCI_DEVICE(0x1814, 0x5392) },
 	{ PCI_DEVICE(0x1814, 0x539a) },
 	{ PCI_DEVICE(0x1814, 0x539f) },
 #endif
-- 
1.7.6.5

