Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37924 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490AbZKGWCm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 17:02:42 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Jeroen Vreeken <pe1rxq@amsat.org>, linux-usb@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 22:02:39 +0000
Message-ID: <1257631359.15927.472.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 56/75] zd1201: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/zd1201.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index bc81974..33c8be7 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -112,6 +112,9 @@ exit:
 	return err;
 }
 
+MODULE_FIRMWARE("zd1201-ap.fw");
+MODULE_FIRMWARE("zd1201.fw");
+
 static void zd1201_usbfree(struct urb *urb)
 {
 	struct zd1201 *zd = urb->context;
-- 
1.6.5.2



