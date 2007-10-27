Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:14484 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbXJ0LZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:24 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1035387fkz
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:24 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/21] rt2x00: Remove unused variables
Date: Sat, 27 Oct 2007 13:42:18 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271342.18801.IvDoorn@gmail.com> (sfid-20071027_124129_228156_C1778FD4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the updated antenna setup the following
variables are no longer used.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0839946..0b8aeec 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -527,11 +527,9 @@ static void rt61pci_config_antenna_2529_rx(struct rt2x00_dev *rt2x00dev,
 static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
 					struct antenna_setup *ant)
 {
-	u16 eeprom;
 	u8 r3;
 	u8 r4;
 	u8 r77;
-	u8 rx_ant;
 
 	rt61pci_bbp_read(rt2x00dev, 3, &r3);
 	rt61pci_bbp_read(rt2x00dev, 4, &r4);
-- 
1.5.3.4

