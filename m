Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42031 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1CCSvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:51:04 -0500
Received: by wyg36 with SMTP id 36so1359358wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:51:03 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/19] rt2x00: Fix comment in rt2800pci
Date: Thu, 3 Mar 2011 19:45:39 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031944.54527.IvDoorn@gmail.com> <201103031945.17614.IvDoorn@gmail.com>
In-Reply-To: <201103031945.17614.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031945.40473.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

We don't use interrupt threads anymore. Fix the comment.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 7e610f6..b74a9d7 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -835,7 +835,7 @@ static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 	 *
 	 * Furthermore we don't disable the TX_FIFO_STATUS
 	 * interrupt here but leave it enabled so that the TX_STA_FIFO
-	 * can also be read while the interrupt thread gets executed.
+	 * can also be read while the tx status tasklet gets executed.
 	 *
 	 * Since we have only one producer and one consumer we don't
 	 * need to lock the kfifo.
-- 
1.7.2.3

