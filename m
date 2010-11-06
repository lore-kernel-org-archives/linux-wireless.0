Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44208 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0KFOtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:33 -0400
Received: by ewy7 with SMTP id 7so2253925ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:32 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/18] rt2x00: checkpatch.pl error fixes for rt2500pci.h
Date: Sat, 6 Nov 2010 15:44:15 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com>
In-Reply-To: <201011061544.00876.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061544.16363.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

rt2500pci.h:1091: ERROR: space prohibited after that open parenthesis '('
rt2500pci.h:1091: ERROR: space prohibited before that close parenthesis ')'
rt2500pci.h:1092: ERROR: space prohibited after that open parenthesis '('
rt2500pci.h:1092: ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index d708031..2aad7ba 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -1088,8 +1088,8 @@
 /*
  * DMA descriptor defines.
  */
-#define TXD_DESC_SIZE			( 11 * sizeof(__le32) )
-#define RXD_DESC_SIZE			( 11 * sizeof(__le32) )
+#define TXD_DESC_SIZE			(11 * sizeof(__le32))
+#define RXD_DESC_SIZE			(11 * sizeof(__le32))
 
 /*
  * TX descriptor format for TX, PRIO, ATIM and Beacon Ring.
-- 
1.7.2.3

