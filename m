Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33441 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0KFOtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:47 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so2216256eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:46 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/18] rt2x00: checkpatch.pl error fixes for rt2800usb.h
Date: Sat, 6 Nov 2010 15:45:58 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061545.23058.IvDoorn@gmail.com> <201011061545.42379.IvDoorn@gmail.com>
In-Reply-To: <201011061545.42379.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061545.59571.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

rt2800usb.h:43: ERROR: space prohibited after that open parenthesis '('
rt2800usb.h:43: ERROR: space prohibited before that close parenthesis ')'
rt2800usb.h:44: ERROR: space prohibited after that open parenthesis '('
rt2800usb.h:44: ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
index 0722bad..671ea35 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -40,8 +40,8 @@
 /*
  * DMA descriptor defines.
  */
-#define TXINFO_DESC_SIZE		( 1 * sizeof(__le32) )
-#define RXINFO_DESC_SIZE		( 1 * sizeof(__le32) )
+#define TXINFO_DESC_SIZE		(1 * sizeof(__le32))
+#define RXINFO_DESC_SIZE		(1 * sizeof(__le32))
 
 /*
  * TX Info structure
-- 
1.7.2.3

