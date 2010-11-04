Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61775 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab0KDToD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:44:03 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so1281934ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:44:02 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 13/13] rt2x00: Fix comments in rt73usb.h and rt61pci.h
Date: Thu, 4 Nov 2010 20:43:16 +0100
Cc: Lalith Suresh <suresh.lalith@gmail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042041.06812.IvDoorn@gmail.com> <201011042042.37240.IvDoorn@gmail.com>
In-Reply-To: <201011042042.37240.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042043.17468.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lalith Suresh <suresh.lalith@gmail.com>

This patch fixes a few comments in rt73usb.h and rt61pci.h.

Signed-off-by: Lalith Suresh <suresh.lalith@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.h |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index e2e728a..afc803b 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -412,7 +412,7 @@ struct hw_pairwise_ta_entry {
  * DROP_VERSION_ERROR: Drop version error frame.
  * DROP_MULTICAST: Drop multicast frames.
  * DROP_BORADCAST: Drop broadcast frames.
- * ROP_ACK_CTS: Drop received ACK and CTS.
+ * DROP_ACK_CTS: Drop received ACK and CTS.
  */
 #define TXRX_CSR0			0x3040
 #define TXRX_CSR0_RX_ACK_TIMEOUT	FIELD32(0x000001ff)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 44d5b2b..1315ce5 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -322,7 +322,7 @@ struct hw_pairwise_ta_entry {
  * DROP_VERSION_ERROR: Drop version error frame.
  * DROP_MULTICAST: Drop multicast frames.
  * DROP_BORADCAST: Drop broadcast frames.
- * ROP_ACK_CTS: Drop received ACK and CTS.
+ * DROP_ACK_CTS: Drop received ACK and CTS.
  */
 #define TXRX_CSR0			0x3040
 #define TXRX_CSR0_RX_ACK_TIMEOUT	FIELD32(0x000001ff)
-- 
1.7.2.3

