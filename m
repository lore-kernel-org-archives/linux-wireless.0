Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54054 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3BAN3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 08:29:18 -0500
Received: by mail-wg0-f41.google.com with SMTP id ds1so1274105wgb.4
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2013 05:29:16 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next] wireless: rt2x00: rt2800pci add id
Date: Fri,  1 Feb 2013 14:28:49 +0100
Message-Id: <1359725329-8027-1-git-send-email-xose.vazquez@gmail.com> (sfid-20130201_142921_837468_071BD517)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0x1814,0x359f is a RT3592 802.11a/b/g/n 2x2 WiFi Adapter
support added by 872834dfb38edc6f72cfc783a5ce78f2a9f36ec5

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0e8d170..48a01aa 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1152,6 +1152,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x3562) },
 	{ PCI_DEVICE(0x1814, 0x3592) },
 	{ PCI_DEVICE(0x1814, 0x3593) },
+	{ PCI_DEVICE(0x1814, 0x359f) },
 #endif
 #ifdef CONFIG_RT2800PCI_RT53XX
 	{ PCI_DEVICE(0x1814, 0x5360) },
-- 
1.7.11.7

