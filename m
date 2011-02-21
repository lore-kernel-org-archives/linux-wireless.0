Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18688 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab1BUFLp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 00:11:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 21:11:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <joe@perches.com>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Naveen Singh <nsingh@atheros.com>
Subject: [PATCH] ath6kl: update TODO file / maintainers
Date: Sun, 20 Feb 2011 21:11:41 -0800
Message-ID: <1298265101-28421-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates the TODO file to reflect new changes on development.

Cc: Joe Perches <joe@perches.com>
Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/TODO |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ath6kl/TODO b/drivers/staging/ath6kl/TODO
index d462927..019df4b 100644
--- a/drivers/staging/ath6kl/TODO
+++ b/drivers/staging/ath6kl/TODO
@@ -1,8 +1,25 @@
-- The driver is a stop-gap measure until a proper mac80211 driver is available.
-- The driver does not conform to the Linux coding style.
-- The driver has been tested on a wide variety of embedded platforms running different versions of the Linux kernel but may still have bringup/performance issues with a new platform.
-- Pls use the following link to get information about the driver's architecture, exposed APIs, supported features, limitations, testing, hardware availability and other details.
-	http://wireless.kernel.org/en/users/Drivers/ath6kl
-- Pls send any patches to
+TODO:
+
+We are working hard on cleaning up the driver. There's sooooooooo much todo
+so instead of editign this file please use the wiki:
+
+http://wireless.kernel.org/en/users/Drivers/ath6kl
+
+There's a respective TODO page there. Please also subscribe to the wiki page
+to get e-mail updates on changes.
+
+IRC:
+
+We *really* need to coordinate development for ath6kl as the cleanup
+patches will break pretty much any other patches. Please use IRC to
+help coordinate better:
+
+irc.freenode.net
+#ath6kl
+
+Send patches to:
+
 	- Greg Kroah-Hartman <greg@kroah.com>
-	- Vipin Mehta <vmehta@atheros.com>
+	- Luis R. Rodriguez <mcgrof@gmail.com>
+	- Joe Perches <joe@perches.com>
+	- Naveen Singh <nsingh@atheros.com>
-- 
1.7.4.15.g7811d

