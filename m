Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52052 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbXKYBf1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 20:35:27 -0500
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 01F0F618FE1
	for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2007 20:35:25 -0500 (EST)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] rtl8180: add ID for Belkin F5D7010 v7
To: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2007 20:35:25 -0500
Message-ID: <20071125013525.22549.71479.stgit@dv.roinet.com> (sfid-20071125_013530_239129_25822E13)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/rtl8180_dev.c |    1 +
 include/linux/pci_ids.h            |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index a2a6791..808bae4 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -32,6 +32,7 @@ MODULE_LICENSE("GPL");
 
 static struct pci_device_id rtl8180_table[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8185) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BELKIN, 0x701f) },
 	{ }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1ee009e..e420d39 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2074,6 +2074,9 @@
 #define PCI_DEVICE_ID_ALTIMA_AC9100	0x03ea
 #define PCI_DEVICE_ID_ALTIMA_AC1003	0x03eb
 
+#define PCI_VENDOR_ID_BELKIN		0x1799
+#define PCI_DEVICE_ID_BELKIN_F5D7010V7	0x701f
+
 #define PCI_VENDOR_ID_LENOVO		0x17aa
 
 #define PCI_VENDOR_ID_ARECA		0x17d3
