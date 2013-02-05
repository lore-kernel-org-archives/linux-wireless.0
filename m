Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:56752 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab3BEQIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 11:08:21 -0500
From: Jonas Gorski <jogo@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwl8k: add single band 88W8366 PCI device IDs
Date: Tue,  5 Feb 2013 16:59:17 +0100
Message-Id: <1360079957-29411-1-git-send-email-jogo@openwrt.org> (sfid-20130205_170824_855524_F22A6DBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add PCI deviceIDs for single band versions of 88W8366, found e.g. in
simultaneous dual band routers based on kirkwood.

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
---
 drivers/net/wireless/mwl8k.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 2031130..51634f2 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5473,6 +5473,8 @@ static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
 	{ PCI_VDEVICE(MARVELL, 0x2a2b), .driver_data = MWL8687, },
 	{ PCI_VDEVICE(MARVELL, 0x2a30), .driver_data = MWL8687, },
 	{ PCI_VDEVICE(MARVELL, 0x2a40), .driver_data = MWL8366, },
+	{ PCI_VDEVICE(MARVELL, 0x2a41), .driver_data = MWL8366, },
+	{ PCI_VDEVICE(MARVELL, 0x2a42), .driver_data = MWL8366, },
 	{ PCI_VDEVICE(MARVELL, 0x2a43), .driver_data = MWL8366, },
 	{ },
 };
-- 
1.7.10.4

