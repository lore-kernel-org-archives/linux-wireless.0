Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:39194 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZBUHxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 02:53:40 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 4/4] at76c50x-usb: add link to the TODO list
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Sat, 21 Feb 2009 09:53:37 +0200
Message-ID: <20090221075336.15991.15887.stgit@tikku> (sfid-20090221_085343_109034_9501B45E)
In-Reply-To: <20090221075013.15991.66595.stgit@tikku>
References: <20090221075013.15991.66595.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's easier to have the TODO list in wiki, so add a link to the list.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76c50x-usb.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 64d4192..cc2a267 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -18,14 +18,10 @@
  *
  * Some iw_handler code was taken from airo.c, (C) 1999 Benjamin Reed
  *
- * TODO for the mac80211 port:
- * o adhoc support
- * o RTS/CTS support
- * o Power Save Mode support
- * o support for short/long preambles
- * o export variables through debugfs/sysfs
- * o remove hex2str
- * o remove mac2str
+ * TODO list is at the wiki:
+ *
+ * http://wireless.kernel.org/en/users/Drivers/at76c50x-usb#TODO
+ *
  */
 
 #include <linux/init.h>

