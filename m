Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:39265 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0CSAwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 20:52:25 -0400
Message-ID: <4BA2C952.8060107@ludd.ltu.se>
Date: Fri, 19 Mar 2010 01:46:10 +0100
From: Benjamin Larsson <banan@ludd.ltu.se>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com
Subject: [PATCH] Add a pci-id to the mwl8k driver
Content-Type: multipart/mixed;
 boundary="------------010808010502030608080204"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010808010502030608080204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Benjamin Larsson <banan@ludd.ltu.se>

MvH
Benjamin Larsson

--------------010808010502030608080204
Content-Type: text/x-patch;
 name="pci-id.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pci-id.patch"

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ac65e13..4e58ebe 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3851,6 +3851,7 @@ MODULE_FIRMWARE("mwl8k/helper_8366.fw");
 MODULE_FIRMWARE("mwl8k/fmimage_8366.fw");
 
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
+	{ PCI_VDEVICE(MARVELL, 0x2a0a), .driver_data = MWL8363, },
 	{ PCI_VDEVICE(MARVELL, 0x2a0c), .driver_data = MWL8363, },
 	{ PCI_VDEVICE(MARVELL, 0x2a24), .driver_data = MWL8363, },
 	{ PCI_VDEVICE(MARVELL, 0x2a2b), .driver_data = MWL8687, },

--------------010808010502030608080204--
