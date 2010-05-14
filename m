Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37128 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240Ab0ENXoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 19:44:30 -0400
Received: by wyb36 with SMTP id 36so448863wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 16:44:29 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, herton@mandriva.com.br,
	htl10@users.sourceforge.net, Larry.Finger@lwfinger.net,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] wireless: rtl818x: rtl8180: add ids
Date: Sat, 15 May 2010 01:44:19 +0200
Message-Id: <1273880660-11072-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

taken from windows inf file

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 4801589..6d6140d 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -36,6 +36,7 @@ MODULE_LICENSE("GPL");
 
 static DEFINE_PCI_DEVICE_TABLE(rtl8180_table) = {
 	/* rtl8185 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8184) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8185) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BELKIN, 0x700f) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BELKIN, 0x701f) },
@@ -45,6 +46,8 @@ static DEFINE_PCI_DEVICE_TABLE(rtl8180_table) = {
 	{ PCI_DEVICE(0x1799, 0x6001) },
 	{ PCI_DEVICE(0x1799, 0x6020) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x3300) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x3301) },
+	{ PCI_DEVICE(0x1432, 0x7106) },
 	{ }
 };
 
-- 
1.6.6.1

