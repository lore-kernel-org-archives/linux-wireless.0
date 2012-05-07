Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56498 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab2EGDfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 23:35:14 -0400
Received: by dady13 with SMTP id y13so712965dad.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2012 20:35:13 -0700 (PDT)
From: Zero Lin <zero.lin.0203@gmail.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Zero.Lin" <Zero.Lin@mediatek.com>
Subject: [PATCH] rt2x00:Add RT539B chipset support V2
Date: Mon,  7 May 2012 11:34:42 +0800
Message-Id: <1336361682-2771-1-git-send-email-zero.lin.0203@gmail.com> (sfid-20120507_053545_046339_CA8026B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Zero.Lin" <Zero.Lin@mediatek.com>

Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0c9b51d..cad25bf 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1192,8 +1192,8 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x5390) },
 	{ PCI_DEVICE(0x1814, 0x5392) },
 	{ PCI_DEVICE(0x1814, 0x539a) },
-	{ PCI_DEVICE(0x1814, 0x539f) },
 	{ PCI_DEVICE(0x1814, 0x539b) },
+	{ PCI_DEVICE(0x1814, 0x539f) },
 #endif
 	{ 0, }
 };
-- 
1.7.5.4

