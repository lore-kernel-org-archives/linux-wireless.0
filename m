Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44208 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab0KFOtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:43 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so2253925ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:43 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/18] rt2x00: checkpatch.pl error fixes for rt2800pci.h
Date: Sat, 6 Nov 2010 15:45:22 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061544.52879.IvDoorn@gmail.com> <201011061545.07105.IvDoorn@gmail.com>
In-Reply-To: <201011061545.07105.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061545.23058.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

rt2800pci.h:41: ERROR: Macros with complex values should be enclosed in parenthesis
rt2800pci.h:42: ERROR: Macros with complex values should be enclosed in parenthesis
rt2800pci.h:43: ERROR: Macros with complex values should be enclosed in parenthesis
rt2800pci.h:44: ERROR: Macros with complex values should be enclosed in parenthesis
rt2800pci.h:55: ERROR: space prohibited after that open parenthesis '('
rt2800pci.h:55: ERROR: space prohibited before that close parenthesis ')'
rt2800pci.h:56: ERROR: space prohibited after that open parenthesis '('
rt2800pci.h:56: ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
index 5a8dda9..70e050d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -38,10 +38,10 @@
  * Queue register offset macros
  */
 #define TX_QUEUE_REG_OFFSET		0x10
-#define TX_BASE_PTR(__x)		TX_BASE_PTR0 + ((__x) * TX_QUEUE_REG_OFFSET)
-#define TX_MAX_CNT(__x)			TX_MAX_CNT0 + ((__x) * TX_QUEUE_REG_OFFSET)
-#define TX_CTX_IDX(__x)			TX_CTX_IDX0 + ((__x) * TX_QUEUE_REG_OFFSET)
-#define TX_DTX_IDX(__x)			TX_DTX_IDX0 + ((__x) * TX_QUEUE_REG_OFFSET)
+#define TX_BASE_PTR(__x)		(TX_BASE_PTR0 + ((__x) * TX_QUEUE_REG_OFFSET))
+#define TX_MAX_CNT(__x)			(TX_MAX_CNT0 + ((__x) * TX_QUEUE_REG_OFFSET))
+#define TX_CTX_IDX(__x)			(TX_CTX_IDX0 + ((__x) * TX_QUEUE_REG_OFFSET))
+#define TX_DTX_IDX(__x)			(TX_DTX_IDX0 + ((__x) * TX_QUEUE_REG_OFFSET))
 
 /*
  * 8051 firmware image.
@@ -52,8 +52,8 @@
 /*
  * DMA descriptor defines.
  */
-#define TXD_DESC_SIZE			( 4 * sizeof(__le32) )
-#define RXD_DESC_SIZE			( 4 * sizeof(__le32) )
+#define TXD_DESC_SIZE			(4 * sizeof(__le32))
+#define RXD_DESC_SIZE			(4 * sizeof(__le32))
 
 /*
  * TX descriptor format for TX, PRIO and Beacon Ring.
-- 
1.7.2.3

