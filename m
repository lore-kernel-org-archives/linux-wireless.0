Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:11448 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbYKJHBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 02:01:10 -0500
Received: by ey-out-2122.google.com with SMTP id 6so864190eyi.37
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2008 23:01:09 -0800 (PST)
Message-ID: <eb3ff54b0811092301i24cf5e63lf6166b620aa0b78b@mail.gmail.com> (sfid-20081110_080116_322817_FB20737F)
Date: Mon, 10 Nov 2008 09:01:09 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH ] mac80211: remove unnecessary include.
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary #include <linux/netdevice.h> from
/net/mac80211/mlme.c.


Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 49f86fa..bd74680 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -14,7 +14,6 @@
 #include <linux/delay.h>
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
 #include <linux/random.h>
