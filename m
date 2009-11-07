Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37929 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521AbZKGWDY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 17:03:24 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 22:03:22 +0000
Message-ID: <1257631402.15927.475.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 57/75] zd1211rw: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index d46f20a..ac19ecd 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -318,6 +318,13 @@ error:
 	return r;
 }
 
+MODULE_FIRMWARE(FW_ZD1211B_PREFIX "ur");
+MODULE_FIRMWARE(FW_ZD1211_PREFIX "ur");
+MODULE_FIRMWARE(FW_ZD1211B_PREFIX "ub");
+MODULE_FIRMWARE(FW_ZD1211_PREFIX "ub");
+MODULE_FIRMWARE(FW_ZD1211B_PREFIX "uphr");
+MODULE_FIRMWARE(FW_ZD1211_PREFIX "uphr");
+
 /* Read data from device address space using "firmware interface" which does
  * not require firmware to be loaded. */
 int zd_usb_read_fw(struct zd_usb *usb, zd_addr_t addr, u8 *data, u16 len)
-- 
1.6.5.2



