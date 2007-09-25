Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:30041 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbXIYSoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:55 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1757580nfb
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:54 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/12] rt2x00: Fix obvious typo in comment
Date: Tue, 25 Sep 2007 20:57:25 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252057.25939.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Modestas Vainius <modestas@vainius.eu>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 929257d..842da90 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -244,7 +244,7 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
 	return rt2x00_get_field32(reg, GPIOCSR_BIT0);
 }
-#endif /* CONFIG_RT2400PCI_RFKILL */
+#endif /* CONFIG_RT2500PCI_RFKILL */
 
 /*
  * Configuration handlers.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 4c5e317..6aa5176 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -269,7 +269,7 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
 	return rt2x00_get_field32(reg, MAC_CSR13_BIT5);;
 }
-#endif /* CONFIG_RT2400PCI_RFKILL */
+#endif /* CONFIG_RT61PCI_RFKILL */
 
 /*
  * Configuration handlers.
-- 
1.5.3.2

