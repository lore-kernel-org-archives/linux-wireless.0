Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39131 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553AbZHQQ43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 12:56:29 -0400
Received: by ewy10 with SMTP id 10so3097904ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 09:56:29 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/7] rt2x00: Add new RF chip defines
Date: Mon, 17 Aug 2009 18:54:47 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <200908171853.24256.IvDoorn@gmail.com> <200908171853.57397.IvDoorn@gmail.com>
In-Reply-To: <200908171853.57397.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200908171854.48086.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new defines for RF chipsets which can be found
by the driver. We don't have to check for these
chips specifically yet, but it is better to have
the defines in now.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
index a79a6d9..4d9991c 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -36,6 +36,9 @@
  * RF2750 2.4G/5G 1T2R
  * RF3020 2.4G 1T1R
  * RF2020 2.4G B/G
+ * RF3021 2.4G 1T2R
+ * RF3022 2.4G 2T2R
+ * RF3052 2.4G 2T2R
  */
 #define RF2820				0x0001
 #define RF2850				0x0002
@@ -43,6 +46,9 @@
 #define RF2750				0x0004
 #define RF3020				0x0005
 #define RF2020				0x0006
+#define RF3021				0x0007
+#define RF3022				0x0008
+#define RF3052				0x0009
 
 /*
  * RT2870 version
-- 
1.6.4

