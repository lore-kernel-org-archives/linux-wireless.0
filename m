Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58832 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab0ALMry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:47:54 -0500
Date: Tue, 12 Jan 2010 13:47:53 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 05/17] mwl8k: add another 88w8366 PCI ID
Message-ID: <20100112124753.GU1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0x2a43 is a single-band (2.4GHz only) 88w8366 mini-PCIe card.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 7d165be..76da583 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3740,6 +3740,7 @@ static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
 	{ PCI_VDEVICE(MARVELL, 0x2a2b), .driver_data = MWL8687, },
 	{ PCI_VDEVICE(MARVELL, 0x2a30), .driver_data = MWL8687, },
 	{ PCI_VDEVICE(MARVELL, 0x2a40), .driver_data = MWL8366, },
+	{ PCI_VDEVICE(MARVELL, 0x2a43), .driver_data = MWL8366, },
 	{ },
 };
 MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
-- 
1.5.6.4
