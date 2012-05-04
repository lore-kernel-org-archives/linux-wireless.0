Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63247 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2EDBvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 21:51:36 -0400
Received: by pbbrp8 with SMTP id rp8so3195991pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 18:51:36 -0700 (PDT)
From: Zero Lin <zero.lin.0203@gmail.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Zero.Lin" <Zero.Lin@mediatek.com>
Subject: [PATCH] rt2x00:Add RT539B chipset support
Date: Fri,  4 May 2012 09:51:06 +0800
Message-Id: <1336096266-25790-1-git-send-email-zero.lin.0203@gmail.com> (sfid-20120504_035139_959541_D098562D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Zero.Lin" <Zero.Lin@mediatek.com>

Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 931331d..0c9b51d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1193,6 +1193,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x5392) },
 	{ PCI_DEVICE(0x1814, 0x539a) },
 	{ PCI_DEVICE(0x1814, 0x539f) },
+	{ PCI_DEVICE(0x1814, 0x539b) },
 #endif
 	{ 0, }
 };
-- 
1.7.5.4

