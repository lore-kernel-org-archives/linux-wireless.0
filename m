Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:64370 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab0DZISW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 04:18:22 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1880891fgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 01:18:20 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: fix typo in rt2800.h
Date: Mon, 26 Apr 2010 10:18:08 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201004261018.08830.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a typo in a comment in rt2800.h. Instead of replacing the wrong
hexvalue (0x171c) with the correct one (0x1718) just use the appropriate
readable define.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index ec89372..3492825 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -107,7 +107,7 @@
 /*
  * INT_SOURCE_CSR: Interrupt source register.
  * Write one to clear corresponding bit.
- * TX_FIFO_STATUS: FIFO Statistics is full, sw should read 0x171c
+ * TX_FIFO_STATUS: FIFO Statistics is full, sw should read TX_STA_FIFO
  */
 #define INT_SOURCE_CSR			0x0200
 #define INT_SOURCE_CSR_RXDELAYINT	FIELD32(0x00000001)
-- 
1.6.4.2

