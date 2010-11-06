Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33441 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab0KFOtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:35 -0400
Received: by eye27 with SMTP id 27so2216256eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:31 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/18] rt2x00: checkpatch.pl error fixes for rt2400pci.h
Date: Sat, 6 Nov 2010 15:44:00 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011061544.00876.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

rt2400pci.h:812: ERROR: space prohibited after that open parenthesis '('
rt2400pci.h:812: ERROR: space prohibited before that close parenthesis ')'
rt2400pci.h:813: ERROR: space prohibited after that open parenthesis '('
rt2400pci.h:813: ERROR: space prohibited before that close parenthesis ')'
rt2400pci.h:950: ERROR: Macros with complex values should be enclosed in parenthesis

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index c048b18..d3a4a68 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -809,8 +809,8 @@
 /*
  * DMA descriptor defines.
  */
-#define TXD_DESC_SIZE			( 8 * sizeof(__le32) )
-#define RXD_DESC_SIZE			( 8 * sizeof(__le32) )
+#define TXD_DESC_SIZE			(8 * sizeof(__le32))
+#define RXD_DESC_SIZE			(8 * sizeof(__le32))
 
 /*
  * TX descriptor format for TX, PRIO, ATIM and Beacon Ring.
@@ -948,6 +948,6 @@
 	((__CLAMP_TX(__txpower) - MAX_TXPOWER) + MIN_TXPOWER)
 
 #define TXPOWER_TO_DEV(__txpower) \
-	MAX_TXPOWER - (__CLAMP_TX(__txpower) - MIN_TXPOWER)
+	(MAX_TXPOWER - (__CLAMP_TX(__txpower) - MIN_TXPOWER))
 
 #endif /* RT2400PCI_H */
-- 
1.7.2.3

