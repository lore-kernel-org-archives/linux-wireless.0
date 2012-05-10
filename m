Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42083 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2EJCHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 22:07:09 -0400
Received: by dady13 with SMTP id y13so1056219dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 19:07:09 -0700 (PDT)
From: Zero Lin <zero.lin.0203@gmail.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Zero.Lin" <Zero.Lin@mediatek.com>
Subject: [PATCH] rt2x00:Add RT539b chipset support
Date: Thu, 10 May 2012 10:06:31 +0800
Message-Id: <1336615591-2017-1-git-send-email-zero.lin.0203@gmail.com> (sfid-20120510_040714_703246_281F1EF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Zero.Lin" <Zero.Lin@mediatek.com>

Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 931331d..cad25bf 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1192,6 +1192,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x5390) },
 	{ PCI_DEVICE(0x1814, 0x5392) },
 	{ PCI_DEVICE(0x1814, 0x539a) },
+	{ PCI_DEVICE(0x1814, 0x539b) },
 	{ PCI_DEVICE(0x1814, 0x539f) },
 #endif
 	{ 0, }
-- 
1.7.5.4

