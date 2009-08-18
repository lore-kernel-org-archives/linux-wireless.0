Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:55057 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZHRXos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 19:44:48 -0400
Received: by ey-out-2122.google.com with SMTP id 22so859354eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 16:44:49 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: remove spare whitespace
Date: Wed, 19 Aug 2009 00:44:43 +0100
Message-Id: <1250639083-18327-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---

Noticed while investigating false positive sparse complaint.
Really trivial.

---
 drivers/net/wireless/orinoco/wext.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 3e56f76..7698fdd 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -1291,7 +1291,7 @@ static int orinoco_ioctl_setibssport(struct net_device *dev,
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
-	priv->ibss_port = val ;
+	priv->ibss_port = val;
 
 	/* Actually update the mode we are using */
 	set_port_type(priv);
-- 
1.6.3.3

