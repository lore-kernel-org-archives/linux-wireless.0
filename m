Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56285 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2FOP1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 11:27:09 -0400
Received: by wgbdr13 with SMTP id dr13so3233367wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 08:27:08 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	xose.vazquez@gmail.com
Subject: [PATCH] wireless: rtl818x: rtl8180 add devices ids
Date: Fri, 15 Jun 2012 17:27:05 +0200
Message-Id: <1339774025-16246-1-git-send-email-xose.vazquez@gmail.com> (sfid-20120615_172714_011032_8C7C28EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

from windows driver:
0x1186, 0x3301 D-Link Air DWL-510 Wireless PCI Adapter
0x1432, 0x7106 LevelOne WPC-0101 11Mbps Wireless PCMCIA CardBus Adapter

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 2bebcb7..3b50539 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -47,6 +47,8 @@ static DEFINE_PCI_DEVICE_TABLE(rtl8180_table) = {
 	{ PCI_DEVICE(0x1799, 0x6001) },
 	{ PCI_DEVICE(0x1799, 0x6020) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x3300) },
+	{ PCI_DEVICE(0x1186, 0x3301) },
+	{ PCI_DEVICE(0x1432, 0x7106) },
 	{ }
 };
 
-- 
1.7.10.2

