Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:47156 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1GIO4N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 10:56:13 -0400
Date: Sat, 9 Jul 2011 16:50:01 +0200
From: Adrien Nader <adrien@notk.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.0.0-rc6] rt2x00: add Ralink 0x539f to PCI_DEVICE_TABLE
Message-ID: <20110709145001.GA6938@notk.org> (sfid-20110709_165623_088610_9F90403B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actual support for this card which is to be found in HP dm1* laptops is
already there for the 5390. This only adds the device id to the list of
hardware handled by the driver.

Signed-off-by: Adrien Nader <adrien@notk.org>
---
It also changes some spaces into tabs to be be consistent with the
previous lines (it lined up correctly only if you have tabs set to 8
spaces).

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index cc4a54f..55cd3e1 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1158,6 +1158,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 #endif
 #ifdef CONFIG_RT2800PCI_RT53XX
 	{ PCI_DEVICE(0x1814, 0x5390) },
+	{ PCI_DEVICE(0x1814, 0x539f) },
 #endif
 	{ 0, }
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index c446db6..5c5b6a8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -190,7 +190,7 @@ struct rt2x00_chip {
 #define RT3572		0x3572
 #define RT3593		0x3593	/* PCIe */
 #define RT3883		0x3883	/* WSOC */
-#define RT5390         0x5390  /* 2.4GHz */
+#define RT5390		0x5390	/* 2.4GHz */
 
 	u16 rf;
 	u16 rev;
